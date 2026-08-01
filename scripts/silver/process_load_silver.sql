/*
===============================================================================
Stored Procedure : Load Silver Layer 
===============================================================================
Script Purpose:
    This stored procedure performes the ETL process to populate the 'silver'
    schema tables from the 'bronze' schema.
  Actions Perfomed:
    -  Truncating Silver tables.
    -  Inseting tansformed and cleaned data from Bronze to Silver tables.

Usage Example:
    EXEC Silver.load_silver
===============================================================================
*/


CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
    PRINT '======================================'
    PRINT 'Loading Silver Layer'
    PRINT '======================================'
    PRINT '>> Truncating Table: silver.patients';
    TRUNCATE TABLE silver.patients;
    PRINT '>> Inserting Data Into: silver.patients';
    INSERT INTO silver.patients (
        patient_nbr,
        race,
        gender,
        age,
        weight
    )
    SELECT
        patient_nbr,
        race,
        gender,
        age,
        weight
    FROM (
        SELECT
            patient_nbr,

            CASE
                WHEN race = '?' THEN NULL
                ELSE race
            END AS race,

            gender,

            age,

            CASE
                WHEN weight = '?' AND age IN ('[0-10)', '[10-20)') THEN '[25-50)'
                WHEN weight = '?' AND age IN ('[20-30)', '[30-40)') THEN '[50-75)'
                WHEN weight = '?' AND age IN ('[40-50)', '[50-60)', '[60-70)') THEN '[75-100)'
                WHEN weight = '?' THEN '[100-125)'
                ELSE weight
            END AS weight,

            ROW_NUMBER() OVER (
                PARTITION BY patient_nbr
                ORDER BY encounter_id
            ) AS rn

        FROM bronze.csv_diabetics_info

    ) AS t
    WHERE rn = 1;


    PRINT '>> Truncating Table: silver.admissions';
    TRUNCATE TABLE silver.admissions;
    PRINT '>> Inserting Data Into: silver.admissions'
    INSERT INTO silver.admissions (
        encounter_id,
        patient_nbr,

        admission_type_id,
        admission_type,

        discharge_disposition_id,
        discharge_disposition,

        admission_source_id,
        admission_source,

        time_in_hospital_days,

        payer_code,
        payer,

        medical_specialty
    )

    SELECT
        -- Keys
        encounter_id,
        patient_nbr,

        -- Admission
        admission_type_id,

        CASE
            WHEN admission_type_id = 1 THEN 'Emergency'
            WHEN admission_type_id = 2 THEN 'Urgent'
            WHEN admission_type_id = 3 THEN 'Elective'
            WHEN admission_type_id = 4 THEN 'Newborn'
            WHEN admission_type_id = 5 THEN 'Not Available'
            WHEN admission_type_id = 6 THEN 'NULL / Missing'
            WHEN admission_type_id = 7 THEN 'Trauma Center'
            WHEN admission_type_id = 8 THEN 'Not Mapped'
            ELSE NULL
        END AS admission_type,

        discharge_disposition_id,

        CASE
            WHEN discharge_disposition_id = 1  THEN 'Discharged to home'
            WHEN discharge_disposition_id = 2  THEN 'Discharged/transferred to another short-term hospital'
            WHEN discharge_disposition_id = 3  THEN 'Discharged/transferred to skilled nursing facility (SNF)'
            WHEN discharge_disposition_id = 4  THEN 'Discharged/transferred to intermediate care facility (ICF)'
            WHEN discharge_disposition_id = 5  THEN 'Discharged/transferred to another inpatient care institution'
            WHEN discharge_disposition_id = 6  THEN 'Discharged/transferred to home with home health service'
            WHEN discharge_disposition_id = 7  THEN 'Left against medical advice'
            WHEN discharge_disposition_id = 8  THEN 'Discharged/transferred to home under IV provider'
            WHEN discharge_disposition_id = 9  THEN 'Admitted as an inpatient to this hospital'
            WHEN discharge_disposition_id = 10 THEN 'Neonate discharged to another hospital'
            WHEN discharge_disposition_id = 11 THEN 'Expired'
            WHEN discharge_disposition_id = 12 THEN 'Still patient or expected to return for outpatient services'
            WHEN discharge_disposition_id = 13 THEN 'Hospice / home'
            WHEN discharge_disposition_id = 14 THEN 'Hospice / medical facility'
            WHEN discharge_disposition_id = 15 THEN 'Discharged/transferred within institution'
            WHEN discharge_disposition_id = 16 THEN 'Discharged/transferred to outpatient rehabilitation'
            WHEN discharge_disposition_id = 17 THEN 'Discharged/transferred to outpatient rehabilitation (distinct part hospital)'
            WHEN discharge_disposition_id = 18 THEN 'NULL / Missing'
            WHEN discharge_disposition_id = 19 THEN 'Expired at home (Medicare only)'
            WHEN discharge_disposition_id = 20 THEN 'Expired in medical facility (Medicare only)'
            WHEN discharge_disposition_id = 21 THEN 'Expired, place unknown (Medicare only)'
            WHEN discharge_disposition_id = 22 THEN 'Discharged/transferred to another rehabilitation facility'
            WHEN discharge_disposition_id = 23 THEN 'Discharged/transferred to a long-term care hospital'
            WHEN discharge_disposition_id = 24 THEN 'Discharged/transferred to a nursing facility certified under Medicaid'
            WHEN discharge_disposition_id = 25 THEN 'Not Mapped'
            WHEN discharge_disposition_id = 26 THEN 'Unknown / Invalid'
            WHEN discharge_disposition_id = 27 THEN 'Discharged/transferred to a federal health care facility'
            WHEN discharge_disposition_id = 28 THEN 'Discharged/transferred to a Critical Access Hospital (CAH)'
            WHEN discharge_disposition_id = 30 THEN 'Discharged/transferred to another Type of Health Care Institution'
            ELSE NULL
        END AS discharge_disposition,

        admission_source_id,

        CASE
            WHEN admission_source_id = 1  THEN 'Physician Referral'
            WHEN admission_source_id = 2  THEN 'Clinic Referral'
            WHEN admission_source_id = 3  THEN 'HMO Referral'
            WHEN admission_source_id = 4  THEN 'Transfer from a Hospital'
            WHEN admission_source_id = 5  THEN 'Transfer from a Skilled Nursing Facility (SNF)'
            WHEN admission_source_id = 6  THEN 'Transfer from Another Health Care Facility'
            WHEN admission_source_id = 7  THEN 'Emergency Room'
            WHEN admission_source_id = 8  THEN 'Court/Law Enforcement'
            WHEN admission_source_id = 9  THEN 'Not Available'
            WHEN admission_source_id = 10 THEN 'Transfer from Critical Access Hospital'
            WHEN admission_source_id = 11 THEN 'Normal Delivery'
            WHEN admission_source_id = 12 THEN 'Premature Delivery'
            WHEN admission_source_id = 13 THEN 'Sick Baby'
            WHEN admission_source_id = 14 THEN 'Extramural Birth'
            WHEN admission_source_id = 15 THEN 'Not Available'
            WHEN admission_source_id = 17 THEN 'NULL / Missing'
            WHEN admission_source_id = 18 THEN 'Transfer From Another Home Health Agency'
            WHEN admission_source_id = 19 THEN 'Readmission to Same Home Health Agency'
            WHEN admission_source_id = 20 THEN 'Not Mapped'
            WHEN admission_source_id = 21 THEN 'Unknown / Invalid'
            WHEN admission_source_id = 22 THEN 'Transfer from Another Rehabilitation Facility'
            WHEN admission_source_id = 23 THEN 'Born Inside This Hospital'
            WHEN admission_source_id = 24 THEN 'Born Outside This Hospital'
            WHEN admission_source_id = 25 THEN 'Transfer from Ambulatory Surgery Center'
            WHEN admission_source_id = 26 THEN 'Transfer from Hospice'
            ELSE NULL
        END AS admission_source,

        time_in_hospital AS time_in_hospital_days,

        -- Insurance
        payer_code,

        CASE
            WHEN payer_code = 'BC' THEN 'Blue Cross'
            WHEN payer_code = 'CH' THEN 'Champus / CHAMPVA (Military Health Insurance)'
            WHEN payer_code = 'CM' THEN 'Commercial Insurance'
            WHEN payer_code = 'CP' THEN 'Commercial Plan'
            WHEN payer_code = 'DM' THEN 'Medicaid'
            WHEN payer_code = 'FR' THEN 'Federal Program'
            WHEN payer_code = 'HM' THEN 'Health Maintenance Organization (HMO)'
            WHEN payer_code = 'MC' THEN 'Medicare'
            WHEN payer_code = 'MD' THEN 'Medicaid'
            WHEN payer_code = 'MP' THEN 'Medicare Primary'
            WHEN payer_code = 'OG' THEN 'Other Government'
            WHEN payer_code = 'OT' THEN 'Other'
            WHEN payer_code = 'PO' THEN 'Private Organization / Private Insurance'
            WHEN payer_code = 'SI' THEN 'Self-Insured / Self-Pay Insurance'
            WHEN payer_code = 'SP' THEN 'Self-Pay'
            WHEN payer_code = 'UN' THEN 'Unknown'
            WHEN payer_code = 'WC' THEN 'Workers'' Compensation'
            WHEN payer_code = '?'  THEN NULL
            ELSE NULL
        END AS payer,

        -- Clinical
    
        CASE TRIM(medical_specialty)
            WHEN '?' THEN NULL
            ELSE medical_specialty
        END AS medical_specialty

    FROM bronze.csv_diabetics_info;


    PRINT '>> Truncating Table: silver.diagnoses';
    TRUNCATE TABLE silver.diagnoses;
    PRINT '>> Inserting Data Into: silver.diagnoses'
    INSERT INTO silver.diagnoses(
        encounter_id,
        diag_1,
        diag_2,
        diag_3,
        number_diagnoses
    )

    SELECT
        encounter_id,
        CASE
        WHEN TRIM(diag_1) = '?' THEN NULL
        ELSE TRIM(diag_1)
    END AS diag_1,
        CASE
        WHEN TRIM(diag_2) = '?' THEN NULL
        ELSE TRIM(diag_2)
    END AS diag_2,
        CASE
        WHEN TRIM(diag_3) = '?' THEN NULL
        ELSE TRIM(diag_3)
    END AS diag_3,
        number_diagnoses AS total_diagnoses
    FROM bronze.csv_diabetics_info;


    PRINT '>> Truncating Table: silver.medications';
    TRUNCATE TABLE silver.medications;
    PRINT '>> Inserting Data Into: silver.medications'

    INSERT INTO silver.medications (
        encounter_id,
        metformin,
        repaglinide,
        nateglinide,
        chlorpropamide,
        glimepiride,
        acetohexamide,
        glipizide,
        glyburide,
        tolbutamide,
        pioglitazone,
        rosiglitazone,
        acarbose,
        miglitol,
        troglitazone,
        tolazamide,
        examide,
        citoglipton,
        insulin,
        glyburide_metformin,
        glipizide_metformin,
        glimepiride_pioglitazone,
        metformin_rosiglitazone,
        metformin_pioglitazone,
        change,
        diabetesMed,
         active_medications
    )

    SELECT
        encounter_id,
        metformin,
        repaglinide,
        nateglinide,
        chlorpropamide,
        glimepiride,
        acetohexamide,
        glipizide,
        glyburide,
        tolbutamide,
        pioglitazone,
        rosiglitazone,
        acarbose,
        miglitol,
        troglitazone,
        tolazamide,
        examide,
        citoglipton,
        insulin,
        glyburide_metformin,
        glipizide_metformin,
        glimepiride_pioglitazone,
        metformin_rosiglitazone,
        metformin_pioglitazone,
        change AS medication_change,
        diabetesMed AS diabete_medication,
        (
        CASE WHEN metformin <> 'No' THEN 1 ELSE 0 END +
        CASE WHEN repaglinide <> 'No' THEN 1 ELSE 0 END +
        CASE WHEN nateglinide <> 'No' THEN 1 ELSE 0 END +
        CASE WHEN chlorpropamide <> 'No' THEN 1 ELSE 0 END +
        CASE WHEN glimepiride <> 'No' THEN 1 ELSE 0 END +
        CASE WHEN acetohexamide <> 'No' THEN 1 ELSE 0 END +
        CASE WHEN glipizide <> 'No' THEN 1 ELSE 0 END +
        CASE WHEN glyburide <> 'No' THEN 1 ELSE 0 END +
        CASE WHEN tolbutamide <> 'No' THEN 1 ELSE 0 END +
        CASE WHEN pioglitazone <> 'No' THEN 1 ELSE 0 END +
        CASE WHEN rosiglitazone <> 'No' THEN 1 ELSE 0 END +
        CASE WHEN acarbose <> 'No' THEN 1 ELSE 0 END +
        CASE WHEN miglitol <> 'No' THEN 1 ELSE 0 END +
        CASE WHEN troglitazone <> 'No' THEN 1 ELSE 0 END +
        CASE WHEN tolazamide <> 'No' THEN 1 ELSE 0 END +
        CASE WHEN examide <> 'No' THEN 1 ELSE 0 END +
        CASE WHEN citoglipton <> 'No' THEN 1 ELSE 0 END +
        CASE WHEN insulin <> 'No' THEN 1 ELSE 0 END +
        CASE WHEN glyburide_metformin <> 'No' THEN 1 ELSE 0 END +
        CASE WHEN glipizide_metformin <> 'No' THEN 1 ELSE 0 END +
        CASE WHEN glimepiride_pioglitazone <> 'No' THEN 1 ELSE 0 END +
        CASE WHEN metformin_rosiglitazone <> 'No' THEN 1 ELSE 0 END +
        CASE WHEN metformin_pioglitazone <> 'No' THEN 1 ELSE 0 END
    ) AS active_medications
    FROM bronze.csv_diabetics_info;


    PRINT '>> Truncating Table: silver.labs';
    TRUNCATE TABLE silver.labs;
    PRINT '>> Inserting Data Into: silver.labs'
    INSERT INTO silver.labs(
        encounter_id,
        num_lab_procedures,
        max_glu_serum,
        max_glucose_category,
        A1Cresult,
        a1c_category
    )
    SELECT
        encounter_id,
        num_lab_procedures,
        max_glu_serum,
        CASE
        WHEN max_glu_serum = 'None' THEN 'Not Measured'
        WHEN max_glu_serum = 'Norm' THEN 'Normal'
        WHEN max_glu_serum = '>200' THEN 'High (>200 mg/dL)'
        WHEN max_glu_serum = '>300' THEN 'Very High (>300 mg/dL)'
        ELSE NULL
    END AS max_glucose_category,
        A1Cresult AS A1C_result,
        CASE
        WHEN A1Cresult = 'None' THEN 'Not Measured'
        WHEN A1Cresult = 'Norm' THEN 'Normal'
        WHEN A1Cresult = '>7' THEN 'Above 7%'
        WHEN A1Cresult = '>8' THEN 'Above 8%'
        ELSE NULL
    END AS a1c_category
    FROM bronze.csv_diabetics_info;


    PRINT '>> Truncating Table: silver.utilization';
    TRUNCATE TABLE silver.utilization;
    PRINT '>> Inserting Data Into: silver.utilization'
    INSERT INTO silver.utilization (
        encounter_id,
        num_procedures,
        num_medications,
        polypharmacy,
        number_outpatient,
        number_emergency,
        emergency_history,
        number_inpatient,
        frequent_inpatient
    )

    SELECT
        encounter_id,
        num_procedures AS total_procedures,
        num_medications AS total_medications,
        CASE
        WHEN num_medications >= 5 THEN 'Yes'
        ELSE 'No'
    END AS polypharmacy,
        number_outpatient AS outpatient_visits,
        number_emergency AS emergency_visits,
        CASE
        WHEN number_emergency > 0
            THEN 'Yes'
        ELSE 'No'
    END AS emergency_history,
        number_inpatient AS inpatient_visits,
        CASE
        WHEN number_inpatient >= 2
            THEN 'Yes'
        ELSE 'No'
    END AS frequent_inpatient
    FROM bronze.csv_diabetics_info;


    PRINT '>> Truncating Table: silver.outcomes';
    TRUNCATE TABLE silver.outcomes;
    PRINT '>> Inserting Data Into: silver.outcomes'
    INSERT INTO silver.outcomes (
        encounter_id,
        readmitted,
        readmission_status,
        readmitted_flag
    )

    SELECT
        encounter_id,
        readmitted,

        CASE
            WHEN readmitted = 'NO'  THEN 'Not Readmitted'
            WHEN readmitted = '<30' THEN 'Readmitted Within 30 Days'
            WHEN readmitted = '>30' THEN 'Readmitted After 30 Days'
            ELSE NULL
        END AS readmission_status,

        CASE
            WHEN readmitted = 'NO' THEN 0
            ELSE 1
        END AS readmitted_flag

    FROM bronze.csv_diabetics_info;
END


