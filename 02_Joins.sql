-- =========================================================

-- Name: Karan Salunkhe
-- Roll No: TEAD23173
-- Class: TE AI & DS
-- Practical No: 2
-- Title: SQL using JOINs, SUBQUERIES and VIEWS

-- =========================================================

-- =========================================================
-- Q1. Retrieve address of customer whose Fname='xyz' and Lname='pqr'
-- =========================================================

CREATE TABLE cust_mstr (
    cust_no INT PRIMARY KEY,
    fname VARCHAR(30),
    lname VARCHAR(30)
);

CREATE TABLE add_dets (
    code_no INT,
    add1 VARCHAR(50),
    add2 VARCHAR(50),
    state VARCHAR(30),
    city VARCHAR(30),
    pincode VARCHAR(10),
    FOREIGN KEY (code_no) REFERENCES cust_mstr(cust_no)
);

-- Insert sample data
INSERT INTO cust_mstr VALUES (1, 'xyz', 'pqr'), (2, 'Karan', 'Salunkhe');
INSERT INTO add_dets VALUES 
(1, 'MG Road', 'Sector 5', 'Maharashtra', 'Pune', '411001'),
(2, 'Station Road', 'Sector 3', 'Maharashtra', 'Nigdi', '411044');

-- Query: Retrieve address of customer Fname as 'xyz' and Lname as 'pqr'
SELECT c.fname, c.lname, a.add1, a.add2, a.state, a.city, a.pincode
FROM cust_mstr c
JOIN add_dets a ON c.cust_no = a.code_no
WHERE c.fname = 'xyz' AND c.lname = 'pqr';


-- =========================================================
-- Q2. List the customer holding fixed deposit of amount more than 5000
-- =========================================================

CREATE TABLE acc_fd_cust_dets (
    code_no INT,
    acc_fd_no INT,
    FOREIGN KEY (code_no) REFERENCES cust_mstr(cust_no)
);

CREATE TABLE fd_dets (
    fd_sr_no INT PRIMARY KEY,
    amt DECIMAL(10,2)
);

-- Insert sample data
INSERT INTO acc_fd_cust_dets VALUES (1, 101), (2, 102);
INSERT INTO fd_dets VALUES (101, 8000), (102, 3000);

-- Query
SELECT c.fname, c.lname, f.amt
FROM cust_mstr c
JOIN acc_fd_cust_dets a ON c.cust_no = a.code_no
JOIN fd_dets f ON a.acc_fd_no = f.fd_sr_no
WHERE f.amt > 5000;


-- =========================================================
-- Q3. List the employee details along with branch names to which they belong
-- =========================================================

CREATE TABLE branch_mstr (
    b_no INT PRIMARY KEY,
    name VARCHAR(40)
);

CREATE TABLE emp_mstr (
    emp_no INT PRIMARY KEY,
    f_name VARCHAR(30),
    l_name VARCHAR(30),
    m_name VARCHAR(30),
    dept VARCHAR(30),
    desg VARCHAR(30),
    branch_no INT,
    FOREIGN KEY (branch_no) REFERENCES branch_mstr(b_no)
);

-- Insert sample data
INSERT INTO branch_mstr VALUES (1, 'Akurdi Branch'), (2, 'Nigdi Branch');
INSERT INTO emp_mstr VALUES 
(101, 'Karan', 'Salunkhe', 'M', 'AI', 'Engineer', 1),
(102, 'Yukta', 'Kaduskar', 'P', 'DS', 'Analyst', 2);

-- Query
SELECT e.emp_no, e.f_name, e.l_name, e.dept, e.desg, b.name AS branch_name
FROM emp_mstr e
JOIN branch_mstr b ON e.branch_no = b.b_no;


-- =========================================================
-- Q4. List the employee details along with contact details 
--     using LEFT OUTER JOIN and RIGHT JOIN
-- =========================================================

CREATE TABLE cntc_dets (
    code_no INT,
    cntc_type VARCHAR(20),
    cntc_data VARCHAR(50),
    FOREIGN KEY (code_no) REFERENCES emp_mstr(emp_no)
);

-- Insert sample data
INSERT INTO cntc_dets VALUES 
(101, 'Mobile', '9999999999'),
(101, 'Email', 'karan@gmail.com');

-- LEFT JOIN (All employees, matching contacts if any)
SELECT e.emp_no, e.f_name, e.l_name, c.cntc_type, c.cntc_data
FROM emp_mstr e
LEFT JOIN cntc_dets c ON e.emp_no = c.code_no;

-- RIGHT JOIN (All contacts, with employee details)
SELECT e.emp_no, e.f_name, e.l_name, c.cntc_type, c.cntc_data
FROM emp_mstr e
RIGHT JOIN cntc_dets c ON e.emp_no = c.code_no;


-- =========================================================
-- Q5. List customers who do not have bank branches in their vicinity
-- =========================================================

CREATE TABLE branch_area (
    city VARCHAR(30),
    branch_name VARCHAR(40)
);

-- Sample data
INSERT INTO branch_area VALUES ('Akurdi', 'Akurdi Branch'), ('Nigdi', 'Nigdi Branch');

-- Customers with address already in add_dets
SELECT c.fname, c.lname, a.city
FROM cust_mstr c
JOIN add_dets a ON c.cust_no = a.code_no
WHERE a.city NOT IN (SELECT city FROM branch_area);


-- =========================================================
-- Q6. Views and operations
-- =========================================================

-- For this, create sample borrower and depositor tables
CREATE TABLE borrower (
    cust_name VARCHAR(40),
    loan_no INT
);

CREATE TABLE depositor (
    cust_name VARCHAR(40),
    acc_no INT
);

INSERT INTO borrower VALUES ('Karan', 201), ('Yukta', 202);
INSERT INTO depositor VALUES ('Karan', 301), ('Anil', 302);

-- (a) Create View on borrower selecting two columns
CREATE VIEW borrower_view AS
SELECT cust_name, loan_no FROM borrower;

SELECT * FROM borrower_view;

-- Perform insert, update, delete on view
INSERT INTO borrower_view VALUES ('Riya', 203);
UPDATE borrower_view SET loan_no = 205 WHERE cust_name = 'Karan';
DELETE FROM borrower_view WHERE cust_name = 'Riya';


-- (b) Create view on borrower and depositor selecting one column from each
CREATE VIEW cust_info AS
SELECT b.cust_name, d.acc_no
FROM borrower b
JOIN depositor d ON b.cust_name = d.cust_name;

SELECT * FROM cust_info;

-- (c) Create updatable view on borrower and perform operations
CREATE VIEW borrower_update_view AS
SELECT cust_name, loan_no FROM borrower
WITH CHECK OPTION;

INSERT INTO borrower_update_view VALUES ('Sneha', 204);
UPDATE borrower_update_view SET loan_no = 210 WHERE cust_name = 'Sneha';
DELETE FROM borrower_update_view WHERE cust_name = 'Sneha';
