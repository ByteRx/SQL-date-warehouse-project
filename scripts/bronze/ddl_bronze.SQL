/*
----------------------------------------------------------------------------------
DDL Script: Create bronze table
----------------------------------------------------------------------------------
Script Purpose:
    This script creates table in the 'bronze' schema, dropping existing tables
    if they already exist.
  Run this script to re-define the DDL structure of 'bronze' table
---------------------------------------------------------------------------------
*/

IF OBJECT_ID ('bronze.csv_diabetics_info', 'U') IS NOT NULL
    DROP TABLE bronze.csv_diabetics_info;
GO

CREATE TABLE bronze.csv_diabetics_info (
    encounter_id BIGINT,
    patient_nbr BIGINT,
    race VARCHAR(50),
    gender VARCHAR(50),
    age VARCHAR(50),
    weight VARCHAR(50),
    admission_type_id INT,
    discharge_disposition_id INT,
    admission_source_id INT,
    time_in_hospital INT,
    payer_code VARCHAR(50),
    medical_specialty VARCHAR(100),
    num_lab_procedures INT,
    num_procedures INT,
    num_medications INT,
    number_outpatient INT,
    number_emergency INT,
    number_inpatient INT,
    diag_1 VARCHAR(50),
    diag_2 VARCHAR(50),
    diag_3 VARCHAR(50),
    number_diagnoses INT,
    max_glu_serum VARCHAR(50),
    A1Cresult VARCHAR(50),
    metformin VARCHAR(50),
    repaglinide VARCHAR(50),
    nateglinide VARCHAR(50),
    chlorpropamide VARCHAR(50),
    glimepiride VARCHAR(50),
    acetohexamide VARCHAR(50),
    glipizide VARCHAR(50),
    glyburide VARCHAR(50),
    tolbutamide VARCHAR(50),
    pioglitazone VARCHAR(50),
    rosiglitazone VARCHAR(50),
    acarbose VARCHAR(50),
    miglitol VARCHAR(50),
    troglitazone VARCHAR(50),
    tolazamide VARCHAR(50),
    examide VARCHAR(50),
    citoglipton VARCHAR(50),
    insulin VARCHAR(50),
    glyburide_metformin VARCHAR(50),
    glipizide_metformin VARCHAR(50),
    glimepiride_pioglitazone VARCHAR(50),
    metformin_rosiglitazone VARCHAR(50),
    metformin_pioglitazone VARCHAR(50),
    change VARCHAR(50),
    diabetesMed VARCHAR(50),
    readmitted VARCHAR(50)
);
GO
