SET SERVEROUTPUT ON;
/*
  1. Elabore una función que para dada una fecha de inicio y de fin determinar
     cuantos días hábiles hay(es decir que no sean fines de semana).
*/
CREATE OR REPLACE FUNCTION COUNT_BUSINESS_DAYS
    (T_BEG_DATE IN DATE,
     T_END_DATE IN DATE) 
  RETURN NUMBER 
IS
  V_DAYS NUMBER;
BEGIN
  SELECT COUNT(*) 
  INTO V_DAYS
  FROM (SELECT ROWNUM - 1 D
      FROM (SELECT 1 FROM DUAL CONNECT BY LEVEL <= FLOOR(T_END_DATE - T_BEG_DATE) + 1))
  WHERE TO_CHAR(T_END_DATE + D, 'D') NOT IN (7,1);
  RETURN V_DAYS;
END COUNT_BUSINESS_DAYS;
/

DROP FUNCTION COUNT_BUSINESS_DAYS;

/*
  2. Elabore un procedimiento que me muestre para los días de un mes dado por
     parámetro (el mes y el año) lo siguiente.
     o Dia 1-11-2018 es jueves es el dia 305 del año y faltan 60 dias para
       terminar el año
     o Dia 2-11-2018 es viernes es el dia 306 del año y faltan 59 dias para
       terminar el año
     o ...
     o Dia 30-11-2018 es viernes es el dia 334 del año y faltan 31 dias para
       terminar el año
*/
CREATE OR REPLACE PROCEDURE SHOW_DAYS
  (T_MONTH IN VARCHAR2,
   T_YEAR IN VARCHAR2) 
IS
  CURSOR CUR_YEAR IS 
    SELECT TO_DATE(LEVEL||'-'||T_MONTH||'-'||T_YEAR) "DATE", 
           TO_CHAR(TO_DATE(LEVEL||'-'||T_MONTH||'-'||T_YEAR), 'Day') "DAY", 
           TO_NUMBER(TO_CHAR(TO_DATE(LEVEL||'-'||T_MONTH||'-'||T_YEAR), 'DDD')) "YEAR_DAY"
    FROM DUAL CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE('01-'||T_MONTH||'-'||T_YEAR)), 'DD');
  V_LAP_YEAR VARCHAR2(30);
  V_YEAR NUMBER;
BEGIN
  SELECT TO_CHAR(LAST_DAY(TO_DATE('01-FEB-'||TO_CHAR(T_YEAR), 'DD-MON-YYYY')), 'DD') INTO V_LAP_YEAR FROM DUAL;
  
  IF V_LAP_YEAR = '29' THEN V_YEAR := 366;
  ELSE V_YEAR := 365; END IF;
  
  FOR DAYS IN CUR_YEAR LOOP
    DBMS_OUTPUT.PUT_LINE(
      'Dia ' || DAYS."DATE" || ' es ' || DAYS."DAY" ||
      ' es el dia '|| DAYS."YEAR_DAY" || ' del año y faltan ' || (V_YEAR - DAYS."YEAR_DAY") || 
      ' dias para terminar el año'
    );
  END LOOP;
END SHOW_DAYS;
/

DROP PROCEDURE SHOW_DAYS;

/*
  3. Elabore un disparador que permita lo siguente en la tabla employees del
     esquema HR.
     o Validar que el salario que le corresponde por su JOB_ID este entre el
       min y máximo en la tabla JOBS al insertar o modificar un salario.
       o Si la fecha de contratación es fin de semana, colocar la fecha de
       contratación el lunes más cercano.
     o No permitir eliminar un registro.
     o El manager_ID debe ser manager_Id que le corresponde por la tabla
       Departments.
*/
CREATE OR REPLACE TRIGGER EMPLOYEE_VALIDATE
BEFORE INSERT OR DELETE OR UPDATE ON EMPLOYEES FOR EACH ROW
DECLARE 
  V_COUNTER INTEGER;
  V_MIN_SALARY JOBS.MIN_SALARY%TYPE;
  V_MAX_SALARY JOBS.MAX_SALARY%TYPE;
  
  V_MANAGER_ID DEPARTMENTS.MANAGER_ID%TYPE;
BEGIN
  IF INSERTING OR UPDATING THEN
    SELECT COUNT(*) INTO V_COUNTER FROM JOBS WHERE JOB_ID = :NEW.JOB_ID;
    
    IF V_COUNTER > 0 THEN
      SELECT MIN_SALARY, MAX_SALARY INTO V_MIN_SALARY, V_MAX_SALARY FROM JOBS WHERE JOB_ID = :NEW.JOB_ID;
      
      IF :NEW.SALARY >= V_MIN_SALARY AND :NEW.SALARY <= V_MAX_SALARY THEN
        DBMS_OUTPUT.PUT_LINE('Salario valido');
      ELSE
        RAISE_APPLICATION_ERROR(-20202, 'El salario ingresado no está en el rango del salario establecido para su JOB_ID.');
      END IF;
    ELSE 
      RAISE_APPLICATION_ERROR(-20252, 'No existe ese JOB_ID.');
    END IF;
    
    SELECT MANAGER_ID INTO V_MANAGER_ID FROM DEPARTMENTS WHERE DEPARTMENT_ID = :NEW.DEPARTMENT_ID ;
    
    IF V_MANAGER_ID = :NEW.MANAGER_ID THEN
      DBMS_OUTPUT.PUT_LINE('Manager_id correcto.');
    ELSE
      :NEW.MANAGER_ID := V_MANAGER_ID;
      DBMS_OUTPUT.PUT_LINE('Manager_id corregido.');
    END IF;
    
    IF TO_CHAR(:NEW.HIRE_DATE, 'D') = 7 THEN
      :NEW.HIRE_DATE := :NEW.HIRE_DATE + 2;
    ELSIF TO_CHAR(:NEW.HIRE_DATE, 'D') = 1 THEN
      :NEW.HIRE_DATE := :NEW.HIRE_DATE + 1;
    END IF;
    
  ELSIF DELETING THEN
    RAISE_APPLICATION_ERROR(-20272, 'No es posible eliminar usuarios de la tabla employees.');
  END IF;
END;
/

DROP TRIGGER EMPLOYEE_VALIDATE;