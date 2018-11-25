/*
  1. Escriba una consulta que muestre el apellido y la fecha de contratación de cualquier empleado
     del mismo departamento que Zlotkey. Excluya a Zlotkey.
*/
SELECT LAST_NAME, HIRE_DATE
FROM EMPLOYEES
WHERE JOB_ID = (SELECT JOB_ID FROM EMPLOYEES WHERE LAST_NAME = 'Zlotkey')
AND LAST_NAME <> 'Zlotkey';

/*
  2. Cree una consulta para mostrar los números de empleado y los apellidos de todos los empleados
     que ganen más del salario medio. Ordene los resultados por salario en orden ascendente
*/
SELECT EMPLOYEE_ID, LAST_NAME, SALARY
FROM EMPLOYEES
WHERE SALARY > (SELECT AVG(SALARY) FROM EMPLOYEES)
ORDER BY SALARY ASC;

/*
  3. Escriba una consulta que muestre los números de empleado y los apellidos de todos los
     empleados que trabajen en un departamento con cualquier empleado cuyo apellido contenga una u.
     Coloque la sentencia SQL en un archivo de texto llamado lab6_3.sql. Ejecute la consulta.
*/
SELECT EMPLOYEE_ID, LAST_NAME, JOB_ID
FROM EMPLOYEES
WHERE JOB_ID IN (SELECT DISTINCT JOB_ID FROM EMPLOYEES WHERE LAST_NAME LIKE '%u%');

/*
  4. Muestre el apellido, el número de departamento y el identificador de cargo de todos los
     empleados cuyos identificadores de ubicación de departamento sean 1700
*/
SELECT LAST_NAME, DEPARTMENT_ID, JOB_ID
FROM EMPLOYEES
WHERE DEPARTMENT_ID = ANY (SELECT DEPARTMENT_ID FROM DEPARTMENTS WHERE LOCATION_ID = 1700);

/*
  5. Muestre el apellido y el salario de todos los empleados que informen a King
*/
SELECT LAST_NAME, SALARY 
FROM EMPLOYEES 
WHERE MANAGER_ID = (SELECT EMPLOYEE_ID FROM EMPLOYEES WHERE LAST_NAME = 'King' AND MANAGER_ID IS NULL);

/*
  6. Muestre el número de departamento, el apellido y el identificador de cargo de todos los
     empleados del departamento Executive.
*/
SELECT DEPARTMENT_ID, LAST_NAME, JOB_ID
FROM EMPLOYEES
WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID FROM DEPARTMENTS WHERE DEPARTMENT_NAME = 'Executive');

/*
  7. Modifique la consulta en lab6_3.sql para mostrar los números de empleado, los apellidos
     y los salarios de todos los empleados que ganan más del salario medio y que trabajan en un
     departamento con un empleado que tenga una u en su apellido. Vuelva a guardar lab6_3.sql como 
     lab6_7.sql. Ejecute la sentencia en lab6_7.sql.
*/
SELECT EMPLOYEE_ID, LAST_NAME, JOB_ID, SALARY
FROM EMPLOYEES
WHERE SALARY > (SELECT AVG(SALARY) FROM EMPLOYEES)
AND JOB_ID IN (SELECT DISTINCT JOB_ID FROM EMPLOYEES WHERE LAST_NAME LIKE '%u%'); 