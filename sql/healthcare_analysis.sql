-- Healthcare Analytics - SQL Analysis

-- This file contains SQL queries used to analyse the cleaned healthcare dataset.

-- Initial Data Check
SELECT *
FROM healthcare
LIMIT 10;

-- Question 1: Which medical conditions are the most common?

SELECT
    "Medical Condition",
    COUNT(*) AS patient_count
FROM healthcare
GROUP BY "Medical Condition"
ORDER BY patient_count DESC;

-- Finding:
-- Medical conditions are relatively evenly distributed across the dataset.
-- Arthritis is the most common condition with 9,218 records, followed closely by Diabetes with 9,216 records.
-- Asthma is the least common with 9,095 records.


-- Question 2: What is the distribution of patients by admission type?

SELECT
    "Admission Type",
    COUNT(*) AS patient_count
FROM healthcare
GROUP BY "Admission Type"
ORDER BY patient_count DESC;

-- Finding:
-- Admission types are relatively evenly distributed.
-- Elective admissions are the most common with 18,473 records, followed by Urgent with 18,391 and Emergency with 18,102.


-- Question 3: What is the average length of stay for each admission type?

SELECT
    "Admission Type",
    ROUND(AVG("Length of Stay"), 2) AS avg_length_of_stay
FROM healthcare
GROUP BY "Admission Type"
ORDER BY avg_length_of_stay DESC;

-- Finding:
-- Average length of stay is very similar across all admission types.
-- Emergency admissions have the highest average stay at 15.58 days, followed by Elective at 15.51 days and Urgent at 15.40 days.
-- The small difference suggests that admission type is not associated with substantial differences in length of stay within this dataset.


-- Question 4: Which medical conditions have the highest average billing amount?

SELECT
    "Medical Condition",
    ROUND(AVG("Billing Amount"), 2) AS avg_billing_amount
FROM healthcare
GROUP BY "Medical Condition"
ORDER BY avg_billing_amount DESC;

-- Finding:
-- Obesity has the highest average billing amount at $25,859.22,
-- followed by Diabetes at $25,714.33.
-- Cancer has the lowest average billing amount at $25,205.92.
-- However, the differences between medical conditions are relatively small,
-- suggesting that average billing is fairly consistent across conditions.


-- Question 5: Which insurance providers have the highest average billing amount?

SELECT
    "Insurance Provider",
    ROUND(AVG("Billing Amount"), 2) AS avg_billing_amount
FROM healthcare
GROUP BY "Insurance Provider"
ORDER BY avg_billing_amount DESC;

-- Finding:
-- Medicare has the highest average billing amount at $25,678.09, while UnitedHealthcare has the lowest at $25,458.89.
-- However, the difference between the highest and lowest averages is small, indicating that average billing is relatively consistent across insurance providers.


-- Question 6: How are patients distributed across different age groups?

SELECT
    CASE
        WHEN Age < 18 THEN 'Under 18'
        WHEN Age BETWEEN 18 AND 35 THEN '18-35'
        WHEN Age BETWEEN 36 AND 50 THEN '36-50'
        WHEN Age BETWEEN 51 AND 65 THEN '51-65'
        ELSE '66+'
    END AS age_group,
    COUNT(*) AS patient_count
FROM healthcare
GROUP BY age_group
ORDER BY patient_count DESC;

-- Finding:
-- The 66+ age group contains the highest number of patient records with 16,096, followed by the 18-35 age group with 14,289 records.
-- The 51-65 and 36-50 groups contain 12,298 and 12,167 records respectively.
-- Patients under 18 represent a very small portion of the dataset, with only 116 records.


-- Question 7: Which medical conditions have an average billing amount above $25,500?

SELECT
    "Medical Condition",
    ROUND(AVG("Billing Amount"), 2) AS avg_billing_amount
FROM healthcare
GROUP BY "Medical Condition"
HAVING AVG("Billing Amount") > 25500
ORDER BY avg_billing_amount DESC;

-- Finding:
-- Five medical conditions have an average billing amount above $25,500.
-- Obesity has the highest average billing at $25,859.22, followed by Diabetes and Asthma.
-- Cancer does not meet the $25,500 threshold and is therefore excluded.


-- Question 8: Which admission types have above-average billing compared with the overall average?

WITH overall_average AS (
    SELECT AVG("Billing Amount") AS overall_avg_billing
    FROM healthcare)

SELECT
    h."Admission Type",
    ROUND(AVG(h."Billing Amount"), 2) AS avg_billing_amount,
    ROUND(o.overall_avg_billing, 2) AS overall_avg_billing
FROM healthcare h
CROSS JOIN overall_average o
GROUP BY h."Admission Type"
HAVING AVG(h."Billing Amount") > o.overall_avg_billing
ORDER BY avg_billing_amount DESC;

-- Finding:
-- Elective admissions have an average billing amount of $25,663.34,
-- which is slightly above the overall average billing amount of $25,594.63.
-- Urgent and Emergency admissions do not exceed the overall average.


-- Question 9: How do medical conditions rank by average billing amount?

SELECT
    "Medical Condition",
    ROUND(AVG("Billing Amount"), 2) AS avg_billing_amount,
    RANK() OVER (
        ORDER BY AVG("Billing Amount") DESC) AS billing_rank
FROM healthcare
GROUP BY "Medical Condition"
ORDER BY billing_rank;

-- Finding:
-- Obesity ranks first for average billing amount at $25,859.22, followed by Diabetes and Asthma.
-- Cancer ranks last with the lowest average billing amount at $25,205.92.
-- The ranking confirms that billing differences across conditions are present, but the overall spread remains relatively small.


-- Question 10: How did patient admissions vary by month over time?

SELECT
    "Admission Year-Month",
    COUNT(*) AS admission_count
FROM healthcare
GROUP BY "Admission Year-Month"
ORDER BY "Admission Year-Month";

-- Finding:
-- Monthly patient admissions remain relatively stable throughout the dataset,
-- generally ranging between approximately 850 and 1,000 admissions per month.
-- There is no clear sustained upward or downward trend across the complete years.
-- The lower counts in May 2019 and May 2024 should be interpreted carefully because these are partial months in the dataset.