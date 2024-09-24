# Housing Data - Data-Cleaning with SQL

This project focuses on cleaning and optimizing the "Nashville Housing" dataset using SQL. The goal is to improve data quality by standardizing values, handling missing information, removing duplicates, and preparing the dataset for further analysis.

## Table of Contents
1. [Project Overview](#project-overview)
2. [Skills Used](#skills-used)
3. [Data Source](#data-source)
4. [Data Cleaning Process](#data-cleaning-process)
5. [Key SQL Queries](#key-sql-queries)
6. [Results](#results)
7. [Installation and Setup](#installation-and-setup)
8. [Conclusion](#conclusion)

## Project Overview
The Nashville Housing Data Cleaning project involves improving data quality through several cleaning processes, such as:
- Standardizing date formats.
- Filling missing address values.
- Transforming data into a more consistent format.
- Removing duplicate records and unnecessary columns.
- Optimizing the dataset for analysis.

This project showcases how SQL techniques can be used to enhance dataset accuracy and integrity, making it ready for deeper analysis.

## Skills Used
- **Data Cleaning Techniques**: Standardizing data, handling missing values, removing duplicates.
- **SQL Functions**: Aggregate functions, `CASE` statements, and `JOIN`s.
- **Data Transformation**: Converting data types and reshaping data structures.
- **Optimization**: Preparing the dataset for analysis by eliminating unused columns and records.

## Data Source
The dataset used in this project is the "Nashville Housing" dataset ( Excel worksheet available in repo). It contains property information, sales records, addresses, and dates.

## Data Cleaning Process
1. **Handling Missing Data**:
   - Filled in missing address fields based on available information.
2. **Standardizing Dates**:
   - Converted dates to a consistent format (`YYYY-MM-DD`).
3. **Transforming Values**:
   - Transformed categorical variables and inconsistent values.
4. **Removing Duplicates**:
   - Removed duplicate records to ensure data integrity.
5. **Eliminating Unused Data**:
   - Removed irrelevant or redundant columns to optimize the dataset.

## Key SQL Queries
The following are key SQL queries used for the data cleaning process:

**Standardizing Dates** 
   ```sql
SELECT SaleDate, CONVERT(Date,SaleDate)
FROM   PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing
ADD SaleDate2 Date

UPDATE NashvilleHousing
SET SaleDate2 = CONVERT(Date,SaleDate);
```

**Removing Duplicates**
   ```sql 
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
   ```

## Results
After cleaning, the dataset is now optimized for analysis with:
- All dates in a standard format.
- Missing addresses filled.
- All duplicate entries removed.
- Unused data eliminated, resulting in a more streamlined dataset.

## Installation and Setup
1. Clone the repository:
   ```bash
   git clone https://github.com/daniellekcodes/SQL-Data-Cleaning-HousingData.git
   ```
2. Load the dataset into your SQL environment.
3. Run the SQL scripts provided in the `Nashville Housing Data Cleaning` file to clean the dataset.

## Conclusion
This project demonstrates how effective SQL-based data cleaning processes can enhance the quality of a dataset. By performing transformations, handling missing data, and removing inconsistencies, the dataset is now fully prepared for further analysis and exploration.
