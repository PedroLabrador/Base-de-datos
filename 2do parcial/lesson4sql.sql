select e.last_name, d.department_name from employees e, departments d
where e.department_id = d.department_id;

select e.last_name, e.salary from employees e, jobs j where e.salary between j.min_salary and j.max_salary;

select e.last_name, e.hire_date from employees e, job_history j where e.hire_date between j.start_date and j.end_date;

select e.last_name, d.department_name from employees e, departments d where e.department_id(+) = d.department_id;

SELECT worker.last_name || ' works for ' 
       || manager.last_name
FROM   employees worker, employees manager
WHERE  worker.manager_id = manager.employee_id;

select e.last_name, d.department_name from employees e cross join departments d;
select e.last_name, d.department_name from employees e, departments d;

SELECT l.city, d.department_name
FROM   locations l JOIN departments d USING (location_id)
where location_id = 1400;

select 
  e.last_name, 
  d.department_name, 
  l.city 
from employees e
join departments d 
  on e.department_id = d.department_id 
join locations l 
  on d.location_id = l.location_id;
  
select e.last_name, e.department_id, d.department_name
from employees e
left outer join departments d
on e.department_id = d.department_id;

select e.last_name, e.department_id, d.department_name
from employees e
right outer join departments d
on e.department_id = d.department_id
where e.department_id is not null;

/* Practica 4 */

/*
  1. Escriba una consulta para visualizar el apellido del empleado, el número y el nombre de
     departamento para todos los empleados.
*/
select e.last_name, e.department_id, d.department_name 
from employees e
join departments d
on e.department_id = d.department_id;

/*
  2. Cree un listado único de todos los cargos que haya en el departamento 80. Incluya la
     ubicación del departamento en el resultado
*/
select distinct e.job_id, d.location_id 
from employees e 
join departments d 
on e.department_id = d.department_id
and e.department_id = 80;

/*
  3. Escriba una consulta para mostrar el apellido del empleado, el nombre de departamento, el
     identificador de ubicación y la ciudad de todos los empleados que perciben comisión
*/
select e.last_name, d.department_name, d.location_id, l.city
from employees e 
join departments d using (department_id)
join locations l
on d.location_id = l.location_id
where e.commission_pct is not null;

/*
  4. Visualice el apellido del empleado y el nombre de departamento para todos los empleados que 
     tengan una a (minúsculas) en el apellido. Coloque la sentencia SQL en un archivo de texto llamado lab4_4.sql.
*/
select e.last_name, d.department_name 
from employees e 
join departments d 
on e.department_id = d.department_id
where e.last_name like '%a%';

/*
  5. Escriba una consulta para visualizar el apellido, el cargo, el número y el nombre de
     departamento para todos  los empleados que trabajan en Toronto.
*/
SELECT e.LAST_NAME, e.JOB_ID, e.DEPARTMENT_ID, d.DEPARTMENT_NAME
FROM EMPLOYEES e
JOIN DEPARTMENTS d
ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
JOIN LOCATIONS l
ON d.LOCATION_ID = l.LOCATION_ID
WHERE l.CITY = 'Toronto';

/*
  6. Visualice el apellido y el número del empleado junto con el apellido y el número de su director.
     Etiquete las columnas como Employee, Emp#, Manager y Mgr#, respectivamente. Coloque la sentencia SQL 
     en un archivo de texto llamado lab4_6.sql
*/
SELECT e.LAST_NAME Employee, e.EMPLOYEE_ID Emp#, m.LAST_NAME Manager, m.EMPLOYEE_ID Mgr#
FROM EMPLOYEES e
JOIN EMPLOYEES m
ON e.MANAGER_ID = m.EMPLOYEE_ID;

/*
  7. Modifique lab4_6.sql para visualizar a todos los empleados incluyendo a King, que no
     tiene director. Ordene los resultados por número de empleado. Coloque la sentencia SQL en un archivo de texto llamado
     lab4_7.sql. Ejecute la consulta en lab4_7.sql.
*/
SELECT e.LAST_NAME Employee, e.EMPLOYEE_ID Emp#, m.LAST_NAME Manager, m.EMPLOYEE_ID Mgr#
FROM EMPLOYEES e
LEFT JOIN EMPLOYEES m
ON e.MANAGER_ID = m.EMPLOYEE_ID
ORDER BY e.EMPLOYEE_ID;

/*
  8. Cree una consulta que muestre apellidos de empleado, números de departamento y todos los
     empleados que trabajan en el mismo departamento que un empleado dado. Asigne a cada
     columna la etiqueta adecuada
*/
SELECT e.DEPARTMENT_ID Department, e.LAST_NAME Employee, co.LAST_NAME Colleague
FROM EMPLOYEES co
CROSS JOIN EMPLOYEES e
WHERE e.department_id = co.department_id AND e.employee_id <> co.employee_id
ORDER BY 1 ASC;

/*
  9. Visualice la estructura de la tabla JOB_GRADES. Cree una consulta en la que pueda visualizar
     el nombre, el cargo, el nombre de departamento, el salario y el grado de todos los empleados.
*/
SELECT e.LAST_NAME, e.JOB_ID, d.DEPARTMENT_NAME, e.SALARY, decode(TO_CHAR(e.JOB_ID),
                                                                'AD_ASST', 'A',
                                                                'ST_MAN', 'B',
                                                                'PU_MAN', 'C',
                                                                'SA_REP', 'D',
                                                                'AD_VP', 'E',
                                                                '0') "Grades"
FROM JOB_HISTORY j
JOIN EMPLOYEES e USING (EMPLOYEE_ID)
JOIN DEPARTMENTS d ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
ORDER BY "Grades";

/*
  10. Cree una consulta para visualizar el apellido y la fecha de contratación de cualquier empleado
      contratado después del empleado Davies
*/
SELECT e.LAST_NAME, TO_CHAR(e.HIRE_DATE, 'DD-MON-YY') HIRE_DATE
FROM EMPLOYEES e
JOIN EMPLOYEES davies
ON e.HIRE_DATE > davies.HIRE_DATE
WHERE davies.LAST_NAME = 'Davies';

/*
  11. Visualice los nombres y las fechas de contratación de todos los empleados contratados antes
      que sus directores, junto con los nombres y las fechas de contratación de estos últimos. Etiquete
      las columnas como Employee, Emp Hired, Manager y MgrHired, respectivamente.
*/
SELECT e.LAST_NAME "Employee", TO_CHAR(e.HIRE_DATE, 'DD-MON-YY') "Emp Hired", m.LAST_NAME "Manager", TO_CHAR(m.HIRE_DATE, 'DD-MON-YY') "MgrHired"
FROM EMPLOYEES e
JOIN EMPLOYEES m
ON e.HIRE_DATE < m.HIRE_DATE
WHERE e.MANAGER_ID = m.EMPLOYEE_ID;

