/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy,
    and standardization across the 'Gold' shcema. It includes checks for:
    - Dimention key uniqueness
    - Fact table grain (no duplicate encounter_id rows)
    - Referential integrity between fact and dimension tables (orphaned/missing 
    keys)

Notes:
    - Run these checks after loading Gold layer.
    - Investigate and resolve any discrepancies found during checks.
===============================================================================
*/

-- =============================================================================
-- Dimension key uniqueness
-- =============================================================================
SELECT patient_key, COUNT(*) AS row_count
FROM gold.dim_patients
GROUP BY patient_key
HAVING COUNT(*) > 1;

SELECT admission_type_key, COUNT(*) AS row_count
FROM gold.dim_admission_type
GROUP BY admission_type_key
HAVING COUNT(*) > 1;

SELECT discharge_disposition_key, COUNT(*) AS row_count
FROM gold.dim_discharge_disposition
GROUP BY discharge_disposition_key
HAVING COUNT(*) > 1;

SELECT admission_source_key, COUNT(*) AS row_count
FROM gold.dim_admission_source
GROUP BY admission_source_key
HAVING COUNT(*) > 1;

SELECT payer_key, COUNT(*) AS row_count
FROM gold.dim_payer
GROUP BY payer_key
HAVING COUNT(*) > 1;

SELECT medical_specialty_key, COUNT(*) AS row_count
FROM gold.dim_medical_specialty
GROUP BY medical_specialty_key
HAVING COUNT(*) > 1;


-- =============================================================================
-- Fact table grain
-- =============================================================================
SELECT encounter_id, COUNT(*) AS row_count
FROM gold.fact_encounters
GROUP BY encounter_id
HAVING COUNT(*) > 1;


-- =============================================================================
-- Missing foreign keys
-- =============================================================================
SELECT 'patient_key' AS foreign_key, COUNT(*) AS null_count
FROM gold.fact_encounters
WHERE patient_key IS NULL

UNION ALL

SELECT 'admission_type_key', COUNT(*)
FROM gold.fact_encounters
WHERE admission_type_key IS NULL

UNION ALL

SELECT 'discharge_disposition_key', COUNT(*)
FROM gold.fact_encounters
WHERE discharge_disposition_key IS NULL

UNION ALL

SELECT 'admission_source_key', COUNT(*)
FROM gold.fact_encounters
WHERE admission_source_key IS NULL

UNION ALL

SELECT 'payer_key', COUNT(*)
FROM gold.fact_encounters
WHERE payer_key IS NULL

UNION ALL

SELECT 'medical_specialty_key', COUNT(*)
FROM gold.fact_encounters
WHERE medical_specialty_key IS NULL;
