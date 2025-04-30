
use BankingSystem

-- ==============================
-- 1. Departments 
-- ==============================
CREATE TABLE Departments (
    Department_ID INT PRIMARY KEY IDENTITY(1,1),
    Department_Name NVARCHAR(100) NOT NULL
);

-- ==============================
-- 2. Customers 
-- ==============================
CREATE TABLE Customers (
    Customer_ID INT PRIMARY KEY IDENTITY(1,1),
    Full_name NVARCHAR(255) NOT NULL,
    DOB DATE NOT NULL,
    Email NVARCHAR(255) NOT NULL UNIQUE,
    Phone_Number VARCHAR(15),
    Address NVARCHAR(MAX),
    National_ID VARCHAR(20) UNIQUE,
    Tax_ID VARCHAR(20) UNIQUE,
    Employment_Status VARCHAR(50),
    Annual_Income DECIMAL(12,2),
    Created_At DATETIME2 DEFAULT GETDATE(),
    Updated_At DATETIME2 DEFAULT GETDATE()
);

ALTER TABLE Customers ALTER COLUMN Phone_Number VARCHAR(20);

-- ==============================
-- 3. Branches (Referenced by Employees & Accounts)
-- ==============================
CREATE TABLE Branches (
    Branch_ID INT PRIMARY KEY IDENTITY(1,1),
    Branch_Name VARCHAR(250) NOT NULL,
    Address VARCHAR(300),
    City NVARCHAR(100),
    State NVARCHAR(100),
    Country NVARCHAR(100),
    Manager_ID INT NULL,
    Contact_Number VARCHAR(15)
);

ALTER TABLE Branches NOCHECK CONSTRAINT FK__Branches__Manage__5629CD9C;
ALTER TABLE Branches CHECK CONSTRAINT FK__Branches__Manage__5629CD9C;

-- ==============================
-- 4. Employees (References Departments & Branches)
-- ==============================
CREATE TABLE Employees (
    Employee_ID INT PRIMARY KEY IDENTITY(1,1),
    Branch_ID INT FOREIGN KEY REFERENCES Branches(Branch_ID),
    Full_Name NVARCHAR(250) NOT NULL,
    Position VARCHAR(100) NOT NULL,
    Department_ID INT FOREIGN KEY REFERENCES Departments(Department_ID), 
    Salary DECIMAL(15,2) NOT NULL,
    Hire_Date DATE NOT NULL,
    Status VARCHAR(20)
);

ALTER TABLE Branches ADD FOREIGN KEY (Manager_ID) REFERENCES Employees(Employee_ID);

-- ==============================
-- 5. Accounts (References Customers & Branches)
-- ==============================
CREATE TABLE Accounts (
    Account_ID INT PRIMARY KEY IDENTITY(1,1),
    Customer_ID INT FOREIGN KEY REFERENCES Customers(Customer_ID),
    Account_Type VARCHAR(50) NOT NULL,
    Balance DECIMAL(15,2) NOT NULL,
    Currency NVARCHAR(10) NOT NULL,
    Status VARCHAR(20),
    Branch_ID INT FOREIGN KEY REFERENCES Branches(Branch_ID),
    Created_Date DATE
);

-- ==============================
-- 6. Transactions (References Accounts)
-- ==============================
CREATE TABLE Transactions (
    Transaction_ID INT PRIMARY KEY IDENTITY(1,1),
    Account_ID INT FOREIGN KEY REFERENCES Accounts(Account_ID),
    Transaction_Type VARCHAR(50) NOT NULL,
    Amount DECIMAL(15,2) NOT NULL,
    Currency NVARCHAR(10) NOT NULL,
    Date DATE NOT NULL,
    Status VARCHAR(20),
    Reference_No VARCHAR(50) UNIQUE
);

-- ==============================
-- 7. Credit Cards (References Customers)
-- ==============================
CREATE TABLE Credit_Cards (
    Card_ID INT PRIMARY KEY IDENTITY(1,1),
    Customer_ID INT FOREIGN KEY REFERENCES Customers(Customer_ID),
    Card_Number VARCHAR(16) NOT NULL UNIQUE,
    Card_Type VARCHAR(50) NOT NULL,
    CVV VARCHAR(4) NOT NULL,
    Expiry_Date DATE NOT NULL,
    Limit DECIMAL(15,2) NOT NULL,
    Status VARCHAR(20)
);

-- ==============================
-- 18. Merchants
-- ==============================
CREATE TABLE Merchants (
    Merchant_ID INT PRIMARY KEY IDENTITY(1,1),
    Merchant_Name NVARCHAR(100) NOT NULL,
    Industry VARCHAR(50) NOT NULL,
    Location VARCHAR(100) NOT NULL
);

-- ==============================
-- 8. Credit Card Transactions (References Credit Cards & Merchants)
-- ==============================
CREATE TABLE Credit_Card_Transactions (
    Transaction_ID INT PRIMARY KEY IDENTITY(1,1),
    Card_ID INT FOREIGN KEY REFERENCES Credit_Cards(Card_ID),
    Merchant_ID INT FOREIGN KEY REFERENCES Merchants(Merchant_ID),
    Amount DECIMAL(15,2) NOT NULL,
    Currency NVARCHAR(10) NOT NULL,
    Date DATE NOT NULL,
    Status VARCHAR(20)
);

-- ==============================
-- 9. Online Banking Users (References Customers)
-- ==============================
CREATE TABLE Online_Banking_Users (
    User_ID INT PRIMARY KEY IDENTITY(1,1),
    Customer_ID INT FOREIGN KEY REFERENCES Customers(Customer_ID),
    Username NVARCHAR(50) NOT NULL UNIQUE,
    Password_Hash NVARCHAR(300) NOT NULL,
    Last_Login DATE
);

-- ==============================
-- 10. Bill Payments (References Customers)
-- ==============================
CREATE TABLE Bill_Payments (
    Payment_ID INT PRIMARY KEY IDENTITY(1,1),
    Customer_ID INT FOREIGN KEY REFERENCES Customers(Customer_ID),
    Biller_Name VARCHAR(100) NOT NULL,
    Amount DECIMAL(15,2) NOT NULL,
    Date DATE NOT NULL,
    Status VARCHAR(20)
);

-- ==============================
-- 11. Mobile Banking Transactions (References Customers)
-- ==============================
CREATE TABLE Mobile_Banking_Transactions (
    Transaction_ID INT PRIMARY KEY IDENTITY(1,1),
    Customer_ID INT FOREIGN KEY REFERENCES Customers(Customer_ID),
    Device_ID INT,
    App_Version VARCHAR(50) NOT NULL,
    Transaction_Type VARCHAR(50) NOT NULL,
    Amount DECIMAL(15,2) NOT NULL,
    Date DATE NOT NULL
);

-- ==============================
-- 12. Loans (References Customers)
-- ==============================
CREATE TABLE Loans (
    Loan_ID INT PRIMARY KEY IDENTITY(1,1),
    Customer_ID INT FOREIGN KEY REFERENCES Customers(Customer_ID),
    Loan_Type VARCHAR(50) NOT NULL,
    Amount DECIMAL(15,2) NOT NULL,
    Interest_Rate DECIMAL(5,2) NOT NULL,
    Start_Date DATE NOT NULL,
    End_Date DATE NOT NULL,
    Status VARCHAR(20)
);

-- ==============================
-- 13. Loan Payments (References Loans)
-- ==============================
CREATE TABLE Loan_Payments (
    Payment_ID INT PRIMARY KEY IDENTITY(1,1),
    Loan_ID INT FOREIGN KEY REFERENCES Loans(Loan_ID),
    Amount_Paid DECIMAL(15,2) NOT NULL,
    Payment_Date DATE NOT NULL,
    Remaining_Balance DECIMAL(15,2) NOT NULL
);

-- ==============================
-- 14. Credit Scores (References Customers)
-- ==============================
CREATE TABLE Credit_Scores (
    Customer_ID INT PRIMARY KEY FOREIGN KEY REFERENCES Customers(Customer_ID),
    Credit_Score INT,
    Updated_At DATE
);

-- ==============================
-- 15. KYC (References Customers)
-- ==============================
CREATE TABLE KYC (
    KYC_ID INT PRIMARY KEY IDENTITY(1,1),
    Customer_ID INT FOREIGN KEY REFERENCES Customers(Customer_ID),
    Document_Type VARCHAR(50) NOT NULL,
    Document_Number VARCHAR(50) NOT NULL UNIQUE,
    Verified_By VARCHAR(100)
);

-- ==============================
-- 16. Fraud Detection (References Customers & Transactions)
-- ==============================
CREATE TABLE Fraud_Detection (
    Fraud_ID INT PRIMARY KEY IDENTITY(1,1),
    Customer_ID INT FOREIGN KEY REFERENCES Customers(Customer_ID),
    Transaction_ID INT FOREIGN KEY REFERENCES Transactions(Transaction_ID),
    Risk_Level VARCHAR(50) NOT NULL,
    Reported_Date DATE NOT NULL
);

ALTER TABLE Fraud_Detection NOCHECK CONSTRAINT FK__Fraud_Det__Trans__01142BA1;
-- Insert your data
ALTER TABLE Fraud_Detection CHECK CONSTRAINT FK__Fraud_Det__Trans__01142BA1;


-- ==============================
-- 17. AML Cases (References Customers & Employees)
-- ==============================
CREATE TABLE AML (
    Case_ID INT PRIMARY KEY IDENTITY(1,1),
    Customer_ID INT FOREIGN KEY REFERENCES Customers(Customer_ID),
    Case_Type VARCHAR(50) NOT NULL,
    Status VARCHAR(20) NOT NULL,
    Investigator_ID INT FOREIGN KEY REFERENCES Employees(Employee_ID)
);


-- ==============================
-- 19. Merchant Transactions (References Merchants)
-- ==============================
CREATE TABLE Merchant_Transactions (
    Transaction_ID INT PRIMARY KEY IDENTITY(1,1),
    Merchant_ID INT FOREIGN KEY REFERENCES Merchants(Merchant_ID),
    Amount DECIMAL(15,2) NOT NULL,
    Payment_Method VARCHAR(50) NOT NULL,
    Date DATE NOT NULL
);

-- ==============================
-- 20. Salaries (References Employees)
-- ==============================
CREATE TABLE Salaries (
    Salary_ID INT PRIMARY KEY IDENTITY(1,1),
    Employee_ID INT FOREIGN KEY REFERENCES Employees(Employee_ID),
    Base_Salary DECIMAL(15,2) NOT NULL,
    Bonus DECIMAL(15,2) DEFAULT 0,
    Deductions DECIMAL(15,2) DEFAULT 0,
    Payment_Date DATE NOT NULL
);

-- ==============================
-- 21. Employee Attendance (References Employees)
-- ==============================
CREATE TABLE Employee_Attendance (
    Attendance_ID INT PRIMARY KEY IDENTITY(1,1),
    Employee_ID INT FOREIGN KEY REFERENCES Employees(Employee_ID),
    Check_in_Time TIME NOT NULL,
    Check_out_Time TIME NOT NULL,
    Total_Hours DECIMAL(5,2) NOT NULL
);

-- ==============================
-- 22. Debt Collection (References Customers)
-- ==============================
CREATE TABLE Debt_Collection (
    Debt_ID INT PRIMARY KEY IDENTITY(1,1),
    Customer_ID INT FOREIGN KEY REFERENCES Customers(Customer_ID),
    Amount_Due DECIMAL(15,2) NOT NULL,
    Due_Date DATE NOT NULL,
    Collector_Assigned VARCHAR(100)
);

-- ==============================
-- 23. Investments (References Customers)
-- ==============================
CREATE TABLE Investments (
    Investment_ID INT PRIMARY KEY IDENTITY(1,1),
    Customer_ID INT FOREIGN KEY REFERENCES Customers(Customer_ID),
    Investment_Type VARCHAR(50) NOT NULL,
    Amount DECIMAL(15,2) NOT NULL,
    ROI DECIMAL(5,2) NOT NULL,
    Maturity_Date DATE NOT NULL
);

-- ==============================
-- 24. Stock Trading Accounts (References Customers)
-- ==============================
CREATE TABLE Stock_Trading_Accounts (
    Account_ID INT PRIMARY KEY IDENTITY(1,1),
    Customer_ID INT FOREIGN KEY REFERENCES Customers(Customer_ID),
    Brokerage_Firm NVARCHAR(100) NOT NULL,
    Total_Invested DECIMAL(15,2) NOT NULL,
    Current_Value DECIMAL(15,2) NOT NULL
);

-- ==============================
-- 25. Foreign Exchange 
-- ==============================
CREATE TABLE Foreign_Exchange (
    FX_ID INT PRIMARY KEY IDENTITY(1,1),
    Customer_ID INT FOREIGN KEY REFERENCES Customers(Customer_ID),
    Currency_Pair VARCHAR(10) NOT NULL,
    Exchange_Rate DECIMAL(15,6) NOT NULL,
    Amount_Exchanged DECIMAL(15,2) NOT NULL
);

-- ==============================
-- 26. Insurance Policies 
-- ==============================
CREATE TABLE Insurance_Policies (
    Policy_ID INT PRIMARY KEY IDENTITY(1,1),
    Customer_ID INT FOREIGN KEY REFERENCES Customers(Customer_ID),
    Insurance_Type VARCHAR(50) NOT NULL,
    Premium_Amount DECIMAL(15,2) NOT NULL,
    Coverage_Amount DECIMAL(15,2) NOT NULL
);

-- ==============================
-- 27. Insurance Claims 
-- ==============================
CREATE TABLE Claims (
    Claim_ID INT PRIMARY KEY IDENTITY(1,1),
    Policy_ID INT FOREIGN KEY REFERENCES Insurance_Policies(Policy_ID),
    Claim_Amount DECIMAL(15,2) NOT NULL,
    Status VARCHAR(50) NOT NULL,
    Filed_Date DATE NOT NULL
);

-- ==============================
-- 28. User Access Logs 
-- ==============================
CREATE TABLE User_Access_Logs (
    Log_ID INT PRIMARY KEY IDENTITY(1,1),
    User_ID INT FOREIGN KEY REFERENCES Online_Banking_Users(User_ID),
    Action_Type VARCHAR(50) NOT NULL,
    Timestamp DATETIME2 DEFAULT GETDATE()
);

-- ==============================
-- 29. Cyber Security Incidents
-- ==============================
CREATE TABLE Cyber_Security_Incidents (
    Incident_ID INT PRIMARY KEY IDENTITY(1,1),
    Affected_System VARCHAR(100) NOT NULL,
    Reported_Date DATE NOT NULL,
    Resolution_Status VARCHAR(50) NOT NULL
);

-- ==============================
-- 30. Regulatory Reports
-- ==============================
CREATE TABLE Regulatory_Reports (
    Report_ID INT PRIMARY KEY IDENTITY(1,1),
    Report_Type VARCHAR(50) NOT NULL,
    Submission_Date DATE NOT NULL
);

go
 -- 30 tables
select * from Departments -- 30 rows
select * from Customers -- 1000 rows
select * from Branches -- 700 rows
select * from Employees -- 1292 rows
select * from Accounts  -- 219 rows
select * from Transactions -- 425 rows
select * from Credit_Cards -- 2000 rows
select * from Merchants -- 1000 rows
select * from Credit_Card_Transactions -- 500 rows
select * from Online_Banking_Users -- 499 rows
select * from Bill_Payments  -- 499 rows
select * from Mobile_Banking_Transactions -- 498 rows
select * from Loans -- 500 rows
select * from Loan_Payments -- 500 rows
select * from Credit_Scores -- 397
select * from KYC -- 500 rows
select * from Fraud_Detection -- 208 rows
select * from AML	-- 100 rows
select * from Merchant_Transactions -- 100 rows
select * from Salaries -- 690 rows
select * from Employee_Attendance -- 50 rows
select * from  Debt_Collection --48 rows
select * from Investments -- 96 rows
select * from Stock_Trading_Accounts -- 46 rows
select * from Foreign_Exchange -- 95 rows
select * from Insurance_Policies -- 47 rows
select * from Claims -- 48 rows
select * from User_Access_Logs -- 981 rows
select * from Cyber_Security_Incidents -- 100 rows
select * from Regulatory_Reports -- 100 rows

select 30+1000+700+1292+219+425+2000+1000+500+499+499+498+500+500+397+500+208+100+100+690+50+48+96+46+95+47+48+981+100+100

-- •	Top 3 Customers with the Highest Total Balance Across All Accounts 

select * from Customers
select * from Accounts
select top 3 c.Customer_ID, c.Full_name, sum(a.Balance) as Total_Balance
FROM Customers c
JOIN Accounts a ON c.Customer_ID = a.Customer_ID
GROUP BY c.Customer_ID, c.Full_name
ORDER BY Total_Balance DESC;

-- •	Customers Who Have More Than One Active Loan
select * from Customers
select * from Loans

SELECT c.Customer_ID, c.Full_name, COUNT(l.Loan_ID) AS Active_Loan_Count
FROM Customers c
JOIN Loans l ON c.Customer_ID = l.Customer_ID
WHERE l.Status = 'Active' 
GROUP BY c.Customer_ID, c.Full_Name
HAVING COUNT(l.Loan_ID) > 1;


-- •	Transactions That Were Flagged as Fraudulent  
select * from Transactions
select * from Fraud_Detection
SELECT t.Transaction_ID, t.Amount, t.Currency, t.Date, f.Risk_Level
FROM Transactions t
JOIN Fraud_Detection f ON t.Transaction_ID = f.Transaction_ID
WHERE f.Risk_Level = 'High';  

-- •	Total Loan Amount Issued Per Branch
select * from Branches
select * from Loans
select * from Accounts
select * from Customers

SELECT b.Branch_ID, b.Branch_Name, SUM(l.Amount) AS Total_Loan_Issued
FROM Branches b
JOIN Accounts a ON b.Branch_ID = a.Branch_ID 
JOIN Customers c ON a.Customer_ID = c.Customer_ID 
JOIN Loans l ON c.Customer_ID = l.Customer_ID 
GROUP BY b.Branch_ID, b.Branch_Name;

-- •	Customers who made multiple large transactions (above $10,000) within a short time frame (less than 1 hour apart)
select * from Transactions
select * from Accounts
select * from Customers

SELECT c.Customer_ID, c.Full_name, COUNT(t1.Transaction_ID) AS Large_Transaction_Count
FROM  Transactions t1
JOIN  Accounts a ON t1.Account_ID = a.Account_ID  
JOIN   Customers c ON a.Customer_ID = c.Customer_ID  
JOIN  Transactions t2 ON t1.Account_ID = t2.Account_ID
WHERE 
    t1.Transaction_ID <> t2.Transaction_ID
    AND t1.Amount > 500 -- in data, there is no more than 10 000 amount
    AND t2.Amount > 500
    AND ABS(DATEDIFF(MINUTE, t1.Date, t2.Date)) < 60000  -- it is because , data does not have transactions within 1 hoir
GROUP BY 
    c.Customer_ID, c.Full_name
HAVING 
    COUNT(t1.Transaction_ID) > 1;


-- •	Customers who have made transactions from different countries within 10 minutes, a common red flag for fraud.
select * from Transactions
select * from Accounts
select * from Branches
select * from Fraud_Detection

SELECT 
    a.Customer_ID,
    COUNT(DISTINCT b.Country) AS Distinct_Countries,
    COUNT(DISTINCT fd.Transaction_ID) AS Fraudulent_Transactions
FROM 
    Transactions t1
JOIN 
    Accounts a ON t1.Account_ID = a.Account_ID
JOIN 
    Branches b ON a.Branch_ID = b.Branch_ID
JOIN 
    Transactions t2 ON a.Customer_ID = (SELECT Customer_ID FROM Accounts WHERE Account_ID = t2.Account_ID) 
LEFT JOIN 
    Fraud_Detection fd ON t1.Transaction_ID = fd.Transaction_ID
WHERE 
    t1.Transaction_ID <> t2.Transaction_ID
    AND ABS(DATEDIFF(MINUTE, t1.Date, t2.Date)) < 1000000 -- no data in 10 mins
    AND EXISTS (
        SELECT 1
        FROM Accounts a2 
        JOIN Branches b2 ON a2.Branch_ID = b2.Branch_ID
        WHERE a2.Account_ID = t2.Account_ID AND b.Country <> b2.Country
    )
GROUP BY 
    a.Customer_ID
HAVING 
    COUNT(DISTINCT b.Country) > 1;

select * from Employees
order by Hire_Date

