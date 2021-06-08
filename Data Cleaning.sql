--Nashville, TN Housing Data Cleaning
-------------------------------------
--Break down PropertyAddress into individual comlumns (Address and City)

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address, 
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as City
From PortfolioProject..NashvilleHousing

Use PortfolioProject
Alter Table NashvilleHousing
Add PropertyStreetAddress Nvarchar(255)
Alter Table NashvilleHousing
Add PropertyCity nvarchar(255)

Update NashvilleHousing
Set PropertyStreetAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) 
Update NashvilleHousing
Set PropertyCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))
--------------------------------------------------------------------------------------------------------

--Break down OwnerAddress into three columns (Address, City, State)

Select
PARSENAME(Replace(OwnerAddress, ',', '.'), 3),
PARSENAME(Replace(OwnerAddress, ',', '.'), 2),
PARSENAME(Replace(OwnerAddress, ',', '.'), 1)
From PortfolioProject..NashvilleHousing

Use PortfolioProject
Alter Table NashvilleHousing
Add OwnerStreeAddress nvarchar(255)
Alter Table NashvilleHousing
Add OwnerCity nvarchar(255)
Alter Table NashvilleHousing
Add OwnerState nvarchar(255)

Use PortfolioProject
Update dbo.NashvilleHousing
Set OwnerState = PARSENAME(Replace(OwnerAddress, ',', '.'), 1)
Update dbo.NashvilleHousing
Set OwnerCity = PARSENAME(Replace(OwnerAddress, ',', '.'), 2)
Update dbo.NashvilleHousing
Set OwnerStreeAddress = PARSENAME(Replace(OwnerAddress, ',', '.'), 3)
----------------------------------------------------------------------

--Change n, N, no values to 'No' and y, Y, yes values to 'Yes' in "Sold as Vacant" column

Select Distinct SoldAsVacant, COUNT(SoldAsVacant)
From PortfolioProject..NashvilleHousing
Group by SoldAsVacant
Order by 1

Update NashvilleHousing
Set SoldAsVacant = 
CASE when SoldAsVacant = 'Y' or SoldAsVacant = 'y' or SoldAsVacant = 'yes' then 'Yes'
		when SoldAsVacant = 'N' or SoldAsVacant = 'n' or SoldAsVacant = 'no' then 'No'
		else SoldAsVacant
		END
---------------------------------------------------------------------------------------

--Standardize date format to get rid of time value that gets added on

Select SaleDate
from PortfolioProject..NashvilleHousing

Alter Table NashvilleHousing
Alter Column SaleDate Date;
----------------------------------------

--Populate missing property addresses 
--Check if ParcelID exists elsewhere with different UniqueID, then return address

Select *
from PortfolioProject..NashvilleHousing
Where PropertyAddress is null

Select a.[UniqueID ], a.ParcelID, a.PropertyAddress, b.[UniqueID ], b.ParcelID, b.PropertyAddress
From PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
On a.ParcelID = b.ParcelID
and a.[UniqueID ] != b.[UniqueID ]
Where a.PropertyAddress is null
or b.PropertyAddress is null

Update a
Set PropertyAddress = b.PropertyAddress
From PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
On a.ParcelID = b.ParcelID
and a.[UniqueID ] != b.[UniqueID ]
where a.PropertyAddress is null
-------------------------------------------









