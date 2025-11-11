-- ================================================================
-- Name: Karan Salunkhe
-- Roll No: TEAD23173
-- Class: TE AI & DS
-- Practical No: 6
-- Title: A PL/SQL block of code (Use of Control structure and Exception handling)
-- ================================================================


-- 1. Implicit Cursor Example
-- 2. Explicit Cursor Example (Salary Update)
-- 3. Explicit Cursor Example (Attendance Check)
-- 4. Parameterized Cursor (Merging Data)
-- 5. Parameterized Cursor (Department-wise Average Salary)
-- 6. Explicit Cursor FOR LOOP


-- The bank manager has decided to activate all those accounts which were previously marked as inactive for
-- performing no transaction in the last 365 days. Write a PL/SQL block (using implicit cursor) to update the status
-- of accounts and display a message based on the number of rows affected.

SET SERVEROUTPUT ON;

BEGIN
  UPDATE account
  SET status = 'Active'
  WHERE status = 'Inactive'
  AND last_transaction < SYSDATE - 365;

  IF SQL%FOUND THEN
    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' accounts activated.');
  ELSIF SQL%NOTFOUND THEN
    DBMS_OUTPUT.PUT_LINE('No accounts found to activate.');
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/



-- Increase the salary by 10% for employees having salary less than the average salary.
-- Whenever such updates take place, record them in increment_salary table.

SET SERVEROUTPUT ON;

DECLARE
  CURSOR c1 IS SELECT e_no, salary FROM emp WHERE salary < (SELECT AVG(salary) FROM emp);
  v_emp emp.e_no%TYPE;
  v_sal emp.salary%TYPE;
BEGIN
  FOR rec IN c1 LOOP
    UPDATE emp SET salary = salary + (salary * 0.10) WHERE e_no = rec.e_no;
    INSERT INTO increment_salary VALUES(rec.e_no, rec.salary);
    DBMS_OUTPUT.PUT_LINE('Salary updated for Employee No: ' || rec.e_no);
  END LOOP;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/



-- Mark students as detained (D) if attendance < 75%, and record in d_stud table.

CREATE TABLE stud21(roll NUMBER(4), att NUMBER(4), status VARCHAR2(1));
CREATE TABLE d_stud(roll NUMBER(4), att NUMBER(4));


SET SERVEROUTPUT ON;

DECLARE
  CURSOR c_stud IS SELECT roll, att FROM stud21 WHERE att < 75;
BEGIN
  FOR rec IN c_stud LOOP
    UPDATE stud21 SET status = 'D' WHERE roll = rec.roll;
    INSERT INTO d_stud VALUES(rec.roll, rec.att);
    DBMS_OUTPUT.PUT_LINE('Student ' || rec.roll || ' detained.');
  END LOOP;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/



-- Merge data from N_RollCall into O_RollCall. Skip if already exists.

SET SERVEROUTPUT ON;

DECLARE
  CURSOR c_roll(p_roll NUMBER) IS 
    SELECT roll_no FROM O_RollCall WHERE roll_no = p_roll;
BEGIN
  FOR rec IN (SELECT * FROM N_RollCall) LOOP
    OPEN c_roll(rec.roll_no);
    FETCH c_roll INTO rec.roll_no;
    IF c_roll%NOTFOUND THEN
      INSERT INTO O_RollCall VALUES(rec.roll_no, rec.name);
      DBMS_OUTPUT.PUT_LINE('Inserted Roll No: ' || rec.roll_no);
    ELSE
      DBMS_OUTPUT.PUT_LINE('Skipped duplicate Roll No: ' || rec.roll_no);
    END IF;
    CLOSE c_roll;
  END LOOP;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/




-- Insert department-wise average salary into a new table dept_salary.

CREATE TABLE emp(e_no NUMBER, d_no NUMBER, salary NUMBER);
CREATE TABLE dept_salary(d_no NUMBER, avg_salary NUMBER);

SET SERVEROUTPUT ON;

DECLARE
  CURSOR c_dept(p_dno NUMBER) IS 
    SELECT AVG(salary) FROM emp WHERE d_no = p_dno;
  v_avg NUMBER;
BEGIN
  FOR rec IN (SELECT DISTINCT d_no FROM emp) LOOP
    OPEN c_dept(rec.d_no);
    FETCH c_dept INTO v_avg;
    INSERT INTO dept_salary VALUES(rec.d_no, v_avg);
    CLOSE c_dept;
    DBMS_OUTPUT.PUT_LINE('Inserted Avg Salary for Dept: ' || rec.d_no);
  END LOOP;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/




-- Use cursor FOR loop to mark students detained (D) if attendance < 75% and record in d_stud.

SET SERVEROUTPUT ON;

DECLARE
  CURSOR c_detain IS SELECT roll, att FROM stud21 WHERE att < 75;
BEGIN
  FOR rec IN c_detain LOOP
    UPDATE stud21 SET status = 'D' WHERE roll = rec.roll;
    INSERT INTO d_stud VALUES(rec.roll, rec.att);
    DBMS_OUTPUT.PUT_LINE('Detained student: ' || rec.roll);
  END LOOP;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/
