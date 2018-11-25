SELECT o."Año/Mes", t.modelo, t.pieza, o.cant
FROM (SELECT "Año/Mes", MAX(cantidad) cant
      FROM (SELECT TO_CHAR(reparaciones.fecha_r, 'YYYY')||'/'||TO_CHAR(reparaciones.fecha_r, 'MON') "Año/Mes",
                   modelos.descr   modelo,
                   piezas.nombre   pieza,
                   COUNT(piezas.nombre) cantidad
            FROM reparaciones
            INNER JOIN detalle_reparaciones ON detalle_reparaciones.rpo_cod = reparaciones.cod
            INNER JOIN piezas ON piezas.cod = detalle_reparaciones.dpa_pza_cod
            INNER JOIN vehiculos ON vehiculos.serial = reparaciones.vho_serial
            INNER JOIN modelos ON modelos.cod = vehiculos.mdo_cod
            GROUP BY TO_CHAR(reparaciones.fecha_r, 'YYYY')||'/'||TO_CHAR(reparaciones.fecha_r, 'MON'),
                     modelos.descr,
                     piezas.nombre
            ORDER BY 1 DESC)
      GROUP BY "Año/Mes") o
RIGHT JOIN (SELECT TO_CHAR(reparaciones.fecha_r, 'YYYY')||'/'||TO_CHAR(reparaciones.fecha_r, 'MON') "Año/Mes",
                   modelos.descr   modelo,
                   piezas.nombre   pieza,
                   COUNT(piezas.nombre) cantidad
            FROM reparaciones
            INNER JOIN detalle_reparaciones ON detalle_reparaciones.rpo_cod = reparaciones.cod
            INNER JOIN piezas ON piezas.cod = detalle_reparaciones.dpa_pza_cod
            INNER JOIN vehiculos ON vehiculos.serial = reparaciones.vho_serial
            INNER JOIN modelos ON modelos.cod = vehiculos.mdo_cod
            GROUP BY TO_CHAR(reparaciones.fecha_r, 'YYYY')||'/'||TO_CHAR(reparaciones.fecha_r, 'MON'),
                     modelos.descr,
                     piezas.nombre
            ORDER BY 1 DESC) t ON o."Año/Mes" = t."Año/Mes" AND o.cant = t.cantidad
GROUP BY o."Año/Mes", t.modelo, t.pieza, o.cant
having count(distinct o."Año/Mes") = 1;


create or replace FUNCTION vhc_amount_cost 
  (t_anno in NUMBER,
   t_serial in vehiculos.serial%TYPE)
   RETURN float 
IS
    v_amount float := 0;
BEGIN
    SELECT
        SUM(detalle_piezas.costo)
    INTO v_amount
    FROM reparaciones
    INNER JOIN detalle_reparaciones ON reparaciones.cod = detalle_reparaciones.rpo_cod
    INNER JOIN detalle_piezas ON detalle_piezas.pza_cod = detalle_reparaciones.dpa_pza_cod
    INNER JOIN mantenimiento_correctivos ON mantenimiento_correctivos.id = detalle_piezas.mco_id
    INNER JOIN vehiculos ON vehiculos.serial = reparaciones.vho_serial
    WHERE to_number(TO_CHAR(reparaciones.fecha_r, 'YYYY')) > t_anno AND vehiculos.serial = t_serial;
    
    RETURN amount;
END vhc_amount_cost;
/

drop function vhc_amount_cost;

create or replace FUNCTION vhc_count 
  (t_anno IN NUMBER, 
   t_serial IN vehiculos.serial%TYPE) 
  RETURN NUMBER 
IS
    amount detalle_piezas.costo%TYPE := 0;
BEGIN
    SELECT
        count(detalle_piezas.pza_cod)
    INTO amount
    FROM reparaciones
    INNER JOIN detalle_reparaciones ON reparaciones.cod = detalle_reparaciones.rpo_cod
    INNER JOIN detalle_piezas ON detalle_piezas.pza_cod = detalle_reparaciones.dpa_pza_cod
    INNER JOIN mantenimiento_correctivos ON mantenimiento_correctivos.id = detalle_piezas.mco_id
    INNER JOIN vehiculos ON vehiculos.serial = reparaciones.vho_serial
    WHERE to_number(TO_CHAR(reparaciones.fecha_r, 'YYYY')) > t_anno AND vehiculos.serial = t_serial;
    
    RETURN amount;
END vhc_count;
/



select vhc_amount_cost('2013', 159464474333) from dual;

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE rel_veh
  (T_MONTH IN VARCHAR2,
   T_YEAR IN NUMBER)
IS
  CURSOR CUR_VEH IS (SELECT * FROM REPARACIONES RPO
                     JOIN DETALLE_REPARACIONES DRO ON RPO.COD = DRO.RPO_COD
                     JOIN MANTENIMIENTO_PLANIFICADOS MPO ON DRO.MPO_ID = MPO.ID AND DRO.DPA_MCO_ID IS NULL AND DRO.DPA_PZA_COD IS NULL
                     JOIN VEHICULOS VHO ON VHO.SERIAL = RPO.VHO_SERIAL
                     
                     WHERE RPO.KM > MPO.KM_FREC AND TO_CHAR(RPO.FECHA_R, 'YYYY') = T_YEAR AND TO_CHAR(RPO.FECHA_R, 'Mon') = T_MONTH);
BEGIN
  FOR VEH_ACT IN CUR_VEH LOOP
    DBMS_OUTPUT.PUT_LINE('Cant. Mantenimientos: ' || VHC_COUNT(TO_CHAR(VEH_ACT.FECHA_SAL, 'YYYY'), VEH_ACT.VHO_SERIAL) || ' Costo Total: ' || VHC_AMOUNT_COST(TO_CHAR(VEH_ACT.FECHA_SAL, 'YYYY'), VEH_ACT.VHO_SERIAL));
  END LOOP;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No data found');
END;
/

EXECUTE rel_veh('Nov', 2012);