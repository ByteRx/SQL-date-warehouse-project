# Data Catalog for Gold Layer

## Overview
The Gold Layer is the business level data representation of the Diabetes 130-Hospitals dataset, 
structured to support analytical and reporting use cases around patient encounters and readmission. 
It consists of dimension tables describing the who/what/where of each encounter, and a single fact table 
capturing encounter level measures and outcomes.

---

## 1. gold.dim_patients

**Purpose:** Stores patient-level demographic details.

| Column Name | Data Type | Description |
|---|---|---|
| patient_key | INT | Surrogate key uniquely identifying each patient record in the dimension table. |
| patient_nbr | BIGINT | Unique numerical identifier assigned to each patient in the source system. |
| race | VARCHAR(50) | The patient's recorded race/ethnicity (e.g., 'Caucasian', 'AfricanAmerican'). |
| gender | VARCHAR(50) | The gender of the patient (e.g., 'Male', 'Female'). |
| age | VARCHAR(50) | The patient's age, recorded as a 10-year bracket (e.g., '[50-60)'). |
| weight | VARCHAR(50) | The patient's recorded weight bracket, where available. |

---

## 2. gold.dim_admission_type

**Purpose:** Describes the type of hospital admission (e.g., emergency, elective).

| Column Name | Data Type | Description |
|---|---|---|
| admission_type_key | INT | Surrogate key uniquely identifying each admission type record. |
| admission_type_id | INT | Source system numeric code for the admission type. |
| admission_type | VARCHAR(50) | Descriptive label for the admission type (e.g., 'Emergency', 'Elective', 'Urgent'). |

---

## 3. gold.dim_discharge_disposition

**Purpose:** Describes where/how the patient was discharged after the encounter.

| Column Name | Data Type | Description |
|---|---|---|
| discharge_disposition_key | INT | Surrogate key uniquely identifying each discharge disposition record. |
| discharge_disposition_id | INT | Source system numeric code for the discharge disposition. |
| discharge_disposition | VARCHAR(150) | Descriptive label for the discharge outcome (e.g., 'Discharged to home', 'Expired'). |

---

## 4. gold.dim_admission_source

**Purpose:** Describes how/where the patient was admitted from.

| Column Name | Data Type | Description |
|---|---|---|
| admission_source_key | INT | Surrogate key uniquely identifying each admission source record. |
| admission_source_id | INT | Source system numeric code for the admission source. |
| admission_source | VARCHAR(100) | Descriptive label for the admission source (e.g., 'Physician Referral', 'Emergency Room'). |

---

## 5. gold.dim_payer

**Purpose:** Describes the payer/insurer responsible for the encounter.

| Column Name | Data Type | Description |
|---|---|---|
| payer_key | INT | Surrogate key uniquely identifying each payer record. |
| payer_code | VARCHAR(10) | Source system short code for the payer. |
| payer | VARCHAR(100) | Descriptive name of the payer (e.g., 'Medicare', 'Blue Cross'). |

---

## 6. gold.dim_medical_specialty

**Purpose:** Describes the medical specialty of the admitting physician.

| Column Name | Data Type | Description |
|---|---|---|
| medical_specialty_key | INT | Surrogate key uniquely identifying each medical specialty record. |
| medical_specialty | VARCHAR(100) | Descriptive name of the specialty (e.g., 'Cardiology', 'InternalMedicine'). |

---

## 7. gold.fact_encounters

**Purpose:** Stores transactional, encounter-level clinical and outcome data for analytical purposes. Each row represents a single hospital encounter.

| Column Name | Data Type | Description |
|---|---|---|
| encounter_id | BIGINT | Unique identifier for each hospital encounter (source system primary key). |
| patient_key | INT | Surrogate key linking the encounter to the patient dimension table. |
| admission_type_key | INT | Surrogate key linking the encounter to the admission type dimension table. |
| discharge_disposition_key | INT | Surrogate key linking the encounter to the discharge disposition dimension table. |
| admission_source_key | INT | Surrogate key linking the encounter to the admission source dimension table. |
| payer_key | INT | Surrogate key linking the encounter to the payer dimension table. |
| medical_specialty_key | INT | Surrogate key linking the encounter to the medical specialty dimension table. |
| diag_1 | VARCHAR(50) | Primary diagnosis, recorded as a raw ICD9 code. |
| diag_2 | VARCHAR(50) | Secondary diagnosis, recorded as a raw ICD9 code. |
| diag_3 | VARCHAR(50) | Additional diagnosis, recorded as a raw ICD9 code. |
| time_in_hospital_days | INT | Number of days the patient spent in the hospital during the encounter. |
| num_lab_procedures | INT | Number of lab tests performed during the encounter. |
| max_glu_serum | VARCHAR(50) | Result of the glucose serum test, if performed (e.g., 'Norm', '>200', 'None'). |
| max_glucose_category | VARCHAR(50) | Categorized version of the glucose serum result. |
| A1Cresult | VARCHAR(50) | Result of the HbA1c test, if performed (e.g., 'Norm', '>7', 'None'). |
| a1c_category | VARCHAR(50) | Categorized version of the A1C result. |
| num_procedures | INT | Number of procedures (other than lab tests) performed during the encounter. |
| active_medications | INT | Count of diabetes medications actively prescribed during the encounter. |
| num_medications | INT | Total number of distinct medications administered during the encounter. |
| number_diagnoses | INT | Total number of diagnoses entered for the encounter. |
| number_outpatient | INT | Number of outpatient visits by the patient in the year preceding the encounter. |
| number_emergency | INT | Number of emergency visits by the patient in the year preceding the encounter. |
| number_inpatient | INT | Number of inpatient visits by the patient in the year preceding the encounter. |
| polypharmacy | VARCHAR(3) | Flag indicating whether the patient was on multiple medications simultaneously ('Yes'/'No'). |
| emergency_history | VARCHAR(3) | Flag indicating whether the patient had a prior emergency visit history ('Yes'/'No'). |
| frequent_inpatient | VARCHAR(3) | Flag indicating whether the patient had frequent prior inpatient admissions ('Yes'/'No'). |
| readmitted | VARCHAR(50) | Raw readmission outcome as recorded in the source system (e.g., '<30', '>30', 'NO'). |
| readmission_status | VARCHAR(50) | Cleaned/standardized readmission status label. |
| readmitted_flag | INT | Binary flag indicating whether the patient was readmitted (1) or not (0), used for readmission rate calculations. |
