SET SERVEROUTPUT ON;
/*DECLARE
  v_last_name varchar2(20);
  v_employee_id number;
  CURSOR cu_employees IS
    SELECT last_name, employee_id FROM employees ORDER BY employee_id DESC;
BEGIN
  OPEN cu_employees;
  LOOP
    FETCH cu_employees INTO v_last_name, v_employee_id; 
    DBMS_OUTPUT.PUT_LINE(v_employee_id || ' ' || v_last_name);
    EXIT WHEN cu_employees%NOTFOUND OR cu_employees%ROWCOUNT >= 10 OR cu_employees%NOTFOUND IS NULL;
  END LOOP;
  CLOSE cu_employees;
END;
/

DECLARE
  CURSOR cu_employees IS
    SELECT last_name, employee_id FROM employees ORDER BY employee_id DESC;
  re_cursor cu_employees%ROWTYPE;
BEGIN
  OPEN cu_employees;
  LOOP
    FETCH cu_employees INTO re_cursor;
    DBMS_OUTPUT.PUT_LINE(re_cursor.employee_id || ' ' || re_cursor.last_name);
    EXIT WHEN cu_employees%NOTFOUND OR cu_employees%ROWCOUNT >= 10 OR cu_employees%NOTFOUND IS NULL;
  END LOOP;
  CLOSE cu_employees;
END;
/

DECLARE
  CURSOR cu_employees IS
    SELECT employee_id, last_name, job_id, hire_date FROM employees ORDER BY employee_id ASC;
BEGIN
  FOR emp_reg IN cu_employees LOOP
    IF cu_employees%ROWCOUNT > 5 THEN
      EXIT;
    END IF;
    DBMS_OUTPUT.PUT_LINE(emp_reg.last_name || ' ' || emp_reg.job_id || ' ' || emp_reg.hire_date);
  END LOOP;
END;*/
  

/*DECLARE
  CURSOR cu_employees IS
    SELECT DISTINCT EMPLOYEE_ID, SALARY FROM EMPLOYEES ORDER BY SALARY DESC;
  emp_salaries cu_employees%ROWTYPE;
  max_employees NUMBER;
BEGIN
  IF NOT cu_employees%ISOPEN THEN
    OPEN cu_employees;
  END IF;
  max_employees := &max_employees;
  LOOP
    FETCH cu_employees INTO emp_salaries;
    EXIT WHEN cu_employees%NOTFOUND OR cu_employees%NOTFOUND IS NULL OR cu_employees%ROWCOUNT > max_employees;
    DBMS_OUTPUT.PUT_LINE(emp_salaries.employee_id );
    INSERT INTO TOP_DOGS VALUES(emp_salaries.salary);
  END LOOP;
  CLOSE cu_employees;
END;
/

DELETE FROM TOP_DOGS;
SELECT * FROM TOP_DOGS;*/

/*DECLARE
  CURSOR cur_emp IS
    SELECT e.DEPARTMENT_ID, e.LAST_NAME, e.SALARY, e.MANAGER_ID FROM EMPLOYEES e JOIN DEPARTMENTS d ON d.DEPARTMENT_ID = e.DEPARTMENT_ID ORDER BY d.DEPARTMENT_ID;
  last_department NUMBER := NULL;
BEGIN
  FOR current_emp IN cur_emp LOOP
    IF current_emp.salary < 5000 AND (current_emp.manager_id = 101 OR current_emp.manager_id = 104) THEN
        DBMS_OUTPUT.PUT_LINE(current_emp.department_id || '  ' || current_emp.last_name || ' ' || 'Due for a raise');        
    ELSE 
          DBMS_OUTPUT.PUT_LINE(current_emp.department_id || '  ' || current_emp.last_name || ' ' || 'Not due for a raise');
    END IF;
  END LOOP;
END;*/

/*DECLARE
  CURSOR cur_depart IS
    SELECT DEPARTMENT_ID, DEPARTMENT_NAME FROM DEPARTMENTS WHERE DEPARTMENT_ID < 100;
  CURSOR cur_empl (did NUMBER) IS
    SELECT LAST_NAME, JOB_ID, HIRE_DATE, SALARY FROM EMPLOYEES WHERE EMPLOYEE_ID < 120 AND DEPARTMENT_ID = did;
BEGIN
  FOR dep IN cur_depart LOOP
    DBMS_OUTPUT.PUT_LINE('Department Number: ' || dep.department_id || ' Department Name: ' || dep.department_name);
    DBMS_OUTPUT.PUT_LINE('');
    FOR emp IN cur_empl(dep.department_id) LOOP
      DBMS_OUTPUT.PUT_LINE(emp.LAST_NAME || ' ' || emp.JOB_ID || ' ' || emp.hire_date || ' ' || emp.salary);
    END LOOP; 
    DBMS_OUTPUT.PUT_LINE('');
  END LOOP;
END;
/*/
