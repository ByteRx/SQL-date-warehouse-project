/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy,
    and standardization across the 'Silver' shcema. It includes checks for:
    - Null or duplicate of primary keys.
    - Unwanted spaces in string fields.
    - Data consistency between fields.
    - Data standardization and consistancy.

Notes:
    - Run these checks after loading Silver layer.
    - Investigate and resolve any discrepancies found during checks.
===============================================================================
*/

-- =====================================================
-- Data Quality Checks - Patients
-- =====================================================

-- Check for NULLs or duplicate primary keys
SELECT
    patient_nbr,
    COUNT(*) AS record_count
FROM silver.patients
GROUP BY patient_nbr
HAVING COUNT(*) > 1
    OR patient_nbr IS NULL;

-- Check distinct values in categorical columns
SELECT DISTINCT race
FROM silver.patients;

SELECT DISTINCT gender
FROM silver.patients;

SELECT DISTINCT age
FROM silver.patients
ORDER BY age;

SELECT DISTINCT weight
FROM silver.patients
ORDER BY weight;

-- Check for unexpected NULL values
SELECT *
FROM silver.patients
WHERE gender IS NULL
   OR age IS NULL;

-- Check row count
SELECT COUNT(*) AS patient_count
FROM silver.patients;

-- =====================================================
-- Data Quality Checks - Admissions
-- =====================================================


--. Check for duplicate encounter IDs
SELECT
    encounter_id,
    COUNT(*) AS duplicate_count
FROM silver.admissions
GROUP BY encounter_id
HAVING COUNT(*) > 1;

--Check for NULL primary keys
SELECT *
FROM silver.admissions
WHERE encounter_id IS NULL;


--Check for NULL patient numbers
SELECT *
FROM silver.admissions
WHERE encounter_id IS NULL;

--Check admission type mapping
SELECT *
FROM silver.admissions
WHERE admission_type_id IS NOT NULL
  AND admission_type IS NULL;

--Check discharge disposition mapping
SELECT *
FROM silver.admissions
WHERE discharge_disposition_id IS NOT NULL
  AND discharge_disposition IS NULL;

--Check admission source mapping
SELECT *
FROM silver.admissions
WHERE admission_source_id IS NOT NULL
  AND admission_source IS NULL;

--Check for distincts
SELECT DISTINCT payer
FROM silver.admissions
ORDER BY payer;

-- =====================================================
-- Data Quality Checks - Diagnoses
-- =====================================================

--Check for duplicate encounter IDs
SELECT
    encounter_id,
    COUNT(*) AS duplicate_count
FROM silver.diagnoses
GROUP BY encounter_id
HAVING COUNT(*) > 1;

--Check for NULL primary keys
SELECT *
FROM silver.diagnoses
WHERE encounter_id IS NULL;

--Check if '?' still exists
SELECT *
FROM silver.diagnoses
WHERE diag_1 = '?'
   OR diag_2 = '?'
   OR diag_3 = '?';

--Check diagnosis count less than 0
SELECT *
FROM silver.diagnoses
WHERE number_diagnoses < 0;

--Check duplicate diagnosis codes within the same encounter
SELECT *
FROM silver.diagnoses
WHERE
    diag_1 = diag_2
 OR diag_1 = diag_3
 OR diag_2 = diag_3;

-- =====================================================
-- Data Quality Checks - Medications
-- =====================================================

--Check for duplicate encounter IDs
SELECT
    encounter_id,
    COUNT(*) AS duplicate_count
FROM silver.medications
GROUP BY encounter_id
HAVING COUNT(*) > 1;

--Check for NULL encounter IDs
SELECT *
FROM silver.medications
WHERE encounter_id IS NULL;


