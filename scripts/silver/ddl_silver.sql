/*
===============================================================================
DDL Script: Create Silver Tables
===============================================================================
Script Purpose:
    This script transforms the Bronze layer by splitting the raw diabetes
    dataset into normalized Silver tables:
        - Patients
        - Admissions
        - Diagnoses
        - Medications
        - Labs
        - Utilization
        - Outcomes

Source:
    bronze.csv_diabetics_info

Notes:
    - Existing Silver tables are dropped and recreated.
    - Creates tables in 'silver' schema
===============================================================================
*/

USE DataWarehouse;
GO

-- =====================================================
-- Patients
-- =====================================================
DROP TABLE IF EXISTS silver.patients;
GO

CREATE TABLE silver.patients (
    patient_nbr BIGINT PRIMARY KEY,
    race VARCHAR(50),
    gender VARCHAR(50),
    age VARCHAR(50),
    weight VARCHAR(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO


-- =====================================================
-- Admissions
-- =====================================================
DROP TABLE IF EXISTS silver.admissions;
GO

CREATE TABLE silver.admissions (
    encounter_id BIGINT PRIMARY KEY,
    patient_nbr BIGINT,

    admission_type_id INT,
    admission_type VARCHAR(50),

    discharge_disposition_id INT,
    discharge_disposition VARCHAR(150),

    admission_source_id INT,
    admission_source VARCHAR(100),

    time_in_hospital_days INT,

    payer_code VARCHAR(10),
    payer VARCHAR(100),

    medical_specialty VARCHAR(100),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO


-- =====================================================
-- Diagnoses
-- =====================================================
DROP TABLE IF EXISTS silver.diagnoses;
GO

CREATE TABLE silver.diagnoses (
    encounter_id BIGINT PRIMARY KEY,
    diag_1 VARCHAR(50),
    diag_2 VARCHAR(50),
    diag_3 VARCHAR(50),
    number_diagnoses INT,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO


-- =====================================================
-- Medications
-- =====================================================
DROP TABLE IF EXISTS silver.medications;
GO

CREATE TABLE silver.medications (
    encounter_id BIGINT PRIMARY KEY,
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
    active_medications INT,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO


-- =====================================================
-- Labs
-- =====================================================
DROP TABLE IF EXISTS silver.labs;
GO

CREATE TABLE silver.labs (
    encounter_id BIGINT PRIMARY KEY,
    num_lab_procedures INT,
    max_glu_serum VARCHAR(50),
    max_glucose_category VARCHAR(50),
    A1Cresult VARCHAR(50),
    a1c_category VARCHAR(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

-- =====================================================
-- Utilization
-- =====================================================
DROP TABLE IF EXISTS silver.utilization;
GO

CREATE TABLE silver.utilization (
    encounter_id BIGINT PRIMARY KEY,
    num_procedures INT,
    num_medications INT,
    polypharmacy VARCHAR(3),
    number_outpatient INT,
    number_emergency INT,
    emergency_history VARCHAR(3),
    number_inpatient INT,
    frequent_inpatient VARCHAR(3),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

-- =====================================================
-- Outcomes
-- =====================================================
DROP TABLE IF EXISTS silver.outcomes;
GO

CREATE TABLE silver.outcomes (
    encounter_id BIGINT PRIMARY KEY,
    readmitted VARCHAR(50),
    readmission_status VARCHAR(50),
    readmitted_flag INT,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO



