-- ================================================================
-- Name: Karan Salunkhe
-- Roll No: TEAD23173
-- Class: TE AI & DS
-- Practical No: 1
-- Title: SQL queries using INSERT, SELECT, UPDATE, DELETE,
--         with Operators, Functions, and Set Operators
-- ================================================================

-- ====================== CREATE TABLES ===========================
CREATE TABLE Branch (
    branch_name VARCHAR(30) PRIMARY KEY,
    branch_city VARCHAR(30) NOT NULL,
    assets DECIMAL(12,2) CHECK (assets >= 0)
);

CREATE TABLE Account (
    acc_no INT PRIMARY KEY,
    branch_name VARCHAR(30),
    balance DECIMAL(10,2) CHECK (balance >= 0),
    FOREIGN KEY (branch_name) REFERENCES Branch(branch_name)
);

CREATE TABLE Customer (
    cust_name VARCHAR(30) PRIMARY KEY,
    cust_street VARCHAR(30),
    cust_city VARCHAR(30)
);

CREATE TABLE Depositor (
    cust_name VARCHAR(30),
    acc_no INT,
    PRIMARY KEY (cust_name, acc_no),
    FOREIGN KEY (cust_name) REFERENCES Customer(cust_name),
    FOREIGN KEY (acc_no) REFERENCES Account(acc_no)
);

CREATE TABLE Loan (
    loan_no INT PRIMARY KEY,
    branch_name VARCHAR(30),
    amount DECIMAL(10,2) CHECK (amount > 0),
    FOREIGN KEY (branch_name) REFERENCES Branch(branch_name)
);

CREATE TABLE Borrower (
    cust_name VARCHAR(30),
    loan_no INT,
    PRIMARY KEY (cust_name, loan_no),
    FOREIGN KEY (cust_name) REFERENCES Customer(cust_name),
    FOREIGN KEY (loan_no) REFERENCES Loan(loan_no)
);

-- ====================== INSERT SAMPLE DATA ======================
INSERT INTO Branch VALUES ('Akurdi', 'Pune', 1000000);
INSERT INTO Branch VALUES ('Nigdi', 'Pune', 800000);
INSERT INTO Branch VALUES ('Kothrud', 'Pune', 900000);

INSERT INTO Account VALUES (101, 'Akurdi', 15000);
INSERT INTO Account VALUES (102, 'Nigdi', 8000);
INSERT INTO Account VALUES (103, 'Akurdi', 20000);

INSERT INTO Customer VALUES ('Rohan', 'MG Road', 'Pune');
INSERT INTO Customer VALUES ('Meera', 'Shivaji Nagar', 'Pune');
INSERT INTO Customer VALUES ('Karan', 'Nigdi', 'Pune');

INSERT INTO Depositor VALUES ('Rohan', 101);
INSERT INTO Depositor VALUES ('Meera', 102);
INSERT INTO Depositor VALUES ('Karan', 103);

INSERT INTO Loan VALUES (201, 'Akurdi', 15000);
INSERT INTO Loan VALUES (202, 'Nigdi', 10000);
INSERT INTO Loan VALUES (203, 'Akurdi', 25000);

INSERT INTO Borrower VALUES ('Rohan', 201);
INSERT INTO Borrower VALUES ('Karan', 203);

-- ================================================================
-- Q1. Find the names of all branches in loan relation.
-- ================================================================
SELECT DISTINCT branch_name FROM Loan;

-- ================================================================
-- Q2. Find all loan numbers for loans made at Akurdi Branch 
--     with loan amount > 12000.
-- ================================================================
SELECT loan_no 
FROM Loan 
WHERE branch_name = 'Akurdi' AND amount > 12000;

-- ================================================================
-- Q3. Find all customers who have a loan from bank. 
--     Find their names, loan_no and loan amount.
-- ================================================================
SELECT Borrower.cust_name, Borrower.loan_no, Loan.amount 
FROM Borrower 
JOIN Loan ON Borrower.loan_no = Loan.loan_no;

-- ================================================================
-- Q4. List all customers in alphabetical order who have 
--     loan from Akurdi branch.
-- ================================================================
SELECT DISTINCT Borrower.cust_name 
FROM Borrower 
JOIN Loan ON Borrower.loan_no = Loan.loan_no 
WHERE Loan.branch_name = 'Akurdi'
ORDER BY Borrower.cust_name;

-- ================================================================
-- Q5. Find all customers who have an account or loan or both.
-- ================================================================
SELECT cust_name FROM Depositor
UNION
SELECT cust_name FROM Borrower;

-- ================================================================
-- Q6. Find all customers who have both account and loan.
-- ================================================================
SELECT cust_name FROM Depositor
INTERSECT
SELECT cust_name FROM Borrower;

-- ================================================================
-- Q7. Find all customers who have account but no loan.
-- ================================================================
SELECT cust_name FROM Depositor
MINUS
SELECT cust_name FROM Borrower;

-- ================================================================
-- Q8. Find average account balance at Akurdi branch.
-- ================================================================
SELECT AVG(balance) AS avg_balance
FROM Account
WHERE branch_name = 'Akurdi';

-- ================================================================
-- Q9. Find the average account balance at each branch.
-- ================================================================
SELECT branch_name, AVG(balance) AS avg_balance
FROM Account
GROUP BY branch_name;

-- ================================================================
-- Q10. Find number of depositors at each branch.
-- ================================================================
SELECT A.branch_name, COUNT(D.cust_name) AS num_depositors
FROM Account A
JOIN Depositor D ON A.acc_no = D.acc_no
GROUP BY A.branch_name;

-- ================================================================
-- Q11. Find the branches where average account balance > 12000.
-- ================================================================
SELECT branch_name
FROM Account
GROUP BY branch_name
HAVING AVG(balance) > 12000;

-- ================================================================
-- Q12. Find number of tuples in customer relation.
-- ================================================================
SELECT COUNT(*) AS total_customers FROM Customer;

-- ================================================================
-- Q13. Calculate total loan amount given by bank.
-- ================================================================
SELECT SUM(amount) AS total_loan FROM Loan;

-- ================================================================
-- Q14. Delete all loans with loan amount between 1300 and 1500.
-- ================================================================
DELETE FROM Loan WHERE amount BETWEEN 1300 AND 1500;

-- ================================================================
-- Q15. Delete all tuples at every branch located in Nigdi.
-- ================================================================
DELETE FROM Branch WHERE branch_city = 'Nigdi';

-- ================================================================
-- Q16. Create synonym for customer table as cust.
-- ================================================================
CREATE SYNONYM cust FOR Customer;

-- ================================================================
-- Q17. Create sequence roll_seq and use in student table 
--      for roll_no column.
-- ================================================================
CREATE SEQUENCE roll_seq
START WITH 1
INCREMENT BY 1;

CREATE TABLE Student (
    roll_no INT PRIMARY KEY,
    name VARCHAR(30)
);

INSERT INTO Student VALUES (roll_seq.NEXTVAL, 'Karan');

-- ======================= END OF PRACTICAL =======================
