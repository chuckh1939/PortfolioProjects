--change datatype of columns that is inconsistent with other months in dataset in preperation of union
ALTER TABLE dbo.['202102-divvy-tripdata$']
ALTER column end_station_id nvarchar(255)

ALTER TABLE dbo.['202111-divvy-tripdata$']
ALTER column start_station_id nvarchar(255)


--combine 12 monthly tables into one large table for analysis
CREATE TABLE ChuckBicycleYearly(
	ride_id nvarchar(255),
	rideable_type nvarchar(255),
	started_at datetime,
	ended_at datetime,
	start_station_name nvarchar(255),
	start_station_id nvarchar(255),
	end_station_name nvarchar(255),
	end_station_id nvarchar(255),
	start_lat float,
	start_lng float,
	end_lat float,
	end_lng float,
	member_casual nvarchar(255)
	)

INSERT INTO DBO.ChuckBicycleYearly
SELECT * FROM dbo.['202102-divvy-tripdata$']
UNION	
SELECT * FROM dbo.['202103-divvy-tripdata$']
UNION
SELECT * FROM dbo.['202104-divvy-tripdata$']
UNION	
SELECT * FROM dbo.['202105-divvy-tripdata$']
UNION
SELECT * FROM dbo.['202106-divvy-tripdata$']
UNION	
SELECT * FROM dbo.['202107-divvy-tripdata$']
UNION
SELECT * FROM dbo.['202108-divvy-tripdata$']
UNION	
SELECT * FROM dbo.['202109-divvy-tripdata$']
UNION
SELECT * FROM dbo.['202110-divvy-tripdata$']
UNION	
SELECT * FROM dbo.['202111-divvy-tripdata$']
UNION
SELECT * FROM dbo.['202112-divvy-tripdata$']
UNION	
SELECT * FROM dbo.['202201-divvy-tripdata$']

--check for duplicates
Select ride_id, COUNT(ride_id)
From ChuckBicycleYearly
GROUP BY  ride_id
HAVING COUNT(*) > 1

--add new column and calculate bike ride time as a decimal
Alter Table ChuckBicycleYearly
Add ride_time FLOAT

UPDATE ChuckBicycleYearly
SET ride_time = CAST(DATEDIFF(SECOND, started_at, ended_at) AS FLOAT)

UPDATE ChuckBicycleYearly
SET ride_time = ride_time / 60

--3,980 rows deleted where rental length was over 24 hours, which is time limit. Some rentals were almost a month in length
--perhaps these are customer who did not return bike, or forgot
--these outliers would skew analysis
DELETE FROM ChuckBicycleYearly
WHERE DATEDIFF(HOUR, started_at, ended_at) > 24

--22,879 rows deleted that were only a few seconds in length -- perhaps accidental or customer changed mind
DELETE From ChuckBicycleYearly
Where ride_time <= '00:00:10'

--145 rows deleted with start and end time entered either backwards or incorrectly
DELETE From ChuckBicycleYearly
Where started_at > ended_at

--add new column and populate for day of the week
ALTER TABLE ChuckBicycleYearly
ADD day_of_week nvarchar(255)

UPDATE ChuckBicycleYearly
SET day_of_week = DATENAME(WEEKDAY, started_at)
