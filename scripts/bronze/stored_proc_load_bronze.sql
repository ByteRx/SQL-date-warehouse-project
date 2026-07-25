/*
-----------------------------------------------------------------------------------
Stored Procedure: Load Bronze Layer (Source -> Bronze)
-----------------------------------------------------------------------------------
Script purpose:
      This stored procedure loads data into the 'bronze' schema from external CSV file.
      It performs the following actiona:
      - Truncates the bronze tables before loading data.
      - Uses the 'BULK INSET' commant to load data from csv file to bronze table.

Usage Example:
    EXEC bronze.load_bronze
-----------------------------------------------------------------------------------
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS 
BEGIN
	BEGIN TRY
		PRINT '======================================';
		PRINT 'Loading Bronze Layer';
		PRINT '======================================';

		PRINT '>> Truncating Table: bronze.csv_diabetics_info';
		TRUNCATE TABLE bronze.csv_diabetics_info;

		PRINT '>> Inseting Data Into: bronze.csv_diabetics_info';
		BULK INSERT bronze.csv_diabetics_info
		FROM 'C:\SQL\diabetes+130-us+hospitals+for+years+1999-2008\diabetic_data.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
	END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error message' + ERROR_MESSAGE();
		PRINT 'Error message' + CAST (ERROR_NUMBER() AS NVARCHAR)
		PRINT '=========================================='

	END CATCH
END
