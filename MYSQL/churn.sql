SELECT 
    Contract,
    COUNT(*) AS churned_customers,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS pct_of_total_churned
FROM churn
WHERE Churn = 'Yes'
GROUP BY Contract
ORDER BY churned_customers DESC;

WITH churn_summary AS (
    SELECT 
        Contract,
        tenure,
        MonthlyCharges,
        TotalCharges,
        Churn
    FROM churn
    WHERE Churn = 'Yes'
)
SELECT 
    Contract,
    COUNT(*) AS churned_count,
    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly,
    ROUND(SUM(TotalCharges), 2) AS total_revenue_lost
FROM churn_summary
GROUP BY Contract
ORDER BY total_revenue_lost DESC;

SELECT 
    Contract,
    tenure,
    MonthlyCharges,
    RANK() OVER (PARTITION BY Contract ORDER BY MonthlyCharges DESC) AS charge_rank,
    ROUND(AVG(MonthlyCharges) OVER (PARTITION BY Contract), 2) AS avg_charge_by_contract
FROM churn
WHERE Churn = 'Yes';

SELECT 
    InternetService,
    COUNT(*) AS churned_customers,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM churn WHERE Churn = 'Yes'), 2) AS pct_of_churned,
    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charges
FROM churn
WHERE Churn = 'Yes'
GROUP BY InternetService
ORDER BY churned_customers DESC;

SELECT
    'Total Customers'       AS metric, COUNT(*)                                          AS value FROM churn
UNION ALL
SELECT 'Churned Customers',     COUNT(*)                                                 FROM churn WHERE Churn = 'Yes'
UNION ALL
SELECT 'Churn Rate (%)',        ROUND(SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) FROM churn
UNION ALL
SELECT 'Monthly Revenue Lost',  ROUND(SUM(CASE WHEN Churn='Yes' THEN MonthlyCharges ELSE 0 END),2) FROM churn
UNION ALL
SELECT 'Avg Tenure (Churned)',  ROUND(AVG(CASE WHEN Churn='Yes' THEN tenure END),2)     FROM churn;