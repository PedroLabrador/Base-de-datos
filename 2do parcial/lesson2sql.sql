describe employees;

select e.employee_id, e.last_name, e.job_id, e.hire_date from employees e ;

select (e.last_name || ',' || e.job_id) "Employee and Title" from employees e;

SELECT employee_id, last_name, job_id, department_id FROM   employees WHERE  department_id = 90;

SELECT last_name, salary from employees where salary between 2800 and 3000;

SELECT employee_id, last_name, manager_id FROM employees where manager_id in (103, 101, 102);

select last_name, job_id from employees where job_id like 'SA*_%' escape '*';

select last_name, hire_date, manager_id from employees where manager_id is not null;

select first_name, salary, job_id from employees where ((salary > 5000 and salary < 6000) or salary = 7900) and job_id like '%MAN%';

select last_name, phone_number from employees order by phone_number desc;

select last_name, hire_date from employees where extract(MONTH from hire_date) = 06 and extract(YEAR from hire_date) = 2002;

/* Practica 2 */

/*
  1. Cree una consulta para mostrar el apellido y el salario de los empleados que ganan más de
     $12.000. Coloque la sentencia SQL en un archivo de texto llamado lab2_1.sql. Ejecute la consulta
*/
select last_name, salary from employees where salary >= 12000;

/*
  2. Cree una consulta para mostrar el apellido del empleado y el número de departamento para el
     número de empleado 176.
*/
select last_name, department_id from employees where employee_id = 176;

/*
  3. Modifique lab2_1.sql para mostrar el apellido y el salario para todos los empleados cuyos
     salarios no están comprendidos entre $5.000 y $12.000. Coloque la sentencia SQL en un
     archivo de texto llamado lab2_3.sql.
*/
select last_name, salary from employees where salary not between 5000 and 12000;

/*
  4. Muestre el apellido del empleado, el identificador de cargo y la fecha de inicio de los
     empleados contratados entre el 20 de febrero de 1998 y el 1 de mayo de 1998. Ordene la
     consulta en orden ascendente por fecha de inicio.
*/
select last_name, job_id, hire_date from employees where hire_date between '07-02-04' and '17-06-04' order by hire_date asc;

/*
  5. Muestre el apellido y el número de departamento de todos los empleados de los departamentos
     20 y 50 en orden alfabético por apellido
*/
select last_name, department_id from employees where department_id in (20,50);

/*
  6. Modifique lab2_3.sql para enumerar el apellido y el salario de los empleados que ganan
     entre $5.000 y $12.000, y están en el departamento 20 ó 50. Etiquete las columnas Employee y Monthly
     Salary, respectivamente. Vuelva a guardar lab2_3.sql como lab2_6.sql. Ejecute la sentencia en lab2_6.sql.
*/
select e.last_name "Employee", e.salary "Monthly Salary", e.department_id "Department" from employees e where salary between 5000 and 12000 and department_id in(20,50);

/*
  7. Muestre el apellido y la fecha de contratación de todos los empleados contratados en 1994.
*/
select last_name, hire_date from employees where hire_date >= '01/01/02' and hire_date <= '31/12/02';
select last_name, hire_date from employees where hire_date between '01/01/02' and '31/12/02';

/*
  8. Muestre el apellido y el cargo de todos los empleados que no tienen director.
*/
select last_name, job_id from employees where manager_id is null;

/*
  9. Muestre el apellido, el salario y la comisión para todos los empleados que ganan comisiones.
     Ordene los datos en orden descendente de salarios y comisiones
*/
select last_name, salary, commission_pct from employees where commission_pct is not null order by salary desc;

/*
  10. Muestre el apellido de todos los empleados que tengan la a como tercera letra.
*/
select last_name from employees where last_name like '__a%' group by last_name;

/*
  11. Muestre el apellido de todos los empleados que tengan una a y una e en el apellido.
*/
select last_name from employees where last_name like '%a%' and last_name like '%e%';

/*
  12. Muestre el apellido, el cargo y el salario de todos los empleados cuyos cargos sean
      representantes de ventas o encargados de stock y cuyos salario no sean iguales a $2.500,
      $3.500 ni $7.000.
*/
select last_name, job_id, salary
from employees
where job_id = 'SA_REP' or job_id = 'ST_CLERK'
and (salary not in (3200,2700,2400));

/*
  13. Modifique lab2_6.sql para mostrar el apellido, el salario y la comisión para todos los
      empleados cuyas comisiones son el 20 %. Vuelva a guardar lab2_6.sql como lab2_13.sql. 
      Vuelva a ejecutar la sentencia en lab2_13.sql.
*/
select last_name, salary, commission_pct from employees where commission_pct is not null and commission_pct = .2 order by salary desc;