select employee_id, hire_date, 
  months_between(sysdate, hire_date), 
  add_months(hire_date, 6), 
  next_day(hire_date, 6), 
  last_day(hire_date)
from employees 
where months_between(sysdate, hire_date) < 140 ;

select round(sysdate, 'month'), trunc(sysdate, 'month') from dual;

select to_char(hire_date, 'J') from employees;

select to_char(sysdate, 'month fmDdspth "of" yyyy hh12:mi:ss am') from dual;

select to_char(salary, '$99,999.00') from employees;

select to_char(next_day(add_months(hire_date, 6), 6), 'Daydd "de" Month "de" YYYY')
FROM employees
ORDER BY hire_date;

SELECT last_name, job_id, salary,
       CASE job_id 
        WHEN 'IT_PROG'  THEN  1.10*salary
        WHEN 'ST_CLERK' THEN  1.15*salary
        WHEN 'SA_REP'   THEN  1.20*salary
       ELSE      salary 
       END     "REVISED_SALARY"
FROM   employees;

SELECT last_name, job_id, salary,
       DECODE(job_id, 'IT_PROG',  1.10*salary,
                      'ST_CLERK', 1.15*salary,
                      'SA_REP',   1.20*salary,
              salary)
       REVISED_SALARY
FROM   employees;

SELECT last_name, 
  salary,
  decode(trunc(salary/2000, 0),
    3, 0.32,
    4, 0.41,
    5, 0.42, 
    6, 0.44,
    0.48
    ) "TAX_RATE"
FROM employees
WHERE department_id = 80;

/* PRACTICA 3 */

/*
  1. Escriba una consulta para mostrar la fecha actual. Etiquete la columna como Date
*/
select sysdate "Date" from dual;

/*
  2. Para cada empleado, visualice su número, apellido, salario y salario incrementado en el 15 % y
     expresado como número entero. Etiquete la columna como New Salary. Ponga la sentencia
     SQL en un archivo de texto llamado lab3_2.sql.
  3. Ejecute la consulta en el archivo lab3_2.sql.
*/
select employee_id, last_name, salary, salary*1.15 "New Salary" from employees;

/*
  4. Modifique la consulta lab3_2.sql para agregar una columna que reste el salario antiguo
     del nuevo. Etiquete la columna como Increase. Guarde el contenido del archivo como
     lab3_4.sql. Ejecute la consulta revisada.
*/
select employee_id, last_name, salary, salary*1.15 "New Salary", (salary*1.15)- salary "Increase" from employees;

/*
  5. Escriba una consulta que muestre los apellidos de los empleados con la primera letra en
     mayúsculas y todas las demás en minúsculas, así como la longitud de los nombres, para todos
     los empleados cuyos nombres comienzan por J, A o M. Asigne a cada columna la etiqueta
     correspondiente. Ordene los resultados según los apellidos de los empleados
*/
select initcap(last_name), length(last_name) from employees order by last_name;

/*
  6. Para cada empleado, muestre su apellido y calcule el número de meses entre el día de hoy y la
     fecha de contratación. Etiquete la columna como MONTHS_WORKED. Ordene los resultados
     según el número de meses trabajados. Redondee el número de meses hacia arriba hasta el
     número entero más próximo
*/
select last_name, round(months_between(sysdate, hire_date)) "MONTHS WORKED" from employees order by 2;

/*
  7. Escriba una consulta que produzca lo siguiente para cada empleado:
     <employee last name> earns <salary> monthly but wants <3 timessalary>. Etiquete la columna como 
     Dream Salaries
*/
select 
  last_name ||
  ' earns ' || 
  to_char(salary, '$99,999.99') || 
  ' monthly but wants ' || 
  to_char(salary*3, '$99,999.99') 
  "DreamSalaries"
from employees;

/*
  8. Cree una consulta para mostrar el apellido y el salario de todos los empleados. Formatee el
     salario para que tenga 15 caracteres, rellenando a la izquierda con $. Etiquete la columna como
     SALARY
*/
select 
  last_name, 
  lpad(salary, 15, '$') Salary
from employees;

/*
  9. Muestre el apellido de cada empleado, así como la fecha de contratación y la fecha de revisión
     de salario, que es el primer lunes después de cada seis meses de servicio. Etiquete la columna
     REVIEW. Formatee las fechas para que aparezca en un formato similar a “Monday, the Thirty-First of July, 2000”
*/
select last_name, hire_date, to_char(next_day(add_months(hire_date, 6),2), 'Day Ddspth "of" Month YYYY') "Review"
from employees;

/*
  10. Muestre el apellido, la fecha de contratación y el día de la semana en el que comenzó el
      empleado. Etiquete la columna DAY. Ordene los resultados por día de la semana, comenzando
      por el lunes.
*/
select last_name, hire_date, to_char(hire_date, 'Day') "DAY"
from employees
order by to_char(hire_date-1, 'D');

/*
11.  Cree una consulta que muestre el apellido y las comisiones de los empleados. Si un empleado
no gana comisión, ponga “No Commission”. Etiquete la columna COMM.
*/
select last_name, nvl(to_char(commission_pct), 'No commision') COMM
from employees;

/*
  12. Cree una consulta que muestre el apellido de los empleados y que indique las cantidades de sus
      salarios anuales con asteriscos. Cada asterisco significa mil dólares. Ordene los datos por
      salario en orden descendente. Etiquete la columna EMPLOYEES_AND_THEIR_SALARIES
*/
select last_name || ' ' || LPAD(' ', SALARY/1000 + 1, '*') "EMPLOYEES_AND_THEIR_SALARIES" from employees order by salary desc;

/*
13. Utilizando la función DECODE, escriba una consulta que muestre el grado de todos los empleados
basándose en el valor de la columna JOB_ID, según los datos siguientes: Cargo   Grado 
                                                                        AD_PRES   A
                                                                        ST_MAN    B
                                                                        IT_PROG   C
                                                                        SA_REP    D
                                                                        ST_CLERK  E
                                                      Ninguno de los anteriores   0
*/

select job_id, decode(to_char(job_id),
                      'AD_PRES', 'A',
                      'ST_MAN', 'B',
                      'IT_PROG', 'C',
                      'SA_REP', 'D',
                      'ST_CLERK', 'E',
                      '0') "Grades"
from employees
order by "Grades";

/*
  14. Vuelva a escribir la sentencia de la pregunta anterior utilizando la sintaxis CASE
*/
select job_id, case job_id
                when 'AD_PRES' then 'A'
                when 'ST_MAN' then 'B'
                when'IT_PROG' then 'C'
                when 'SA_REP' then 'D'
                when 'ST_CLERK' then 'E'
               else '0' 
               end "Grades"
from employees
order by "Grades"
