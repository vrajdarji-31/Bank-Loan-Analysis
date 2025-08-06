CREATE TABLE Bank_Loan_TB (
    id INT PRIMARY KEY,
    address_state VARCHAR(50),
    application_type VARCHAR(50),
    emp_length VARCHAR(50),
    emp_title VARCHAR(100),
    grade VARCHAR(50),
    home_ownership VARCHAR(20),
    issue_date DATE,
    last_credit_pull_date DATE,
    last_payment_date DATE,
    loan_status VARCHAR(50),
    next_payment_date DATE,
    member_id BIGINT,
    purpose VARCHAR(100),
    sub_grade VARCHAR(5),
    term VARCHAR(20),
    verification_status VARCHAR(50),
    annual_income FLOAT,
    dti FLOAT,
    installment FLOAT,
    int_rate FLOAT,
    loan_amount INT,
    total_acc INTEGER,
    total_payment INT
);



SELECT * FROM Bank_Loan_TB;


COPY Bank_Loan_TB(
    id, address_state, application_type, emp_length, emp_title, grade,
    home_ownership, issue_date, last_credit_pull_date, last_payment_date,
    loan_status, next_payment_date, member_id, purpose, sub_grade, term,
    verification_status, annual_income, dti, installment, int_rate,
    loan_amount, total_acc, total_payment
)
FROM 'E:/Data Analyst/Bank_Loan_Analysis/financial_loan.csv'
DELIMITER ','
CSV HEADER;


SELECT COUNT(id) AS Total_No_Application
FROM Bank_Loan_TB;

--MTD Loan Application
SELECT COUNT(id) AS MTD_Total_No_Application
FROM Bank_Loan_TB
WHERE EXTRACT(MONTH FROM issue_date)=12;

--PMTD Loan Application
SELECT COUNT(id) AS MTD_Total_No_Application
FROM Bank_Loan_TB
WHERE EXTRACT(MONTH FROM issue_date)=11;

--Total amount recieved
SELECT SUM(total_payment) AS Total_Amount_Recieved
FROM Bank_Loan_TB
WHERE EXTRACT(MONTH FROM issue_date)=12 AND EXTRACT(YEAR FROM issue_date) = 2021;

--Overall average rate 
SELECT ROUND(AVG(int_rate)::numeric, 4) * 100 AS Avg_Interest_Rate
FROM Bank_Loan_TB;

--Avarage of overall DTI Ratio
SELECT ROUND(AVG(dti)::numeric,4)*100 AS Avg_DTI
FROM Bank_Loan_TB;

--Avarage of MTD for DTI ratio
SELECT ROUND(AVG(dti)::numeric,4)*100 AS MTD_Avg_DTI
FROM Bank_Loan_TB
WHERE EXTRACT(MONTH FROM issue_date) = 12 AND EXTRACT (YEAR FROM issue_date) = 2021;

--Find good loan percentage
SELECT (COUNT(CASE WHEN loan_status='Fully Paid' OR loan_status='Current' THEN id END)*100)/COUNT(id)
AS Good_Loan_Percentage
FROM Bank_Loan_TB;

--Find count of how many good loans are
SELECT COUNT(id) AS Good_Loan_Application
FROM Bank_Loan_TB
WHERE loan_status='Fully Paid' OR loan_status='Current';

--Find the funded amount of good loan
SELECT SUM(loan_amount) AS Good_Loan_funded_amount
FROM Bank_Loan_TB
WHERE loan_status='Fully Paid' OR loan_status='Current';

--Find the total amount recieved from good loans
SELECT SUM(total_payment) AS Good_Loan_recevied_amount
FROM Bank_Loan_TB
WHERE loan_status='Fully Paid' OR loan_status='Current';

--Find the bad loan percentage
SELECT (COUNT(CASE WHEN loan_status='Charged Off' THEN id END)*100)/COUNT(id)
AS Good_Loan_Percentage
FROM Bank_Loan_TB;


--Find count of how many bad loans are
SELECT COUNT(id) AS Bad_Loan_Application
FROM Bank_Loan_TB
WHERE loan_status='Charged Off';


--Find the funded amount of bad loan
SELECT SUM(loan_amount) AS bad_Loan_funded_amount
FROM Bank_Loan_TB
WHERE loan_status='Charged Off';


--Find the total amount recieved from bad loans
SELECT SUM(total_payment) AS Bad_Loan_recevied_amount
FROM Bank_Loan_TB
WHERE loan_status='Charged Off';


--Loan meausers
SELECT 
	loan_status,
	COUNT(id) AS Total_Loan_Applications,
	SUM(total_payment) AS Total_amount_received,
	SUM(loan_amount) AS Total_funded_amount,
	AVG(int_rate*100) AS Intrest_rate,
	AVG(dti*100) AS DTI
FROM Bank_Loan_TB
GROUP BY Loan_Status;

--MTD Loan amounts updates
SELECT 
	Loan_Status,
	SUM(total_payment) AS MTD_Total_Amount_received,
	SUM(loan_amount) AS MTD_Total_amount_funded
FROM Bank_Loan_TB
WHERE EXTRACT(MONTH FROM issue_date) = 12
GROUP BY Loan_Status;

--GET loan data by monthly
SELECT 
    EXTRACT(MONTH FROM issue_date)::INT AS Month_number,
    TO_CHAR(issue_date, 'Month') AS Month_name,
    COUNT(id) AS Total_loan_application,
    SUM(loan_amount) AS Total_funded_amount,
    SUM(total_payment) AS Total_received_amount
FROM Bank_Loan_TB
GROUP BY 
    EXTRACT(MONTH FROM issue_date),
    TO_CHAR(issue_date, 'Month')
ORDER BY 
    EXTRACT(MONTH FROM issue_date);

--loan detail from address coloumn
SELECT 
    address_state,
    COUNT(id) AS Total_loan_application,
    SUM(loan_amount) AS Total_funded_amount,
    SUM(total_payment) AS Total_received_amount
FROM Bank_Loan_TB
GROUP BY address_state
ORDER BY address_state;

--Term Based Detail
SELECT 
    term,
    COUNT(id) AS Total_loan_application,
    SUM(loan_amount) AS Total_funded_amount,
    SUM(total_payment) AS Total_received_amount
FROM Bank_Loan_TB
GROUP BY term
ORDER BY term;

--emp_lentgh based detail
SELECT 
    emp_length,
    COUNT(id) AS Total_loan_application,
    SUM(loan_amount) AS Total_funded_amount,
    SUM(total_payment) AS Total_received_amount
FROM Bank_Loan_TB
GROUP BY emp_length
ORDER BY COUNT(id) DESC;

--to find the detail about purpose of taking loan 
SELECT 
    purpose,
    COUNT(id) AS Total_loan_application,
    SUM(loan_amount) AS Total_funded_amount,
    SUM(total_payment) AS Total_received_amount
FROM Bank_Loan_TB
GROUP BY purpose
ORDER BY COUNT(id) DESC;


--Get details about home ownership
SELECT 
    home_ownership,
    COUNT(id) AS Total_loan_application,
    SUM(loan_amount) AS Total_funded_amount,
    SUM(total_payment) AS Total_received_amount
FROM Bank_Loan_TB
GROUP BY home_ownership
ORDER BY COUNT(id) DESC;
