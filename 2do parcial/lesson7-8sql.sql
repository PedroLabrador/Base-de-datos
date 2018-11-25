/* 
    NO TENGO INTERNET Y NO SE COMO COÑO HACER LOS ARCHIVOS DE COMANDOS ASI QUE TODO LO HICE MANUAL Y FEO 
*/

/*
  1. Ejecute la sentencia en el archivo de comandos lab8_1.sql para crear la tabla MY_EMPLOYEE
     que se utilizará para la práctica.
*/
CREATE TABLE my_employee (id NUMBER(4) NOT NULL, last_name VARCHAR(25), first_name VARCHAR(25), userid VARCHAR(8), salary NUMBER(9,2));

/*
  2. Describa la estructura de la tabla MY_EMPLOYEE para identificar los nombres de columna.
*/
DESCRIBE my_employee;

/*
  3. Agregue la primera fila de datos a la tabla MY_EMPLOYEE desde los siguientes datos de ejemplo.
     No enumere las columnas en la cláusula INSERT.
*/
INSERT INTO my_employee VALUES(1,'Patel', 'Ralph', 'rpatel', 895);

/*
  4. Rellene la tabla MY_EMPLOYEE con la segunda fila de los datos de ejemplo de la lista anterior.
     Esta vez, enumere las columnas explícitamente en la cláusula INSERT.describe
*/
INSERT INTO my_employee VALUES(2, 'Dancs', 'Betty', 'bdancs', 860);

/*
  5. Confirme la adición a la tabla
*/
SELECT * FROM my_employee;

/*
  6. Escriba una sentencia INSERT en un archivo de texto llamado loademp.sql para cargar
     filas en la tabla MY_EMPLOYEE. Concatene la primera letra del nombre con los primeros siete
     caracteres del apellido para crear el identificador de usuario.
*/
INSERT INTO my_employee VALUES(3, 'Biri', 'Ben', lower(substr('Ben', 1, 1) || substr('Biri', 1,7)), 1100);

/*
  7. Rellene la tabla con las dos filas siguientes de los datos de ejemplo ejecutando la sentencia
     INSERT en el archivo de comandos que ha creado.
*/
INSERT INTO my_employee VALUES(4, 'Newman', 'Chad', lower(substr('Chad', 1, 1) || substr('Newman', 1,7)), 750);

/*
  8. Confirme las adiciones a la tabla
*/
SELECT * FROM my_employee;

/*
  9. Haga que las adiciones de datos sean permanentes
  Actualice y suprima datos en la tabla MY_EMPLOYEE.
*/
COMMIT;

/*
  10. Cambie el apellido del empleado 3 por Drexler
*/
UPDATE my_employee SET last_name = 'Drexler' WHERE id = 3;

/*
  11. Cambie el salario a 1000 para todos los empleados con un salario inferior a 900.
*/
UPDATE my_employee SET salary = 1000 WHERE salary < 900;

/*
  12. Verifique los cambios realizados a la tabla
*/
SELECT * FROM my_employee;

/*
  13. Suprima a Betty Dancs de la tabla MY_EMPLOYEE
*/
DELETE FROM my_employee WHERE first_name = 'Betty';

/*
  14. Confirme los cambios realizados a la tabla
*/
SELECT * FROM my_employee;

/*
  15. Valide todos los cambios pendientes.
*/
COMMIT;

/*
  16. Rellene la tabla con la última fila de los datos de ejemplo modificando las sentencias del archivo
      de comandos que creó en el paso 6. Ejecute las sentencias en el archivo de comandos.
*/
INSERT INTO my_employee VALUES(5, 'Ropeburn', 'Audrey', lower(substr('Audrey', 1, 1) || substr('Ropeburn', 1,7)), 1550);

/*
  17. Confirme la adición a la tabla
*/
SELECT * FROM my_employee;

/*
  18. Marque un punto intermedio en el procesamiento de la transacción.
*/
SAVEPOINT Test;

/*
  19. Vacíe toda la tabla.
*/
DELETE FROM my_employee;

/*
  20. Confirme que la tabla está vacía
*/
SELECT * FROM my_employee;

/*
  21. Deseche la operación DELETE más reciente sin desechar la operación INSERT anterior.
*/
ROLLBACK TO Test;

/*
  22. Confirme que la nueva fila sigue intacta.
*/
SELECT * FROM my_employee;

/*
  23. Haga que la adición de datos sea permanente.
*/
COMMIT;
