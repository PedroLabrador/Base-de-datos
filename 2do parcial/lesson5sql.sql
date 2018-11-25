select avg(salary), max(salary), min(salary), sum(salary)
from employees
where job_id like '%SA%';

select max(last_name), min(last_name)
from employees
where job_id like '%SA%';

select count(distinct job_id) from employees;

select department_id, round(avg(salary),-2)
from employees
group by department_id
order by avg(salary);

select department_id, job_id, sum(salary)
from employees
group by department_id, job_id;

select department_id, count(last_name)
from employees
group by department_id;

SELECT   department_id, AVG(salary)
FROM     employees
HAVING   avg(salary) > 8000
GROUP BY department_id;

select department_id, max(salary)
from employees
where salary > 5000
group by department_id
having max(salary) > 10000;

/* Practica 5 */

/*
  4. Visualice el salario mayor, el menor, la suma y el salario medio de todos los empleados. Etiquete
     las columnas Maximum, Minimum, Sum y Average, respectivamente. Redondee los resultados hacia el número entero
     más próximo. Coloque la sentencia SQL en un archivo de texto llamado lab5_4.sql
*/
SELECT 
  ROUND(MAX(salary)) "Maximum", 
  ROUND(MIN(salary)) "Minimum", 
  ROUND(SUM(salary)) "Sum", 
  ROUND(AVG(salary)) "Average"
FROM EMPLOYEES;

/*
  5. Modifique la consulta de lab5_4.sql para visualizar el salario mínimo, el máximo, la suma y
     el salario medio para cada tipo de cargo. Vuelva a guardar lab5_4.sql como lab5_5.sql. 
     Ejecute la sentencia de lab5_5.sql.
*/
SELECT 
  JOB_ID,
  ROUND(MAX(salary)) "Maximum", 
  ROUND(MIN(salary)) "Minimum", 
  ROUND(SUM(salary)) "Sum", 
  ROUND(AVG(salary)) "Average"
FROM EMPLOYEES
GROUP BY JOB_ID;

/*
  6. Escriba una consulta para visualizar el número de personas con el mismo cargo.
*/
SELECT JOB_ID, COUNT(*)
FROM EMPLOYEES
GROUP BY JOB_ID;

/*
  7. Determine el número de directores sin enumerarlos. Etiquete la columna como Number of
     Managers. Indicación: Utilice la columna MANAGER_ID para determinar el número de directores
*/
SELECT SUM(COUNT(DISTINCT MANAGER_ID)) "Number of Managers"
FROM EMPLOYEES
GROUP BY MANAGER_ID;

/*
  8. Escriba una consulta para visualizar la diferencia entre el salario mayor y el menor. Etiquete la
     columna DIFFERENCE
*/
SELECT (MAX(SALARY) - MIN(SALARY)) DIFFERENCE from employees;

/*
  9. Visualice el número de director y el salario del empleado de menor sueldo para dicho director.
     Excluya a todas las personas con director desconocido. Excluya los grupos donde el salario
     mínimo sea $6.000 o inferior. Ordene el resultado en orden descendente de salario
*/
SELECT MANAGER_ID, MIN(SALARY)
FROM EMPLOYEES 
WHERE MANAGER_ID IS NOT NULL
GROUP BY MANAGER_ID
HAVING MIN(SALARY) > 6000
ORDER BY MIN(SALARY) DESC;

/*
  10. Escriba una consulta para visualizar el nombre, la ubicación, el número de empleados y el
      salario medio de todos los empleados de cada departamento. Etiquete las columnas como
      Name, Location, Number of People y Salary, respectivamente. Redondee el salario
      medio en dos posiciones decimales.
*/
SELECT 
  DEPARTMENT_NAME "Name", 
  LOCATION_ID "Location", 
  COUNT(EMPLOYEE_ID) "Number of People", 
  ROUND(AVG(SALARY),2) "Salary" 
FROM EMPLOYEES 
JOIN DEPARTMENTS 
USING(DEPARTMENT_ID) 
GROUP BY DEPARTMENT_NAME, LOCATION_ID;

/*
  11. Cree una consulta que muestre el número total de empleados y, de ese total, el número de
      empleados contratados en 1995, 1996, 1997 y 1998. Cree las cabeceras de columna adecuadas
*/
SELECT SUM(DECODE(TO_CHAR(HIRE_DATE, 'YYYY'), '2002', 1,
                                              '2003', 1,
                                              '2004', 1,
                                              '2005', 1, 
                                              0)) Total,
       SUM(DECODE(TO_CHAR(HIRE_DATE, 'YYYY'), '2002', 1, 0)) "2002",
       SUM(DECODE(TO_CHAR(HIRE_DATE, 'YYYY'), '2003', 1, 0)) "2003",
       SUM(DECODE(TO_CHAR(HIRE_DATE, 'YYYY'), '2004', 1, 0)) "2004",
       SUM(DECODE(TO_CHAR(HIRE_DATE, 'YYYY'), '2005', 1, 0)) "2005"
FROM EMPLOYEES;

/*
  12. Cree una consulta matriz para visualizar el cargo, el salario para dicho cargo basado en el 
      número de departamento y el salario total para dicho cargo, para los departamentos 20, 50, 80
      y 90, asignando a cada columna la cabecera apropiada.
*/
SELECT DISTINCT JOB_ID, 
  SUM(DECODE(DEPARTMENT_ID, 20, SALARY, 0)) "20",
  SUM(DECODE(DEPARTMENT_ID, 50, SALARY, 0)) "50",
  SUM(DECODE(DEPARTMENT_ID, 80, SALARY, 0)) "80",
  SUM(DECODE(DEPARTMENT_ID, 90, SALARY, 0)) "90",
  SUM(SALARY) "Total"
FROM EMPLOYEES
JOIN JOBS
using (JOB_ID)
GROUP BY JOB_ID;