--Check for '?' in all medications
SELECT *
FROM silver.medications
WHERE
       metformin = '?'
    OR repaglinide = '?'
    OR nateglinide = '?'
    OR chlorpropamide = '?'
    OR glimepiride = '?'
    OR acetohexamide = '?'
    OR glipizide = '?'
    OR glyburide = '?'
    OR tolbutamide = '?'
    OR pioglitazone = '?'
    OR rosiglitazone = '?'
    OR acarbose = '?'
    OR miglitol = '?'
    OR troglitazone = '?'
    OR tolazamide = '?'
    OR examide = '?'
    OR citoglipton = '?'
    OR insulin = '?'
    OR glyburide_metformin = '?'
    OR glipizide_metformin = '?'
    OR glimepiride_pioglitazone = '?'
    OR metformin_rosiglitazone = '?'
    OR metformin_pioglitazone = '?';


--Check active_medications range
SELECT *
FROM silver.medications
WHERE active_medications < 0
   OR active_medications > 23;

--Quality check
SELECT *
FROM silver.medications
WHERE diabetesMed = 'No'
AND active_medications > 0;

-- =====================================================
-- Data Quality Checks - Labs
-- =====================================================

--Check for duplicate encounter IDs
SELECT
    encounter_id,
    COUNT(*) AS duplicate_count
FROM silver.labs
GROUP BY encounter_id
HAVING COUNT(*) > 1;

--Check for NULL primary keys
SELECT *
FROM silver.labs
WHERE encounter_id IS NULL;

--Check for invalid glucose values
SELECT DISTINCT max_glu_serum
FROM silver.labs
ORDER BY max_glu_serum;

--Check for invalid A1C values
SELECT DISTINCT A1Cresult
FROM silver.labs
ORDER BY A1Cresult;

--Verify glucose categories
SELECT DISTINCT max_glucose_category
FROM silver.labs
ORDER BY max_glucose_category;


--Verify A1C categories
SELECT DISTINCT a1c_category
FROM silver.labs
ORDER BY a1c_category;

=====================================================
--Data Quality Checks - Utilization 
=====================================================

--Check for duplicate encounter IDs
SELECT
    encounter_id,
    COUNT(*) AS duplicate_count
FROM silver.utilization
GROUP BY encounter_id
HAVING COUNT(*) > 1;


--Check for NULL primary keys
SELECT *
FROM silver.utilization
WHERE encounter_id IS NULL;

--Check for negative values
SELECT *
FROM silver.utilization
WHERE num_procedures < 0
   OR num_medications < 0
   OR number_outpatient < 0
   OR number_emergency < 0
   OR number_inpatient < 0;

--Check for NULL numeric fields
SELECT *
FROM silver.utilization
WHERE num_procedures IS NULL
   OR num_medications IS NULL
   OR number_outpatient IS NULL
   OR number_emergency IS NULL
   OR number_inpatient IS NULL;

--Validate Distincts
SELECT DISTINCT polypharmacy
FROM silver.utilization;

--Verify Polypharmacy Logic
SELECT *
FROM silver.utilization
WHERE  num_medications >= 5
  AND polypharmacy <> 'Yes';

--Verify Emergency History Logic
SELECT *
FROM silver.utilization
WHERE number_emergency > 0
  AND emergency_history <> 'Yes';


=====================================================
--Data Quality Checks - OUTCOMES 
=====================================================

--Check for duplicate primary keys
SELECT
    encounter_id,
    COUNT(*) AS record_count
FROM silver.outcomes
GROUP BY encounter_id
HAVING COUNT(*) > 1;

--Check for NULL primary keys
SELECT *
FROM silver.outcomes
WHERE encounter_id IS NULL;

--Check for NULL values
SELECT *
FROM silver.outcomes
WHERE readmitted IS NULL
   OR readmission_status IS NULL
   OR readmitted_flag IS NULL;

--Check DISTINCT values of readmitted
SELECT DISTINCT readmitted
FROM silver.outcomes;

--Check DISTINCT values of readmitted_flag
SELECT DISTINCT readmitted_flag
FROM silver.outcomes;

--Check consistency between status and flag
SELECT *
FROM silver.outcomes
WHERE
    (readmitted = 'NO'  AND readmitted_flag <> 0)
 OR (readmitted <> 'NO' AND readmitted_flag <> 1);
