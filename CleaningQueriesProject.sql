-- CLEANING DATA IN MySQL QUERIES

SELECT *
FROM nashville_housing.nashville_housing_data;



-- Standardize date format

ALTER TABLE nashville_housing.nashville_housing_data
ADD SaleDateConverted Date; -- Created a new date column in to store Sale Dates in "YYYY-MM-DD" format 

UPDATE nashville_housing.nashville_housing_data
SET SaleDateConverted = DATE_FORMAT(STR_TO_DATE(SaleDate, '%d-%b-%y'), '%Y-%m-%d'); -- Changed data type to date with proper format




-- Populate Property Address data

SELECT *
FROM nashville_housing.nashville_housing_data 
-- WHERE PropertyAddress = ''
ORDER BY ParcelID;

UPDATE nashville_housing.nashville_housing_data
SET PropertyAddress = NULLIF(PropertyAddress, ''); -- Updated PropertyAddress column to recognize '' (blanks) as NULLs


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, IFNULL(a.PropertyAddress, b.PropertyAddress)
FROM nashville_housing.nashville_housing_data a
JOIN nashville_housing.nashville_housing_data b
	ON a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL OR '';
-- IFNULL(a.PropertyAddress, b.PropertyAddress)

UPDATE nashville_housing.nashville_housing_data a 
JOIN nashville_housing.nashville_housing_data b 
	ON a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID
SET a.PropertyAddress = IFNULL(a.PropertyAddress, b.PropertyAddress)
WHERE a.PropertyAddress IS NULL;

-- FROM nashville_housing.nashville_housing_data a
-- JOIN nashville_housing.nashville_housing_data b
	-- ON a.ParcelID = b.ParcelID
   -- AND a.UniqueID <> b.UniqueID
-- WHERE a.PropertyAddress IS NULL; 





-- Breaking out Address into individual columns (Address, City, State)

SELECT PropertyAddress
FROM nashville_housing.nashville_housing_data;

SELECT
	SUBSTRING(PropertyAddress, 1, LOCATE(',', PropertyAddress) -1) AS Address,
    SUBSTRING(PropertyAddress, LOCATE(',', PropertyAddress) +1, LENGTH(PropertyAddress)) AS City,
    SUBSTRING_INDEX(OwnerAddress, ',', -1) AS State
FROM nashville_housing.nashville_housing_data; -- Split PropertyAddress and OwnerAddress columns to create address, city, and state columns. 


ALTER TABLE nashville_housing.nashville_housing_data
ADD PropertySplitAddress varchar(225); 

UPDATE nashville_housing.nashville_housing_data
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, LOCATE(',', PropertyAddress) -1); -- Added new address column and added data to table. 

ALTER TABLE nashville_housing.nashville_housing_data
ADD PropertySplitCity varchar(225);

UPDATE nashville_housing.nashville_housing_data
SET PropertySplitCity = SUBSTRING(PropertyAddress, LOCATE(',', PropertyAddress) +1, LENGTH(PropertyAddress)); -- Added new city column and added data to table. 

ALTER TABLE nashville_housing.nashville_housing_data
ADD PropertySplitState varchar(225);

UPDATE nashville_housing.nashville_housing_data
SET PropertySplitState = SUBSTRING_INDEX(OwnerAddress, ',', -1); -- Added new state column and added data to table. 




-- Change Y and N in "Sold as Vacant" field

SELECT DISTINCT SoldAsVacant, COUNT(SoldAsVacant) -- Counting each distinct value in SoldAsVacant column
FROM nashville_housing.nashville_housing_data
GROUP BY SoldAsVacant
ORDER BY 2;

SELECT SoldAsVacant,
	CASE 
		WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
        ELSE SoldAsVacant
        END 
FROM nashville_housing.nashville_housing_data;

UPDATE nashville_housing.nashville_housing_data
SET SoldAsVacant = 
	CASE 
		WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
        ELSE SoldAsVacant
        END; 




-- Finding duplicates

WITH RowNumCTE AS (
SELECT 
	*,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				PropertyAddress,
                SalePrice,
                SaleDate, 
                LegalReference
                ORDER BY 
					UniqueID
                    ) row_num
FROM nashville_housing.nashville_housing_data
ORDER BY ParcelID
)
SELECT * 
FROM RowNumCTE
WHERE row_num > 1;
-- ORDER BY PropertyAddress
 



-- Delete unused columns

ALTER TABLE nashville_housing.nashville_housing_data
DROP COLUMN OwnerAddress,
DROP COLUMN PropertyAddress,
DROP COLUMN SaleDate;

ALTER TABLE nashville_housing.nashville_housing_data
DROP COLUMN TaxDistrict;
