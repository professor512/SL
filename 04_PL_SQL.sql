-- ================================================================
-- Name: Karan Salunkhe
-- Roll No: TEAD23173
-- Class: TE AI & DS
-- Practical No: 4
-- Title: A PL/SQL block of code (Use of Control structure and Exception handling)
-- ================================================================


-- Q1: Check attendance of a student and update status accordingly
-- Table: Stud(Roll, Att, Status)

CREATE TABLE Stud(
  Roll NUMBER PRIMARY KEY,
  Att NUMBER(5,2),
  Status CHAR(2)
);

-- Sample data
INSERT INTO Stud VALUES(1, 80, NULL);
INSERT INTO Stud VALUES(2, 60, NULL);
COMMIT;

-- PL/SQL block
SET SERVEROUTPUT ON;
DECLARE
  v_roll Stud.Roll%TYPE;
  v_att Stud.Att%TYPE;
BEGIN
  v_roll := &Enter_Roll_No; -- User input

  SELECT Att INTO v_att FROM Stud WHERE Roll = v_roll;

  IF v_att < 75 THEN
    DBMS_OUTPUT.PUT_LINE('Term not granted');
    UPDATE Stud SET Status = 'D' WHERE Roll = v_roll;
  ELSE
    DBMS_OUTPUT.PUT_LINE('Term granted');
    UPDATE Stud SET Status = 'ND' WHERE Roll = v_roll;
  END IF;

  COMMIT;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No student found with given Roll Number');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Unexpected Error: ' || SQLERRM);
END;
/





-- Q2: Handle withdrawal when amount exceeds current balance
-- Table: account_master(acc_no, balance)

CREATE TABLE account_master(
  acc_no NUMBER PRIMARY KEY,
  balance NUMBER(10,2)
);

-- Sample data
INSERT INTO account_master VALUES(101, 2000);
INSERT INTO account_master VALUES(102, 8000);
COMMIT;

-- PL/SQL block
SET SERVEROUTPUT ON;
DECLARE
  v_acc_no account_master.acc_no%TYPE := &Enter_Account_No;
  v_withdraw NUMBER(10,2) := &Enter_Withdrawal_Amount;
  v_balance account_master.balance%TYPE;

  ex_insufficient_balance EXCEPTION;
BEGIN
  SELECT balance INTO v_balance FROM account_master WHERE acc_no = v_acc_no;

  IF v_withdraw > v_balance THEN
    RAISE ex_insufficient_balance;
  ELSE
    UPDATE account_master SET balance = balance - v_withdraw WHERE acc_no = v_acc_no;
    DBMS_OUTPUT.PUT_LINE('Withdrawal successful! Remaining balance: ' || (v_balance - v_withdraw));
  END IF;

  COMMIT;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Account not found!');
  WHEN ex_insufficient_balance THEN
    DBMS_OUTPUT.PUT_LINE('Error: Insufficient balance for withdrawal!');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Unexpected Error: ' || SQLERRM);
END;
/





-- Q3: Borrower and Fine calculation
-- Tables:
-- Borrower(Roll_no, Name, Date_of_Issue, Name_of_Book, Status)
-- Fine(Roll_no, Date_, Amt)

CREATE TABLE Borrower(
  Roll_no NUMBER,
  Name VARCHAR2(30),
  Date_of_Issue DATE,
  Name_of_Book VARCHAR2(50),
  Status CHAR(1)
);

CREATE TABLE Fine(
  Roll_no NUMBER,
  Date_ DATE,
  Amt NUMBER(10,2)
);

-- Sample data
INSERT INTO Borrower VALUES(1, 'Karan', TO_DATE('10-OCT-2024','DD-MON-YYYY'), 'DBMS', 'I');
INSERT INTO Borrower VALUES(2, 'Riya', TO_DATE('25-SEP-2024','DD-MON-YYYY'), 'AI', 'I');
COMMIT;

-- PL/SQL block
SET SERVEROUTPUT ON;
DECLARE
  v_roll Borrower.Roll_no%TYPE := &Enter_Roll_No;
  v_book Borrower.Name_of_Book%TYPE := '&Enter_Book_Name';
  v_date_of_issue DATE;
  v_days NUMBER;
  v_amt NUMBER := 0;

  ex_not_found EXCEPTION;
BEGIN
  SELECT Date_of_Issue INTO v_date_of_issue
  FROM Borrower
  WHERE Roll_no = v_roll AND Name_of_Book = v_book AND Status = 'I';

  v_days := TRUNC(SYSDATE - v_date_of_issue);

  IF v_days BETWEEN 15 AND 30 THEN
    v_amt := v_days * 5;
  ELSIF v_days > 30 THEN
    v_amt := v_days * 50;
  ELSE
    v_amt := 0;
  END IF;

  UPDATE Borrower
  SET Status = 'R'
  WHERE Roll_no = v_roll AND Name_of_Book = v_book;

  IF v_amt > 0 THEN
    INSERT INTO Fine VALUES(v_roll, SYSDATE, v_amt);
    DBMS_OUTPUT.PUT_LINE('Fine imposed: Rs. ' || v_amt);
  ELSE
    DBMS_OUTPUT.PUT_LINE('No fine applicable.');
  END IF;

  COMMIT;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No record found or book already returned.');
  WHEN ex_not_found THEN
    DBMS_OUTPUT.PUT_LINE('Book not found for given Roll number.');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Unexpected Error: ' || SQLERRM);
END;
/
