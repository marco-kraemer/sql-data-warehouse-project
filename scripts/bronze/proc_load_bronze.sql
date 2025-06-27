/*
===============================================================================
Stored Procedure: bronze.load_bronze
===============================================================================

Purpose:
    This stored procedure performs the full load of the Bronze Layer in the
    Data Warehouse. It truncates and bulk inserts data into all relevant
    staging tables from the CRM and ERP systems.

Functionality:
    - Logs the start and end of each load batch and table load process
    - Uses BULK INSERT to efficiently load data from CSV files
    - Tracks and prints the duration (in seconds) of each table load
    - Includes error handling via TRY...CATCH with detailed messages

Source Paths:
    - CRM Data: \datasets\source_crm\
        - cust_info.csv
        - prd_info.csv
        - sales_details.csv
    - ERP Data: \datasets\source_erp\
        - CUST_AZ12.csv
        - LOC_A101.csv
        - PX_CAT_G1V2.csv

Tables Affected:
    - bronze.crm_cust_info
    - bronze.crm_prd_info
    - bronze.crm_sales_details
    - bronze.erp_cust_az12
    - bronze.erp_loc_a101
    - bronze.erp_px_cat_g1v2

Important:
    This script **truncates** the destination tables before inserting.
    Ensure data integrity and backups before execution.

===============================================================================
*/


CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '======================================';
		PRINT 'Starting Bronze Layer Load';
		PRINT '======================================';

		PRINT '--------------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '--------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;
		PRINT '>> Inserting Data: bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\marco\Projetos\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF (second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '>>------------';

		SET @end_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;
		PRINT '>> Inserting Data: bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\marco\Projetos\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF (second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '>>------------';

		SET @end_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;
		PRINT '>> Inserting Data: bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\marco\Projetos\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF (second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '>>------------';

		PRINT '--------------------------------------';
		PRINT 'Loading ERP Tables';
		PRINT '--------------------------------------';

		SET @end_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;
		PRINT '>> Inserting Data: bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\marco\Projetos\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF (second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '>>------------';

		SET @end_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;
		PRINT '>> Inserting Data: bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\marco\Projetos\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF (second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '>>------------';

		SET @end_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
		PRINT '>> Inserting Data: bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\marco\Projetos\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF (second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '>>------------';

		PRINT '======================================';
		PRINT 'Bronze Layer Load Completed Successfully';
		SET @batch_end_time = GETDATE();
		PRINT '>> Batch Load Duration: ' + CAST(DATEDIFF (second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds'
		PRINT '======================================';
	
	END TRY
	BEGIN CATCH
		PRINT '======================================';
		PRINT 'ERROR during Bronze Layer Load';
		PRINT 'Check the message and line number below:';
		PRINT ERROR_MESSAGE();
		PRINT 'Line: ' + CAST(ERROR_LINE() AS VARCHAR);
		PRINT '======================================';
	END CATCH
END