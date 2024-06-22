/*

Cleaning Data in SQL Queries by Edward Miro

*/

-- Select all records from the NashvilleHousing table
SELECT *
FROM PortfolioProject..NashvilleHousing;
---------------------------------------------------------------------------------------
-- Standardize Date Format

-- Select the converted SaleDate and the original SaleDate for verification
SELECT SaleDateConverted, CONVERT(date, SaleDate)
FROM PortfolioProject..NashvilleHousing;

-- Update the SaleDate column to the standardized date format
UPDATE NashvilleHousing
SET SaleDate = CONVERT(date, SaleDate);

-- Add a new column SaleDateConverted to the NashvilleHousing table
ALTER TABLE NashvilleHousing
ADD SaleDateConverted DATE;

-- Update the SaleDateConverted column with the standardized SaleDate values
UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(date, SaleDate);

------------------------------------------------------------------------------------

-- Populate Property Address data

-- Select all records from the NashvilleHousing table, ordered by ParcelID
SELECT *
FROM PortfolioProject..NashvilleHousing
ORDER BY ParcelID;

-- Select records with non-null PropertyAddress and their corresponding ParcelID
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
    ON a.ParcelID = b.ParcelID
    AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress IS NOT NULL;

-- Update PropertyAddress column with non-null values from related records
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
    ON a.ParcelID = b.ParcelID
    AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress IS NULL;

---------------------------------------------------------------------------------------
-- Breaking out Address into Individual Columns (Address, City, State)

-- Select the PropertyAddress column from the NashvilleHousing table
SELECT PropertyAddress
FROM PortfolioProject..NashvilleHousing;

-- Select the split Address parts from the PropertyAddress column
SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) AS CityState
FROM PortfolioProject..NashvilleHousing;

-- Add a new column PropertySplitAddress to the NashvilleHousing table
ALTER TABLE NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255);

-- Update PropertySplitAddress column with the split Address part
UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1);

-- Add a new column PropertySplitCity to the NashvilleHousing table
ALTER TABLE NashvilleHousing
ADD PropertySplitCity NVARCHAR(255);

-- Update PropertySplitCity column with the split City part
UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress));

-- Select the OwnerAddress column from the NashvilleHousing table
SELECT OwnerAddress
FROM PortfolioProject..NashvilleHousing;

-- Select the split Address parts from the OwnerAddress column
SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3) AS OwnerAddress,
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2) AS OwnerCity,
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1) AS OwnerState
FROM NashvilleHousing;

-- Add a new column OwnerSplitAddress to the NashvilleHousing table
ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(255);

-- Update OwnerSplitAddress column with the split Address part
UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3);

-- Add a new column OwnerSplitCity to the NashvilleHousing table
ALTER TABLE NashvilleHousing
ADD OwnerSplitCity NVARCHAR(255);

-- Update OwnerSplitCity column with the split City part
UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2);

-- Add a new column OwnerSplitState to the NashvilleHousing table
ALTER TABLE NashvilleHousing
ADD OwnerSplitState NVARCHAR(255);

-- Update OwnerSplitState column with the split State part
UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1);

-- Select all records from the NashvilleHousing table
SELECT *
FROM PortfolioProject..NashvilleHousing;

-------------------------------------------------------------------------------------
-- Change Y and N to Yes and No in "Sold as Vacant" field

-- Select distinct values of SoldAsVacant and their count, grouped by SoldAsVacant
SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProject..NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2;

-- Select SoldAsVacant column and convert 'Y' to 'Yes' and 'N' to 'No'
SELECT SoldAsVacant,
CASE 
    WHEN SoldAsVacant = 'Y' THEN 'Yes'
    WHEN SoldAsVacant = 'N' THEN 'No'
    ELSE SoldAsVacant
END
FROM PortfolioProject..NashvilleHousing;

-- Update SoldAsVacant column to convert 'Y' to 'Yes' and 'N' to 'No'
UPDATE NashvilleHousing
SET SoldAsVacant = CASE 
    WHEN SoldAsVacant = 'Y' THEN 'Yes'
    WHEN SoldAsVacant = 'N' THEN 'No'
    ELSE SoldAsVacant
END;

--------------------------------------------------------------------------------
