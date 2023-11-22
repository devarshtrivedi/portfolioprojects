/*

Cleaning Data in SQL Queries

*/

SELECT * FROM [portfolio project]..NashvilleHousing

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

alter table [portfolio project]..NashvilleHousing
add SaleDate2 date;

update [portfolio project]..NashvilleHousing
set SaleDate2=CONVERT(date,saledate); 

SELECT SaleDate2 FROM [portfolio project]..NashvilleHousing

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

SELECT * FROM [portfolio project]..NashvilleHousing
-- where PropertyAddress is null
order by ParcelID

SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress) 
FROM [portfolio project]..NashvilleHousing a
join [portfolio project]..NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress) 
FROM [portfolio project]..NashvilleHousing a
join [portfolio project]..NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Breaking out address into individual column(Address,City,Sate)

SELECT PropertyAddress FROM [portfolio project]..NashvilleHousing
-- where PropertyAddress is null
-- order by ParcelID

select 
SUBSTRING(propertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(propertyAddress,CHARINDEX(',',PropertyAddress)+ 1,LEN(PropertyAddress)) as Address
FROM [portfolio project]..NashvilleHousing


alter table [portfolio project]..NashvilleHousing
add PropertySplitAddress Varchar(255);

update [portfolio project]..NashvilleHousing
set PropertySplitAddress=SUBSTRING(propertyAddress,1,CHARINDEX(',',PropertyAddress)-1)


alter table [portfolio project]..NashvilleHousing
add PropertySplitCity varchar(255);

update [portfolio project]..NashvilleHousing
set PropertySplitCity=SUBSTRING(propertyAddress,CHARINDEX(',',PropertyAddress)+ 1,LEN(PropertyAddress))


SELECT OwnerAddress 
FROM [portfolio project]..NashvilleHousing


select
PARSENAME(replace (OwnerAddress,',','.'),3),
PARSENAME(replace (OwnerAddress,',','.'),2),
PARSENAME(replace (OwnerAddress,',','.'),1)
FROM [portfolio project]..NashvilleHousing


alter table [portfolio project]..NashvilleHousing
add OwnerSplitAddress NVarchar(255);

update [portfolio project]..NashvilleHousing
set OwnerSplitAddress=PARSENAME(replace (OwnerAddress,',','.'),3)

alter table [portfolio project]..NashvilleHousing
add OwnerSplitCity NVarchar(255);

update [portfolio project]..NashvilleHousing
set OwnerSplitCity=PARSENAME(replace (OwnerAddress,',','.'),2)

alter table [portfolio project]..NashvilleHousing
add OwnerSplitState NVarchar(255);

update [portfolio project]..NashvilleHousing
set OwnerSplitState=PARSENAME(replace (OwnerAddress,',','.'),1)

SELECT * FROM [portfolio project]..NashvilleHousing

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant field

select distinct(soldasvacant),COUNT(soldasvacant)
FROM [portfolio project]..NashvilleHousing
group by SoldAsVacant
order by 2


select SoldAsVacant, 
case
when soldasvacant='Y' THEN 'Yes'
when soldasvacant='N' THEN 'No'
ELSE soldasvacant
END
FROM [portfolio project]..NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant= CASE when soldasvacant='Y' THEN 'Yes'
when soldasvacant='N' THEN 'No'
ELSE soldasvacant
END

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY ParcelID,
			 PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 ORDER BY
				UNIQUEID
			 )ROW_NUM

FROM [portfolio project]..NashvilleHousing
-- ORDER BY ParcelID
)
SELECT*
FROM RowNumCTE
where ROW_NUM>1
order by PropertyAddress

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Delete Unused Columnns

SELECT * FROM [portfolio project]..NashvilleHousing 

alter table [portfolio project]..NashvilleHousing 
drop column owneraddress,TaxDistrict,PropertyAddress

alter table [portfolio project]..NashvilleHousing 
drop column saledate


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------