/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse.
    The Gold layer represents the final dimension and fact tables (star schema)
      
    Each view performs transformations and combines data from the silver layer
    to produce a clean, enriched, and business ready dataset.

  Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/

-- =====================================================
-- Create Dimension: gold.dim_patients
-- =====================================================

CREATE VIEW gold.dim_patients AS
select 
	ROW_NUMBER() OVER (ORDER BY patient_nbr) AS patient_key,
	patient_nbr AS patient_number,
	race,
	gender,
	age,
	weight
from silver.patients
GO

-- =====================================================
-- Create Dimension: gold.dim_payer
-- =====================================================
CREATE OR ALTER VIEW gold.dim_payer AS
SELECT
    ROW_NUMBER() OVER (ORDER BY payer_code) AS payer_key,
    payer_code,
    payer
FROM (SELECT DISTINCT payer_code, payer FROM silver.admissions) t;
GO

-- =====================================================
-- Create Dimension: gold.dim_admission_type
-- =====================================================
CREATE OR ALTER VIEW gold.dim_admission_type AS
SELECT
    ROW_NUMBER() OVER (ORDER BY admission_type_id) AS admission_type_key,
    admission_type_id,
    admission_type
FROM (SELECT DISTINCT admission_type_id, admission_type FROM silver.admissions) t;
GO

-- =====================================================
-- Create Dimension: gold.dim_discharge_disposition
-- =====================================================
CREATE OR ALTER VIEW gold.dim_discharge_disposition AS
SELECT
    ROW_NUMBER() OVER (ORDER BY discharge_disposition_id) AS discharge_disposition_key,
    discharge_disposition_id,
    discharge_disposition
FROM (SELECT DISTINCT discharge_disposition_id, discharge_disposition FROM silver.admissions) t;
GO
-- =====================================================
-- Create Dimension: gold.dim_admission_source
-- =====================================================
CREATE OR ALTER VIEW gold.dim_admission_source AS
SELECT
    ROW_NUMBER() OVER (ORDER BY admission_source_id) AS admission_source_key,
    admission_source_id,
    admission_source
FROM (SELECT DISTINCT admission_source_id, admission_source FROM silver.admissions) t;
GO

-- =====================================================
-- Create Dimension: gold.dim_medical_specialty
-- =====================================================
CREATE OR ALTER VIEW gold.dim_medical_specialty AS
SELECT
    ROW_NUMBER() OVER (ORDER BY medical_specialty) AS medical_specialty_key,
    medical_specialty
FROM (SELECT DISTINCT medical_specialty FROM silver.admissions) t;
GO

-- =====================================================
-- Create Dimension: gold.fact_encounter
-- =====================================================
CREATE OR ALTER VIEW gold.fact_encounters AS
SELECT
    a.encounter_id,
    p.patient_key,
    at_.admission_type_key,
    dd.discharge_disposition_key,
    asrc.admission_source_key,
    pay.payer_key,
    ms.medical_specialty_key,
    dg.diag_1,
    dg.diag_2,
    dg.diag_3,
    a.time_in_hospital_days,
    l.num_lab_procedures,
    l.max_glu_serum,
    l.max_glucose_category,
    l.A1Cresult,
    l.a1c_category,
    u.num_procedures,
    m.active_medications,
    u.num_medications,
    dg.number_diagnoses,
    u.number_outpatient,
    u.number_emergency,
    u.number_inpatient,
    u.polypharmacy,
    u.emergency_history,
    u.frequent_inpatient,
    o.readmitted,
    o.readmission_status,
    o.readmitted_flag
FROM silver.admissions a
LEFT JOIN gold.dim_patients p            ON a.patient_nbr = p.patient_number
LEFT JOIN gold.dim_admission_type at_    ON a.admission_type_id = at_.admission_type_id
LEFT JOIN gold.dim_discharge_disposition dd ON a.discharge_disposition_id = dd.discharge_disposition_id
LEFT JOIN gold.dim_admission_source asrc ON a.admission_source_id = asrc.admission_source_id
LEFT JOIN gold.dim_payer pay             ON ISNULL(a.payer_code,'') = ISNULL(pay.payer_code,'')
LEFT JOIN gold.dim_medical_specialty ms  ON ISNULL(a.medical_specialty,'') = ISNULL(ms.medical_specialty,'')
LEFT JOIN silver.medications m           ON a.encounter_id = m.encounter_id
LEFT JOIN silver.labs l                  ON a.encounter_id = l.encounter_id
LEFT JOIN silver.diagnoses dg            ON a.encounter_id = dg.encounter_id
LEFT JOIN silver.utilization u           ON a.encounter_id = u.encounter_id
LEFT JOIN silver.outcomes o              ON a.encounter_id = o.encounter_id;
GO
