--pivot table to view how members use bikes throughout the week
SELECT member_casual, 
	COUNT(CASE WHEN day_of_week = 'Sunday' THEN 1 ELSE NULL END) AS Sunday,
	COUNT(CASE WHEN day_of_week = 'Monday' THEN 1 ELSE NULL END) AS Monday,
	COUNT(CASE WHEN day_of_week = 'Tuesday' THEN 1 ELSE NULL END) AS Tuesday,
	COUNT(CASE WHEN day_of_week = 'Wednesday' THEN 1 ELSE NULL END) AS Wednesday,
	COUNT(CASE WHEN day_of_week = 'Thursday' THEN 1 ELSE NULL END) AS Thursday,
	COUNT(CASE WHEN day_of_week = 'Friday' THEN 1 ELSE NULL END) AS Friday,
	COUNT(CASE WHEN day_of_week = 'Saturday' THEN 1 ELSE NULL END) AS Saturday
FROM ChuckBicycleYearly
GROUP BY member_casual

--average ride times in minutes by member type
SELECT member_casual as member_type, COUNT(ride_id) as bike_rentals, SUM(ride_time) ride_length, AVG(ride_time) as average_ride_lenth
FROM ChuckBicycleYearly
GROUP BY member_casual 


--line graph displays bike rentals throughout the months by member type
SELECT member_casual as member_type, CAST(started_at as date) as date, COUNT(ride_id) as bikes_rentals
FROM ChuckBicycleYearly
GROUP BY member_casual, CAST(started_at as date)

--ride_able type table
select rideable_type, count(case when member_casual = 'casual' then 1 else null end) as Casual, 
count(case when member_casual = 'member' then 1 else null end) as Member, total = count(member_casual)
from ChuckBicycleYearly
group by rideable_type

--pivot table to view rideable types by member type
SELECT member_casual, 
		COUNT(CASE WHEN rideable_type = 'electric_bike' THEN 1 ELSE NULL END) electric,
		COUNT(CASE WHEN rideable_type = 'classic_bike' THEN 1 ELSE NULL END) classic,
		COUNT(CASE WHEN rideable_type = 'docked_bike' THEN 1 ELSE NULL END) docked
FROM ChuckBicycleYearly
GROUP BY member_casual

--group total rentals by member type and bike type
SELECT member_casual as member_type, rideable_type, COUNT(rideable_type) as bike_rentals
FROM ChuckBicycleYearly
GROUP BY member_casual, rideable_type
