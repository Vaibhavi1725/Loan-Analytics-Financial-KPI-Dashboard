USE projectdb;

DROP TABLE IF EXISTS finance_1;
DROP TABLE IF EXISTS finance_2;

CREATE TABLE finance_1 (
    id INT PRIMARY KEY,
    member_id INT,
    loan_amnt INT,
    funded_amnt INT,
    funded_amnt_inv DOUBLE,
    term CHAR(30),
    int_rate DOUBLE,
    installment DOUBLE,
    grade VARCHAR(50),
    sub_grade VARCHAR(50),
    emp_title VARCHAR(100),
    emp_length VARCHAR(50),
    home_ownership VARCHAR(50),
    annual_inc INT,
    verification_status VARCHAR(30),
    issue_d CHAR(30),
    loan_status VARCHAR(30),
    pymnt_plan VARCHAR(20),
    descrip VARCHAR(5000),
    purpose VARCHAR(200),
    title VARCHAR(200),
    zip_code VARCHAR(50),
    addr_state VARCHAR(50),
    dti DOUBLE
);

CREATE TABLE finance_2 (
    id INT PRIMARY KEY,
    delinq_2yrs INT,
    earliest_cr_live DATE,
    inq_last_6mths INT,
    mths_since_last_delinq CHAR(30),
    s_since_last_record CHAR(30),
    open_acc INT,
    pub_rec INT,
    revol_bal INT,
    revol_until DOUBLE,
    total_acc INT,
    initial_list_status CHAR(30),
    out_prncp INT,
    out_prncp_inv INT,
    total_pymnt DOUBLE,
    total_pymnt_inv DOUBLE,
    total_rec_prncp DOUBLE,
    total_rec_int DOUBLE,
    total_rec_late_fee INT,
    recoveries DOUBLE,
    collection_recovery_fee DOUBLE,
    last_pymnt_d CHAR(50),
    last_pymnt_amnt DOUBLE,
    next_pymnt_d CHAR(50),
    last_credit_pull_d CHAR(50)
);

LOAD DATA INFILE 'path/to/finance_1.csv'
INTO TABLE finance_1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'path/to/finance_2.csv'
INTO TABLE finance_2
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

UPDATE finance_1
SET issue_d = STR_TO_DATE(issue_d, '%b-%Y');

SELECT YEAR(issue_d) AS issue_year, SUM(loan_amnt) AS total_loan_amount
FROM finance_1
GROUP BY YEAR(issue_d)
ORDER BY issue_year;

SELECT f1.grade, f1.sub_grade, SUM(f2.revol_bal) AS total_revolving_balance
FROM finance_1 f1
JOIN finance_2 f2 ON f1.id = f2.id
GROUP BY f1.grade, f1.sub_grade
ORDER BY f1.grade, f1.sub_grade;

SELECT f1.verification_status, ROUND(SUM(f2.total_pymnt), 2) AS total_payment
FROM finance_1 f1
JOIN finance_2 f2 ON f1.id = f2.id
GROUP BY f1.verification_status;

SELECT f1.addr_state AS state, MONTH(f1.issue_d) AS issue_month, f1.loan_status, COUNT(*) AS loan_count
FROM finance_1 f1
GROUP BY f1.addr_state, MONTH(f1.issue_d), f1.loan_status
ORDER BY state, issue_month;

SELECT f1.home_ownership, COUNT(f2.last_pymnt_d) AS total_payments
FROM finance_1 f1
JOIN finance_2 f2 ON f1.id = f2.id
GROUP BY f1.home_ownership;
