SELECT *
FROM PortfolioProject..NashvilleHousing

-------------------------------------------------------------
--Data Standardization
--Standardizing Date Format by converting dates to a consistent format( YYYY-MM-DD)

SELECT SaleDate, CONVERT(Date,SaleDate)
FROM   PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing
ADD SaleDate2 Date

UPDATE NashvilleHousing
SET SaleDate2 = CONVERT(Date,SaleDate)


-------------------------------------------------------------
--Handling Missing Data
--Filling in missing Property Address Data (there were NULL values in some rows) based on available information

SELECT *
FROM   PortfolioProject..NashvilleHousing
ORDER BY ParcelID

SELECT *
FROM PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL


-------------------------------------------------------------
-- Transforming Data
--Using SUBSTRING to Break Full PropertyAddress into Individual Columns (Address, City)

SELECT PropertyAddress
FROM PortfolioProject..NashvilleHousing

SELECT PropertyAddress,
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS Address 
FROM PortfolioProject..NashvilleHousing

ALTER TABLE PortfolioProject..NashvilleHousing
ADD PropertySplitAddress nvarchar(255)

UPDATE PortfolioProject..NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE PortfolioProject..NashvilleHousing
Add PropertySplitCity nvarchar(255)

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing


-------------------------------------------------------------
--Transforming Data
--Using ParseName to Break Full OwnerAddress into Individual Columns (Address, City, State)

SELECT OwnerAddress
FROM PortfolioProject..NashvilleHousing

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress nvarchar(255)

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleHousing
ADD OwnerSplitCity nvarchar(255)

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)


ALTER TABLE NashvilleHousing
ADD OwnerSplitState nvarchar(255)

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


SELECT *
From PortfolioProject.dbo.NashvilleHousing


-------------------------------------------------------------
-- Value Standardization
-- Changing'Y' and 'N' to 'Yes' and 'No' in the SoldAsVacant Field

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProject..NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
FROM PortfolioProject..NashvilleHousing

UPDATE PortfolioProject..NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
					WHEN SoldAsVacant = 'N' THEN 'No'
					ELSE SoldAsVacant
					END


-------------------------------------------------------------
-- Removing Duplicates
-- Removing the duplicate records to ensure data integrity.

SELECT *
FROM PortfolioProject..NashvilleHousing nh
WHERE UniqueID IN (
    SELECT UniqueID
    FROM (
        SELECT UniqueID, 
               ROW_NUMBER() OVER (PARTITION BY ParcelID, 
                                        PropertySplitAddress, 
                                        SalePrice, 
                                        SaleDate2, 
                                        LegalReference
                                  ORDER BY UniqueID) AS row_num
        FROM PortfolioProject..NashvilleHousing
    ) AS Subquery
    WHERE row_num > 1
)

DELETE nh
FROM PortfolioProject..NashvilleHousing nh
WHERE UniqueID IN (
    SELECT UniqueID
    FROM (
        SELECT UniqueID, 
               ROW_NUMBER() OVER (PARTITION BY ParcelID, 
                                        PropertySplitAddress, 
                                        SalePrice, 
                                        SaleDate2, 
                                        LegalReference
                                  ORDER BY UniqueID) AS row_num
        FROM PortfolioProject..NashvilleHousing
    ) AS Subquery
    WHERE row_num > 1
)



-------------------------------------------------------------
-- Eliminating Unused Data
-- Removing irrelevant or redundant columns to optimize the dataset.

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate



-------------------------------------------------------------

