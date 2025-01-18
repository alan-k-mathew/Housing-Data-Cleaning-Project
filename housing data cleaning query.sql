/*

Cleaning Data

*/

Select*
From housing.dbo.NashvilleHousing

 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From housing.dbo.NashvilleHousing
--Where PropertyAddress is null
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From housing.dbo.NashvilleHousing a
JOIN housing.dbo.NashvilleHousing b
	ON a.ParcelID =b.ParcelID
	AND a.UniqueID <> b.UniqueID
Where a.PropertyAddress is null



Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From housing.dbo.NashvilleHousing a
JOIN housing.dbo.NashvilleHousing b
	ON a.ParcelID =b.ParcelID
	AND a.UniqueID <> b.UniqueID
Where a.PropertyAddress is null



--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From housing.dbo.NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as Address
 

From housing.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255)

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))


Select *
From housing.dbo.NashvilleHousing



Select OwnerAddress
From housing.dbo.NashvilleHousing


Select
Parsename(Replace(OwnerAddress,',','.'), 3)
,Parsename(Replace(OwnerAddress,',','.'), 2)
,Parsename(Replace(OwnerAddress,',','.'), 1)
From housing.dbo.NashvilleHousing



ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = Parsename(Replace(OwnerAddress,',','.'), 3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = Parsename(Replace(OwnerAddress,',','.'), 2)


ALTER TABLE NashvilleHousing
Add OwnerySplitState Nvarchar(255)

Update NashvilleHousing
SET OwnerySplitState = Parsename(Replace(OwnerAddress,',','.'), 1)


--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant),  Count(SoldAsVacant)
From housing.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2


SELECT 
    SoldAsVacant,
    CASE 
        WHEN SoldAsVacant = 1 THEN 'YES'
        WHEN SoldAsVacant = 0 THEN 'NO'
        ELSE CAST(SoldAsVacant AS VARCHAR)
    END AS SoldAsVacantDescription
FROM housing.dbo.NashvilleHousing;



ALTER TABLE NashvilleHousing
ALTER COLUMN SoldAsVacant VARCHAR(10);

UPDATE NashvilleHousing
SET SoldAsVacant = CASE 
    WHEN SoldAsVacant = 1 THEN 'YES'
    WHEN SoldAsVacant = 0 THEN 'NO'
    ELSE CAST(SoldAsVacant AS VARCHAR)
END;


-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates


WITH RowNumCTE AS(
Select*,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From housing.dbo.NashvilleHousing
--order by ParcelID
)

Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress
From housing.dbo.NashvilleHousing



---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

Select *
From housing.dbo.NashvilleHousing

ALTER TABLE housing.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE housing.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress
