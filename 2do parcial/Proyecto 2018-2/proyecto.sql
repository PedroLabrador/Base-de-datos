/*
    Integrantes:
    Pedro Labrador
    Kevin Cortes
    Armando Ortuño
*/

-- CREATE, 

CREATE TABLE atendedores (
    citas_id       INTEGER NOT NULL,
    empleados_id   INTEGER NOT NULL
);

CREATE TABLE cargos (
    id           INTEGER NOT NULL,
    area         VARCHAR2(32) NOT NULL,
    tipo_cargo   VARCHAR2(64) NOT NULL,
    seguro       CHAR(1),
    bono         CHAR(1)
);

ALTER TABLE cargos ADD CONSTRAINT cargos_pk PRIMARY KEY ( id,
area );

ALTER TABLE cargos ADD CONSTRAINT cargos__un UNIQUE ( tipo_cargo );

CREATE TABLE citas (
    id      INTEGER NOT NULL,
    fecha   DATE NOT NULL
);

ALTER TABLE citas ADD CONSTRAINT citas_pk PRIMARY KEY ( id );

CREATE TABLE clientes (
    registros_id   INTEGER NOT NULL,
    personas_id    INTEGER NOT NULL
);

CREATE TABLE empleados (
    id                  INTEGER NOT NULL,
    servicios_id        INTEGER NOT NULL,
    cargos_id           INTEGER NOT NULL,
    cargos_area         VARCHAR2(32) NOT NULL,
    especialidades_id   INTEGER NOT NULL,
    personas_id         INTEGER NOT NULL,
    sueldo              FLOAT(32)
);

ALTER TABLE empleados ADD CONSTRAINT empleados_pk PRIMARY KEY ( id );

CREATE TABLE especialidades (
    id                  INTEGER NOT NULL,
    tipo_especialidad   VARCHAR2(128) NOT NULL
);

ALTER TABLE especialidades ADD CONSTRAINT especialidades_pk PRIMARY KEY ( id );

ALTER TABLE especialidades ADD CONSTRAINT especialidades__un UNIQUE ( tipo_especialidad );

CREATE TABLE familiares (
    id                 INTEGER NOT NULL,
    fecha_afiliacion   DATE NOT NULL,
    puntos             INTEGER
);

ALTER TABLE familiares ADD CONSTRAINT familiares_pk PRIMARY KEY ( id );

CREATE TABLE horarios (
    id             INTEGER NOT NULL,
    dias           INTEGER NOT NULL,
    hora_entrada   DATE,
    hora_salida    DATE
);

ALTER TABLE horarios ADD CONSTRAINT horarios_pk PRIMARY KEY ( id );

CREATE TABLE pacientes (
    citas_id      INTEGER NOT NULL,
    personas_id   INTEGER NOT NULL
);

CREATE TABLE personal (
    registros_id   INTEGER NOT NULL,
    empleados_id   INTEGER NOT NULL
);

CREATE TABLE personas (
    id                 INTEGER NOT NULL,
    correo             VARCHAR2(256) NOT NULL,
    familiares_id      INTEGER NOT NULL,
    nombre             VARCHAR2(128) NOT NULL,
    apellido           VARCHAR2(128) NOT NULL,
    fecha_nacimiento   DATE NOT NULL,
    telefono           VARCHAR2(128),
    genero             VARCHAR2(32) NOT NULL,
    direccion          VARCHAR2(128) NOT NULL,
    tipo_sangre        VARCHAR2(32) NOT NULL
);

ALTER TABLE personas ADD CONSTRAINT persona_pk PRIMARY KEY ( id );

ALTER TABLE personas ADD CONSTRAINT personas__un UNIQUE ( correo );

CREATE TABLE registros (
    id        INTEGER NOT NULL,
    motivo    VARCHAR2(128) NOT NULL,
    costo     FLOAT(32) NOT NULL,
    fecha     DATE NOT NULL,
    detalle   VARCHAR2(128)
);

ALTER TABLE registros ADD CONSTRAINT registros_pk PRIMARY KEY ( id );

CREATE TABLE servicios (
    id           INTEGER NOT NULL,
    nombre       VARCHAR2(128) NOT NULL,
    telefono     VARCHAR2(128) NOT NULL,
    tipo         VARCHAR2(64) NOT NULL,
    porcentaje   FLOAT(16) NOT NULL
);

ALTER TABLE servicios ADD CONSTRAINT servicios_pk PRIMARY KEY ( id );

ALTER TABLE servicios ADD CONSTRAINT servicios__un UNIQUE ( nombre );

CREATE TABLE servicios_citas (
    citas_id       INTEGER NOT NULL,
    servicios_id   INTEGER NOT NULL
);

CREATE TABLE servicios_registros (
    registros_id   INTEGER NOT NULL,
    servicios_id   INTEGER NOT NULL
);

CREATE TABLE subservicios (
    id             INTEGER NOT NULL,
    servicios_id   INTEGER NOT NULL,
    tipo           VARCHAR2(32) NOT NULL,
    nombre         VARCHAR2(64) NOT NULL,
    precio         FLOAT(32) NOT NULL
);

ALTER TABLE subservicios ADD CONSTRAINT subservicios_pk PRIMARY KEY ( id );

CREATE TABLE turnos (
    empleados_id   INTEGER NOT NULL,
    horarios_id    INTEGER NOT NULL,
    zona           VARCHAR2(32)
);

ALTER TABLE atendedores
    ADD CONSTRAINT atendedores_citas_fk FOREIGN KEY ( citas_id )
        REFERENCES citas ( id );

ALTER TABLE atendedores
    ADD CONSTRAINT atendedores_empleados_fk FOREIGN KEY ( empleados_id )
        REFERENCES empleados ( id );

ALTER TABLE servicios_citas
    ADD CONSTRAINT citas_servicios_fk FOREIGN KEY ( servicios_id )
        REFERENCES servicios ( id );

ALTER TABLE clientes
    ADD CONSTRAINT clientes_personas_fk FOREIGN KEY ( personas_id )
        REFERENCES personas ( id );

ALTER TABLE clientes
    ADD CONSTRAINT clientes_registros_fk FOREIGN KEY ( registros_id )
        REFERENCES registros ( id );

ALTER TABLE empleados
    ADD CONSTRAINT empleados_cargos_fk FOREIGN KEY ( cargos_id,
    cargos_area )
        REFERENCES cargos ( id,
        area );

ALTER TABLE empleados
    ADD CONSTRAINT empleados_especialidades_fk FOREIGN KEY ( especialidades_id )
        REFERENCES especialidades ( id );

ALTER TABLE empleados
    ADD CONSTRAINT empleados_personas_fk FOREIGN KEY ( personas_id )
        REFERENCES personas ( id );

ALTER TABLE empleados
    ADD CONSTRAINT empleados_servicios_fk FOREIGN KEY ( servicios_id )
        REFERENCES servicios ( id );

ALTER TABLE pacientes
    ADD CONSTRAINT pacientes_citas_fk FOREIGN KEY ( citas_id )
        REFERENCES citas ( id );

ALTER TABLE pacientes
    ADD CONSTRAINT pacientes_personas_fk FOREIGN KEY ( personas_id )
        REFERENCES personas ( id );

ALTER TABLE personal
    ADD CONSTRAINT personal_empleados_fk FOREIGN KEY ( empleados_id )
        REFERENCES empleados ( id );

ALTER TABLE personal
    ADD CONSTRAINT personal_registros_fk FOREIGN KEY ( registros_id )
        REFERENCES registros ( id );

ALTER TABLE personas
    ADD CONSTRAINT personas_familiares_fk FOREIGN KEY ( familiares_id )
        REFERENCES familiares ( id );

ALTER TABLE servicios_registros
    ADD CONSTRAINT registros_servicios_fk FOREIGN KEY ( servicios_id )
        REFERENCES servicios ( id );

ALTER TABLE servicios_citas
    ADD CONSTRAINT servicios_citas_fk FOREIGN KEY ( citas_id )
        REFERENCES citas ( id );

ALTER TABLE servicios_registros
    ADD CONSTRAINT servicios_registros_fk FOREIGN KEY ( registros_id )
        REFERENCES registros ( id );

ALTER TABLE subservicios
    ADD CONSTRAINT subservicios_servicios_fk FOREIGN KEY ( servicios_id )
        REFERENCES servicios ( id );

ALTER TABLE turnos
    ADD CONSTRAINT turnos_empleados_fk FOREIGN KEY ( empleados_id )
        REFERENCES empleados ( id );

ALTER TABLE turnos
    ADD CONSTRAINT turnos_horarios_fk FOREIGN KEY ( horarios_id )
        REFERENCES horarios ( id );

CREATE SEQUENCE cargos_id_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER cargos_id_trg BEFORE
    INSERT ON cargos
    FOR EACH ROW
    WHEN ( new.id IS NULL )
BEGIN
    :new.id := cargos_id_seq.nextval;
END;
/

CREATE SEQUENCE citas_id_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER citas_id_trg BEFORE
    INSERT ON citas
    FOR EACH ROW
    WHEN ( new.id IS NULL )
BEGIN
    :new.id := citas_id_seq.nextval;
END;
/

CREATE SEQUENCE empleados_id_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER empleados_id_trg BEFORE
    INSERT ON empleados
    FOR EACH ROW
    WHEN ( new.id IS NULL )
BEGIN
    :new.id := empleados_id_seq.nextval;
END;
/

CREATE SEQUENCE especialidades_id_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER especialidades_id_trg BEFORE
    INSERT ON especialidades
    FOR EACH ROW
    WHEN ( new.id IS NULL )
BEGIN
    :new.id := especialidades_id_seq.nextval;
END;
/

CREATE SEQUENCE familiares_id_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER familiares_id_trg BEFORE
    INSERT ON familiares
    FOR EACH ROW
    WHEN ( new.id IS NULL )
BEGIN
    :new.id := familiares_id_seq.nextval;
END;
/

CREATE SEQUENCE horarios_id_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER horarios_id_trg BEFORE
    INSERT ON horarios
    FOR EACH ROW
    WHEN ( new.id IS NULL )
BEGIN
    :new.id := horarios_id_seq.nextval;
END;
/

CREATE SEQUENCE personas_id_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER personas_id_trg BEFORE
    INSERT ON personas
    FOR EACH ROW
    WHEN ( new.id IS NULL )
BEGIN
    :new.id := personas_id_seq.nextval;
END;
/

CREATE SEQUENCE registros_id_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER registros_id_trg BEFORE
    INSERT ON registros
    FOR EACH ROW
    WHEN ( new.id IS NULL )
BEGIN
    :new.id := registros_id_seq.nextval;
END;
/

CREATE SEQUENCE servicios_id_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER servicios_id_trg BEFORE
    INSERT ON servicios
    FOR EACH ROW
    WHEN ( new.id IS NULL )
BEGIN
    :new.id := servicios_id_seq.nextval;
END;
/

CREATE SEQUENCE subservicios_id_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER subservicios_id_trg BEFORE
    INSERT ON subservicios
    FOR EACH ROW
    WHEN ( new.id IS NULL )
BEGIN
    :new.id := subservicios_id_seq.nextval;
END;
/

-- INSERTS

INSERT INTO SERVICIOS (ID, NOMBRE, TELEFONO, TIPO, PORCENTAJE) VALUES (1, 'Hospitalizacion', '+0(000)00-000', 'Tipo 1', 5.25);
INSERT INTO SERVICIOS (ID, NOMBRE, TELEFONO, TIPO, PORCENTAJE) VALUES (2, 'Farmacia', '+0(000)00-000', 'Tipo 2', 6.67);
INSERT INTO SERVICIOS (ID, NOMBRE, TELEFONO, TIPO, PORCENTAJE) VALUES (3, 'Cirugia', '+0(000)00-000', 'Tipo 3', 3.28);
INSERT INTO SERVICIOS (ID, NOMBRE, TELEFONO, TIPO, PORCENTAJE) VALUES (4, 'Tratamiento', '+0(000)00-000', 'Tipo 4', 4.44);
INSERT INTO SERVICIOS (ID, NOMBRE, TELEFONO, TIPO, PORCENTAJE) VALUES (5, 'Quimioterapia', '+0(000)00-000', 'Tipo 5', 3.21);
INSERT INTO SERVICIOS (ID, NOMBRE, TELEFONO, TIPO, PORCENTAJE) VALUES (6, 'Psiquiatria', '+0(000)00-000', 'Tipo 6', 3.84);
INSERT INTO SERVICIOS (ID, NOMBRE, TELEFONO, TIPO, PORCENTAJE) VALUES (7, 'Emergencias', '+0(000)00-000', 'Tipo 7', 9.25);
INSERT INTO SERVICIOS (ID, NOMBRE, TELEFONO, TIPO, PORCENTAJE) VALUES (8, 'Medicina General', '+0(000)00-000', 'Tipo 8', 0.25);
INSERT INTO SERVICIOS (ID, NOMBRE, TELEFONO, TIPO, PORCENTAJE) VALUES (9, 'Neurología', '+0(000)00-000', 'Tipo 9', 12.25);
INSERT INTO SERVICIOS (ID, NOMBRE, TELEFONO, TIPO, PORCENTAJE) VALUES (10, 'Rehabilitaciín', '+0(000)00-000', 'Tipo 10', 12.25);
INSERT INTO SERVICIOS (ID, NOMBRE, TELEFONO, TIPO, PORCENTAJE) VALUES (11, 'Urología', '+0(000)00-000', 'Tipo 11', 3.25);
INSERT INTO SERVICIOS (ID, NOMBRE, TELEFONO, TIPO, PORCENTAJE) VALUES (12, 'Oftalmología', '+0(000)00-000', 'Tipo 12', 3.45);
INSERT INTO SERVICIOS (ID, NOMBRE, TELEFONO, TIPO, PORCENTAJE) VALUES (13, 'Ginecología', '+0(000)00-000', 'Tipo 13', 3.75);
INSERT INTO SERVICIOS (ID, NOMBRE, TELEFONO, TIPO, PORCENTAJE) VALUES (14, 'Cardiología', '+0(000)00-000', 'Tipo 14', 9.88);
INSERT INTO SERVICIOS (ID, NOMBRE, TELEFONO, TIPO, PORCENTAJE) VALUES (15, 'Dermatología', '+0(000)00-000', 'Tipo 15', 8.77);
INSERT INTO SERVICIOS (ID, NOMBRE, TELEFONO, TIPO, PORCENTAJE) VALUES (16, 'Nutrición', '+0(000)00-000', 'Tipo 16', 4.24);
INSERT INTO SERVICIOS (ID, NOMBRE, TELEFONO, TIPO, PORCENTAJE) VALUES (17, 'Neumología', '+0(000)00-000', 'Tipo 17', 7.47);
INSERT INTO SERVICIOS (ID, NOMBRE, TELEFONO, TIPO, PORCENTAJE) VALUES (18, 'Otorrinolaringología', '+0(000)00-000', 'Tipo 18', 6.66);
INSERT INTO SERVICIOS (ID, NOMBRE, TELEFONO, TIPO, PORCENTAJE) VALUES (19, 'Microbiología', '+0(000)00-000', 'Tipo 19', 3.46);
INSERT INTO SERVICIOS (ID, NOMBRE, TELEFONO, TIPO, PORCENTAJE) VALUES (20, 'Reumatología', '+0(000)00-000', 'Tipo 20', 6.54);
INSERT INTO SERVICIOS (ID, NOMBRE, TELEFONO, TIPO, PORCENTAJE) VALUES (99, 'wao', '0000', 'wao', 100);
INSERT INTO SUBSERVICIOS (ID, SERVICIOS_ID, TIPO, NOMBRE, PRECIO) VALUES (1, '1', 'Subtipo 1', 'Subservicio 1', '1000');
INSERT INTO SUBSERVICIOS (ID, SERVICIOS_ID, TIPO, NOMBRE, PRECIO) VALUES (2, '1', 'Subtipo 1', 'Subservicio 1', '1000');
INSERT INTO SUBSERVICIOS (ID, SERVICIOS_ID, TIPO, NOMBRE, PRECIO) VALUES (3, '1', 'Subtipo 1', 'Subservicio 1', '1000');
INSERT INTO SUBSERVICIOS (ID, SERVICIOS_ID, TIPO, NOMBRE, PRECIO) VALUES (4, '1', 'Subtipo 1', 'Subservicio 1', '1000');
INSERT INTO SUBSERVICIOS (ID, SERVICIOS_ID, TIPO, NOMBRE, PRECIO) VALUES (5, '1', 'Subtipo 1', 'Subservicio 1', '1000');
INSERT INTO SUBSERVICIOS (ID, SERVICIOS_ID, TIPO, NOMBRE, PRECIO) VALUES (6, '2', 'Subtipo 2', 'Subservicio 2', '1000');
INSERT INTO SUBSERVICIOS (ID, SERVICIOS_ID, TIPO, NOMBRE, PRECIO) VALUES (7, '2', 'Subtipo 2', 'Subservicio 2', '1000');
INSERT INTO SUBSERVICIOS (ID, SERVICIOS_ID, TIPO, NOMBRE, PRECIO) VALUES (8, '2', 'Subtipo 2', 'Subservicio 2', '1000');
INSERT INTO SUBSERVICIOS (ID, SERVICIOS_ID, TIPO, NOMBRE, PRECIO) VALUES (9, '2', 'Subtipo 2', 'Subservicio 2', '1000');
INSERT INTO SUBSERVICIOS (ID, SERVICIOS_ID, TIPO, NOMBRE, PRECIO) VALUES (10, '2', 'Subtipo 2', 'Subservicio 2', '1000');
INSERT INTO SUBSERVICIOS (ID, SERVICIOS_ID, TIPO, NOMBRE, PRECIO) VALUES (11, '3', 'Subtipo 3', 'Subservicio 3', '1000');
INSERT INTO SUBSERVICIOS (ID, SERVICIOS_ID, TIPO, NOMBRE, PRECIO) VALUES (12, '3', 'Subtipo 3', 'Subservicio 3', '1000');
INSERT INTO SUBSERVICIOS (ID, SERVICIOS_ID, TIPO, NOMBRE, PRECIO) VALUES (13, '3', 'Subtipo 3', 'Subservicio 3', '1000');
INSERT INTO SUBSERVICIOS (ID, SERVICIOS_ID, TIPO, NOMBRE, PRECIO) VALUES (14, '3', 'Subtipo 3', 'Subservicio 3', '1000');
INSERT INTO SUBSERVICIOS (ID, SERVICIOS_ID, TIPO, NOMBRE, PRECIO) VALUES (15, '3', 'Subtipo 3', 'Subservicio 3', '1000');
INSERT INTO SUBSERVICIOS (ID, SERVICIOS_ID, TIPO, NOMBRE, PRECIO) VALUES (16, '4', 'Subtipo 4', 'Subservicio 4', '1000');
INSERT INTO SUBSERVICIOS (ID, SERVICIOS_ID, TIPO, NOMBRE, PRECIO) VALUES (17, '4', 'Subtipo 4', 'Subservicio 4', '1000');
INSERT INTO SUBSERVICIOS (ID, SERVICIOS_ID, TIPO, NOMBRE, PRECIO) VALUES (18, '4', 'Subtipo 4', 'Subservicio 4', '1000');
INSERT INTO SUBSERVICIOS (ID, SERVICIOS_ID, TIPO, NOMBRE, PRECIO) VALUES (19, '4', 'Subtipo 4', 'Subservicio 4', '1000');
INSERT INTO SUBSERVICIOS (ID, SERVICIOS_ID, TIPO, NOMBRE, PRECIO) VALUES (20, '4', 'Subtipo 4', 'Subservicio 4', '1000');
INSERT INTO SUBSERVICIOS (ID, SERVICIOS_ID, TIPO, NOMBRE, PRECIO) VALUES (21, '5', 'Subtipo 5', 'Subservicio 5', '1000');
INSERT INTO SUBSERVICIOS (ID, SERVICIOS_ID, TIPO, NOMBRE, PRECIO) VALUES (22, '5', 'Subtipo 5', 'Subservicio 5', '1000');
INSERT INTO SUBSERVICIOS (ID, SERVICIOS_ID, TIPO, NOMBRE, PRECIO) VALUES (23, '5', 'Subtipo 5', 'Subservicio 5', '1000');
INSERT INTO SUBSERVICIOS (ID, SERVICIOS_ID, TIPO, NOMBRE, PRECIO) VALUES (24, '5', 'Subtipo 5', 'Subservicio 5', '1000');
INSERT INTO SUBSERVICIOS (ID, SERVICIOS_ID, TIPO, NOMBRE, PRECIO) VALUES (25, '5', 'Subtipo 5', 'Subservicio 5', '1000');
INSERT INTO SUBSERVICIOS (ID, SERVICIOS_ID, TIPO, NOMBRE, PRECIO) VALUES (26, '6', 'Subtipo 6', 'Subservicio 6', '1000');
INSERT INTO SUBSERVICIOS (ID, SERVICIOS_ID, TIPO, NOMBRE, PRECIO) VALUES (27, '6', 'Subtipo 6', 'Subservicio 6', '1000');
INSERT INTO SUBSERVICIOS (ID, SERVICIOS_ID, TIPO, NOMBRE, PRECIO) VALUES (28, '6', 'Subtipo 6', 'Subservicio 6', '1000');
INSERT INTO SUBSERVICIOS (ID, SERVICIOS_ID, TIPO, NOMBRE, PRECIO) VALUES (29, '6', 'Subtipo 6', 'Subservicio 6', '1000');
INSERT INTO SUBSERVICIOS (ID, SERVICIOS_ID, TIPO, NOMBRE, PRECIO) VALUES (30, '6', 'Subtipo 6', 'Subservicio 6', '1000');
INSERT INTO SUBSERVICIOS (ID, SERVICIOS_ID, TIPO, NOMBRE, PRECIO) VALUES (31, '7', 'Subtipo 7', 'Subservicio 7', '1000');
INSERT INTO SUBSERVICIOS (ID, SERVICIOS_ID, TIPO, NOMBRE, PRECIO) VALUES (32, '7', 'Subtipo 7', 'Subservicio 7', '1000');
INSERT INTO SUBSERVICIOS (ID, SERVICIOS_ID, TIPO, NOMBRE, PRECIO) VALUES (33, '7', 'Subtipo 7', 'Subservicio 7', '1000');
INSERT INTO SUBSERVICIOS (ID, SERVICIOS_ID, TIPO, NOMBRE, PRECIO) VALUES (34, '7', 'Subtipo 7', 'Subservicio 7', '1000');
INSERT INTO SUBSERVICIOS (ID, SERVICIOS_ID, TIPO, NOMBRE, PRECIO) VALUES (35, '7', 'Subtipo 7', 'Subservicio 7', '1000');
INSERT INTO SUBSERVICIOS (ID, SERVICIOS_ID, TIPO, NOMBRE, PRECIO) VALUES (36, '8', 'Subtipo 8', 'Subservicio 8', '1000');
INSERT INTO SUBSERVICIOS (ID, SERVICIOS_ID, TIPO, NOMBRE, PRECIO) VALUES (37, '8', 'Subtipo 8', 'Subservicio 8', '1000');
INSERT INTO SUBSERVICIOS (ID, SERVICIOS_ID, TIPO, NOMBRE, PRECIO) VALUES (38, '8', 'Subtipo 8', 'Subservicio 8', '1000');
INSERT INTO SUBSERVICIOS (ID, SERVICIOS_ID, TIPO, NOMBRE, PRECIO) VALUES (39, '8', 'Subtipo 8', 'Subservicio 8', '1000');
INSERT INTO SUBSERVICIOS (ID, SERVICIOS_ID, TIPO, NOMBRE, PRECIO) VALUES (40, '8', 'Subtipo 8', 'Subservicio 8', '1000');
INSERT INTO CARGOS (ID, AREA, TIPO_CARGO, SEGURO, BONO) VALUES (1, 'Hospital', 'Director', 1, 1);
INSERT INTO CARGOS (ID, AREA, TIPO_CARGO, SEGURO, BONO) VALUES (2, 'Hospital', 'Gerente', 1, 1);
INSERT INTO CARGOS (ID, AREA, TIPO_CARGO, SEGURO, BONO) VALUES (3, 'Hospital', 'Tecnico superior', 1, 1);
INSERT INTO CARGOS (ID, AREA, TIPO_CARGO, SEGURO, BONO) VALUES (4, 'Hospital', 'Tecnico medio', 1, 0);
INSERT INTO CARGOS (ID, AREA, TIPO_CARGO, SEGURO, BONO) VALUES (5, 'Hospital', 'Administrativo', 1, 0);
INSERT INTO CARGOS (ID, AREA, TIPO_CARGO, SEGURO, BONO) VALUES (6, 'Farmacia', 'Personal de oficio cualificado', 1, 0);
INSERT INTO CARGOS (ID, AREA, TIPO_CARGO, SEGURO, BONO) VALUES (7, 'Hospital', 'Doctor en jefe', 1, 0);
INSERT INTO CARGOS (ID, AREA, TIPO_CARGO, SEGURO, BONO) VALUES (8, 'Hospital', 'Doctor', 1, 0);
INSERT INTO CARGOS (ID, AREA, TIPO_CARGO, SEGURO, BONO) VALUES (9, 'Hospital', 'Especialista', 1, 0);
INSERT INTO CARGOS (ID, AREA, TIPO_CARGO, SEGURO, BONO) VALUES (10, 'Hospital', 'Enfermera', 1, 0);
INSERT INTO CARGOS (ID, AREA, TIPO_CARGO, SEGURO, BONO) VALUES (11, 'Clinica', 'Biologo', 1, 0);
INSERT INTO CARGOS (ID, AREA, TIPO_CARGO, SEGURO, BONO) VALUES (12, 'Farmacia', 'Farmaceuta', 1, 0);
INSERT INTO CARGOS (ID, AREA, TIPO_CARGO, SEGURO, BONO) VALUES (13, 'Clinica', 'Fisioterapeuta', 1, 0);
INSERT INTO CARGOS (ID, AREA, TIPO_CARGO, SEGURO, BONO) VALUES (14, 'Clinica', 'Fisico', 1, 0);
INSERT INTO CARGOS (ID, AREA, TIPO_CARGO, SEGURO, BONO) VALUES (15, 'Clinica', 'Patologo', 1, 0);
INSERT INTO CARGOS (ID, AREA, TIPO_CARGO, SEGURO, BONO) VALUES (16, 'Clinica', 'Laboratorio', 1, 0);
INSERT INTO CARGOS (ID, AREA, TIPO_CARGO, SEGURO, BONO) VALUES (17, 'Clinica', 'Odontologo', 1, 0);
INSERT INTO CARGOS (ID, AREA, TIPO_CARGO, SEGURO, BONO) VALUES (18, 'Clinica', 'Fisioterapista', 1, 0);
INSERT INTO CARGOS (ID, AREA, TIPO_CARGO, SEGURO, BONO) VALUES (19, 'Clinica', 'Internista', 1, 0);
INSERT INTO CARGOS (ID, AREA, TIPO_CARGO, SEGURO, BONO) VALUES (20, 'Hospital', 'Lavandero', 1, 0);
INSERT INTO CARGOS (ID, AREA, TIPO_CARGO, SEGURO, BONO) VALUES (21, 'Hospital', 'Guardia', 1, 0);
INSERT INTO CARGOS (ID, AREA, TIPO_CARGO, SEGURO, BONO) VALUES (22, 'Hospital', 'Becario', 0, 0);
INSERT INTO CARGOS (ID, AREA, TIPO_CARGO, SEGURO, BONO) VALUES (23, 'Hospital', 'Voluntario', 0, 0);
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (1, 'Alergología');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (2, 'Analisis Clínicos');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (3, 'Anatomía Patológica');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (4, 'Anestesiología y Reanimación');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (5, 'Cardiología');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (6, 'Venereología');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (7, 'Cardiología Pediátrica');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (8, 'Cirugía Cardíaca Pediátrica');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (9, 'Cirugía Cardiovascular');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (10, 'Cirugía General y del Aparato Digestivo');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (11, 'Cirugía Oral y Maxilofacial');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (12, 'Cirugía Pediátrica');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (13, 'Cirugía Plástica y Reparadora');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (14, 'Cirugía Torácica');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (15, 'Cirugía Vascular y Angiología');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (16, 'Dermatología Médico-Quirúrgica');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (17, 'Electrofisiología Cardíaca');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (18, 'Endocrinología Pediátrica');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (19, 'Endocrinología y Nutrición');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (20, 'Enfermedades Infecciosas e Inmunodeficiencias');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (21, 'Fertility Center');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (22, 'Gastroenterología - Aparato Digestivo');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (23, 'Gastroenterología Pediátrica');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (24, 'Genética Clínica');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (25, 'Ginecología y Obstetricia');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (26, 'Hematología y Hemoterapia');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (27, 'Hematología y Oncología Pediátrica');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (28, 'Hemodinámica Cardíaca');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (29, 'Inmunología');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (30, 'Logopedia');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (31, 'Medicina Aeronáutica');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (32, 'Medicina del Deporte');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (33, 'Medicina Estética y Unidad Láser');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (34, 'Medicina Familiar y Comunitaria');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (35, 'Medicina Física y Rehabilitación');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (36, 'Medicina General');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (37, 'Medicina Nuclear');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (38, 'Medicina Preventiva');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (39, 'Nefrología');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (40, 'Nefrología Pediátrica');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (41, 'Neumología');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (42, 'Neumología Pediátrica');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (43, 'Neurocirugía');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (44, 'Neurofisiología');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (45, 'Neurología');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (46, 'Neurología Pediátrica');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (47, 'Neuropsicología');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (48, 'Neurorradiología');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (49, 'Nutrición');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (50, 'Odontología/Estomatología');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (51, 'Oftalmología');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (52, 'Oncología Médica');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (53, 'Oncología Radioterápica');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (54, 'Otorrinolaringología');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (55, 'Pediatría y Áreas Específicas Salud Infantil');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (56, 'Podología');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (57, 'Psicología Clínica');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (58, 'Psiquiatría');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (59, 'Radiodiagnóstico - Diagnóstico por imagen');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (60, 'Radiología Pediátrica');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (61, 'Radiologia Vascular e Intervencionista');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (62, 'Reumatología');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (63, 'Traumatología infantil');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (64, 'Traumatología y Cirugía Ortopédica');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (65, 'Unidad de broncoscopias');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (66, 'Unidad de Cuidados Domiciliarios');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (67, 'Unidad del Dolor');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (68, 'Urgencias');
INSERT INTO ESPECIALIDADES (ID, TIPO_ESPECIALIDAD) VALUES (69, 'Urología');
INSERT INTO FAMILIARES (ID, FECHA_AFILIACION, PUNTOS) VALUES (1, SYSDATE, 0);
INSERT INTO FAMILIARES (ID, FECHA_AFILIACION, PUNTOS) VALUES (2, SYSDATE, 0);
INSERT INTO FAMILIARES (ID, FECHA_AFILIACION, PUNTOS) VALUES (3, SYSDATE, 0);
INSERT INTO FAMILIARES (ID, FECHA_AFILIACION, PUNTOS) VALUES (4, SYSDATE, 0);
INSERT INTO FAMILIARES (ID, FECHA_AFILIACION, PUNTOS) VALUES (5, SYSDATE, 0);
INSERT INTO FAMILIARES (ID, FECHA_AFILIACION, PUNTOS) VALUES (6, SYSDATE, 0);
INSERT INTO FAMILIARES (ID, FECHA_AFILIACION, PUNTOS) VALUES (7, SYSDATE, 0);
INSERT INTO FAMILIARES (ID, FECHA_AFILIACION, PUNTOS) VALUES (8, SYSDATE, 0);
INSERT INTO FAMILIARES (ID, FECHA_AFILIACION, PUNTOS) VALUES (9, SYSDATE, 0);
INSERT INTO FAMILIARES (ID, FECHA_AFILIACION, PUNTOS) VALUES (10, SYSDATE, 0);
INSERT INTO FAMILIARES (ID, FECHA_AFILIACION, PUNTOS) VALUES (11, SYSDATE, 0);
INSERT INTO FAMILIARES (ID, FECHA_AFILIACION, PUNTOS) VALUES (12, SYSDATE, 0);
INSERT INTO FAMILIARES (ID, FECHA_AFILIACION, PUNTOS) VALUES (13, SYSDATE, 0);
INSERT INTO FAMILIARES (ID, FECHA_AFILIACION, PUNTOS) VALUES (14, SYSDATE, 0);
INSERT INTO FAMILIARES (ID, FECHA_AFILIACION, PUNTOS) VALUES (15, SYSDATE, 0);
INSERT INTO FAMILIARES (ID, FECHA_AFILIACION, PUNTOS) VALUES (16, SYSDATE, 0);
INSERT INTO FAMILIARES (ID, FECHA_AFILIACION, PUNTOS) VALUES (17, SYSDATE, 0);
INSERT INTO FAMILIARES (ID, FECHA_AFILIACION, PUNTOS) VALUES (18, SYSDATE, 0);
INSERT INTO FAMILIARES (ID, FECHA_AFILIACION, PUNTOS) VALUES (19, SYSDATE, 0);
INSERT INTO FAMILIARES (ID, FECHA_AFILIACION, PUNTOS) VALUES (20, SYSDATE, 0);
INSERT INTO PERSONAS VALUES (1, 'savannah1999@yahoo.com', 1, 'Matthew', 'Mosher', '1/07/1982', '708-987-4435', 'female', '2117 Grove Avenue', 'A+');
INSERT INTO PERSONAS VALUES (2, 'neha1981@gmail.com', 1, 'Clara', 'McCullough', '9/6/1995', '203-617-5168', 'female', '4766 Boring Lane', 'A+');
INSERT INTO PERSONAS VALUES (3, 'triston_lyn@yahoo.com', 1, 'Melody', 'Flanigan', '9/12/1999', '724-321-1155', 'female', '2144 Losh Lane', 'B+');  
INSERT INTO PERSONAS VALUES (4, 'lyric1975@yahoo.com', 1, 'Reginald', 'Whitt', '7/12/1943', '631-316-2716', 'male', '110 Clark Street', 'B+'); 
INSERT INTO PERSONAS VALUES (5, 'elwyn_mitch9@yahoo.com', 2, 'Marleen', 'Allen', '1/12/1986', '475-201-6287', 'female', '2336 Bedford Street', 'B+'); 
INSERT INTO PERSONAS VALUES (6, 'maymie.cormi@gmail.com', 2, 'Anthony', 'Mcallister', '3/10/1972', '339-203-6043', 'male', '2422 Lynn Street', 'C-'); 
INSERT INTO PERSONAS VALUES (7, 'grace1973@gmail.com', 3, 'Carmen', 'Blair', '12/5/1985', '336-358-4553', 'female', '4921 Havanna Street', 'B+'); 
INSERT INTO PERSONAS VALUES (8, 'susie19831984@gmail.com', 3, 'Joseph', 'Ayer', '1/3/1997', '813-546-4422', 'male', '1001 Saints valley', 'O+'); 
INSERT INTO PERSONAS VALUES (9, 'arlo1980@yahoo.com', 3, 'Margaret', 'Foster', '4/10/1992', '309-629-3759', 'female', '529 Garfield Road', 'O-');
INSERT INTO PERSONAS VALUES (10, 'kay1980@yahoo.com', 4, 'Chantel', 'Thomas', '11/11/1971', '817-660-1063', 'female', '2824 Loving Acres Road', 'O-');
INSERT INTO PERSONAS VALUES (11, 'luz1985@gmail.com', 5, 'Jamie', 'Fuller', '8/11/1972', '309-629-3759', 'female', '4607 Bird Street', 'OA-');
INSERT INTO PERSONAS VALUES (12, 'vernon.spenc@hotmail.com', 6, 'Tiffany', 'West', '2/05/1944', '612-369-0795', 'female', '2950 Sardis Station', 'A+');
INSERT INTO PERSONAS VALUES (13, 'lou.jakubows@yahoo.com', 7, 'Laura', 'Nye', '3/06/1980', '122-352-0845', 'female', '698 West Fork Street', 'A-');
INSERT INTO PERSONAS VALUES (14, 'marquise1973@hotmail.com', 7, 'Darryl', 'Easley', '9/08/1987', '645-312-465', 'male', '1192 Echo Lane', 'AO+');
INSERT INTO PERSONAS VALUES (15, 'jane.ohar7@hotmail.com', 8, 'Mitchell', 'May', '6/4/1977', '206-571-9339', 'male', '2111 Honeysuckle Lane', 'O+');
INSERT INTO PERSONAS VALUES (16, 'marie_gerho@gmail.com', 9, 'Ottis', 'Hollowell', '4/4/1978', '204-456-149', 'male', '2464 Marshall Street', 'O-');
INSERT INTO PERSONAS VALUES (17, 'miles2000@gmail.com', 9, 'Bonnie', 'Starkey', '3/03/1194', '149-254-367', 'female', '1374 Bartlett Avenue', 'A+');
INSERT INTO PERSONAS VALUES (18, 'raegan.romague@yahoo.com', 9, 'Emily', 'Kerr', '12/10/2000', '954-487-510', 'female', '4585 Godfrey Road', 'O+');
INSERT INTO PERSONAS VALUES (19, 'aleandra1988@gmail.com', 10, 'Katherine', 'Seibel', '8/02/1996', '979-254-685', 'female', '2001 Emerson Road', 'O-');
INSERT INTO PERSONAS VALUES (20, 'kamryn1979@gmail.com', 10, 'Tracy', 'Zank', '4/11/1984', '760-271-7384', 'female', '4634 Coleman Avenue', 'A-');
INSERT INTO PERSONAS VALUES (21, 'dee2014@yahoo.com', 11, 'Taunya', 'Borowski', '25/6/1976', '760-506-4558', 'female', '4750 Fincham Road', 'O+');
INSERT INTO PERSONAS VALUES (22, 'donnell_frits@hotmail.com', 11, 'Larry', 'Knight', '11/5/1976', '307-576-5011', 'male', '215 Thorn Street', 'A-');
INSERT INTO PERSONAS VALUES (23, 'margarett8@gmail.com', 12, 'Victoria', 'Dolan', '10/7/1989', '979-777-9437', 'female', '1156 Colonial Drive', 'A+');
INSERT INTO PERSONAS VALUES (24, 'jaylan_hirt@gmail.com', 12, 'Joyce', 'Koch', '14/12/1981', '505-722-0437', 'female', '4603 Cooks Mine Road', 'B-');
INSERT INTO PERSONAS VALUES (25, 'unique.nien@yahoo.com', 13, 'Colleen', 'Kerney', '23/12/1967', '515-650-4085', 'female', '3776 Nutters Barn Lane', 'B+');
INSERT INTO PERSONAS VALUES (26, 'norval.pfeff@gmail.com', 13, 'Viva', 'Arnold', '7/11/1988', '217-590-8169', 'female', '4578 University Hill Road', 'B+');
INSERT INTO PERSONAS VALUES (27, 'ru1982@yahoo.com', 14, 'Favid', 'Mullins', '19/06/1992', '360-318-6681', 'male', '4564 Terra Street', 'A+');
INSERT INTO PERSONAS VALUES (28, 'adele.gottli@gmail.com', 14, 'Albert', 'Madox', '17/02/1987', '615-969-7842', 'male', '4657 Happiness Street', 'B-');
INSERT INTO PERSONAS VALUES (29, 'golden2006@yahoo.com', 15, 'Elaine', 'Reese', '17/01/1974', '617-878-2553', 'female', '4125 Geralds Drive', 'B+');
INSERT INTO PERSONAS VALUES (30, 'oscar2002@hotmail.com', 15, 'Oscar', 'Miller', '18/08/2002', '239-263-2875', 'male', '1088 Owen Lane', 'O-');
INSERT INTO PERSONAS VALUES (31, 'laura2001@hotmail.com', 15, 'Laura', 'Miller', '18/02/2001', '239-263-2875', 'female', '1088 Owen Lane', 'O-');
INSERT INTO PERSONAS VALUES (32, 'jennings.wym@hotmail.com', 16, 'Bart', 'Page', '01/08/1969', '123-455-7883', 'male', '4695 Chandler Hollow Road', 'A-');
INSERT INTO PERSONAS VALUES (33, 'marcia1993@hotmail.com', 16, 'Carmen', 'Calloway', '27/07/1986', '145-254-1252', 'female', '194 Watson Street', 'O-');
INSERT INTO PERSONAS VALUES (34, 'ruth.moor0@gmail.com', 16, 'George', 'Brown', '27/12/1990', '452-465-5161', 'female', '3166 Hillview Street', 'O-');
INSERT INTO PERSONAS VALUES (35, 'kaelyn2009@yahoo.com', 16, 'Byron', 'McCall', '06/12/1975', '132-451-0000', 'male', '3818 Sunny Glen Lane', 'A+');
INSERT INTO PERSONAS VALUES (36, 'martin.stros@gmail.com', 16, 'Ashley', 'Huges', '20/12/1992', '425-961-2270', 'female', '17 Scenicview Drive', 'O+');
INSERT INTO PERSONAS VALUES (37, 'johnny.christians@hotmail.com', 17, 'Robert', 'Taylor', '03/11/1976', '859-200-2229', 'male', '28 Carson Street', 'A+');
INSERT INTO PERSONAS VALUES (38, 'geraldine1990@yahoo.com', 18, 'Herbert', 'Aaron', '18/12/1987', '912-282-6644', 'male', '210 Austin Avenue', 'A-');
INSERT INTO PERSONAS VALUES (39, 'suzanne_hue@yahoo.com', 19, 'Loretta', 'Ostrander', '09/01/1971', '908-225-3193', 'female', '3474 Williams Mine Road', 'B+');
INSERT INTO PERSONAS VALUES (40, 'esperanza_g@yahoo.com', 20, 'Jeanne', 'Lerch', '31/07/1981', '148-524-600', 'female', '1485 Cooks Mine Road', 'B+');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (1, 'Cirugia', 150, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (2, 'Hospitalizacion', 175, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (3, 'Tratamiento', 97, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (4, 'Fractura', 59.5, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (5, 'Revision', 120, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (6, 'Internamiento', 140, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (7, 'Consulta', 120, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (8, 'Dislocamiento', 120, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (9, 'Visita', 60, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (10, 'Compra de medicinas', 115, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (11, 'Vacunacion', 43, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (12, 'Resfriado', 35, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (13, 'Recuperacion', 250.45, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (14, 'Paranoia', 666.66, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (15, 'Dolor muscular', 12.45, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (16, 'Dolor arterial', 45.7, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (17, 'Dolor de dientes', 44.1, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (18, 'Dolor de cabeza', 78.4, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (19, 'Dolor general', 54.1, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (20, 'Mareos', 45, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (21, 'Desmayos', 45, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (22, 'Terrores nocturnos', 90, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (23, 'Perdida de vision', 90, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (24, 'Alucionaciones', 90, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (25, 'Perdida del apetito', 90, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (26, 'Perdida de la audicion', 90, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (27, 'Desorientacion', 90, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (28, 'Dolor en los huesos', 150, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (29, 'Descalcificacion', 250, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (30, 'Cancer', 450, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (31, 'VIH', 777.7, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (32, 'Sindrome desconocido', 40.8, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (33, 'Tratamiento', 45.4, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (34, 'Perdida capilar', 171.1, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (35, 'Desorientacion', 75.1, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (36, 'Dolor de espalda', 315.4, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (37, 'Desorden olfatorio', 270.2, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (38, 'Perdida del gusto', 351.1, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (39, 'Perdida de vision', 270.84, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (40, 'Compra de farmacos', 150.35, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (41, 'Hambre', 50, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (42, 'Saludar', 0, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (43, 'Perdida del tiempo', 150.0, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (44, 'Vacunacion', 123, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (45, 'Compra de farmacos', 465, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (46, 'Chequeo general', 789, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (47, 'Donación de sangre', 174, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (48, 'Compra de farmacos', 285, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (49, 'Dolor de espalda', 396, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (50, 'Vacunacion', 241, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (51, 'Quimioterapia', 753, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (52, 'Chequeo anual', 689, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (53, 'Donación de sangre', 943, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (54, 'Chequeo general', 167, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (55, 'Fractura', 761, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (56, 'Vacunacion', 349, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (57, 'Visita', 842, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (58, 'Chequeo anual', 268, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (59, 'Compra de farmacos', 684, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (60, 'Donación de sangre', 842, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (61, 'Donación de sangre', 222, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (62, 'Vacunacion', 333, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (63, 'Paranoia', 15.45, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (64, 'Chequeo general', 653.2, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (65, 'Chequeo general', 245.12, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (66, 'Hospitalizacion', 454.4, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (67, 'Fractura', 111.11, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (68, 'Mareos', 222.12, sysdate, '');
INSERT INTO REGISTROS (ID, MOTIVO, COSTO, FECHA, DETALLE) VALUES (69, 'Vacunacion', 333.4, sysdate, '');
INSERT INTO EMPLEADOS (ID, SERVICIOS_ID, CARGOS_ID, CARGOS_AREA, ESPECIALIDADES_ID, PERSONAS_ID, SUELDO) VALUES(1, 3, 5, 'Hospital', 1, 1, 5000);
INSERT INTO EMPLEADOS (ID, SERVICIOS_ID, CARGOS_ID, CARGOS_AREA, ESPECIALIDADES_ID, PERSONAS_ID, SUELDO) VALUES(2, 7, 7, 'Hospital', 7, 3, 4500.50);
INSERT INTO EMPLEADOS (ID, SERVICIOS_ID, CARGOS_ID, CARGOS_AREA, ESPECIALIDADES_ID, PERSONAS_ID, SUELDO) VALUES(3, 8, 12, 'Farmacia', 14, 5, 4150.46);
INSERT INTO EMPLEADOS (ID, SERVICIOS_ID, CARGOS_ID, CARGOS_AREA, ESPECIALIDADES_ID, PERSONAS_ID, SUELDO) VALUES(4, 12, 8, 'Hospital', 21, 7, 4375.48);
INSERT INTO EMPLEADOS (ID, SERVICIOS_ID, CARGOS_ID, CARGOS_AREA, ESPECIALIDADES_ID, PERSONAS_ID, SUELDO) VALUES(5, 13, 4, 'Hospital', 28, 9, 4750.49);
INSERT INTO EMPLEADOS (ID, SERVICIOS_ID, CARGOS_ID, CARGOS_AREA, ESPECIALIDADES_ID, PERSONAS_ID, SUELDO) VALUES(6, 16, 23, 'Hospital', 35, 11, 3496.66);
INSERT INTO EMPLEADOS (ID, SERVICIOS_ID, CARGOS_ID, CARGOS_AREA, ESPECIALIDADES_ID, PERSONAS_ID, SUELDO) VALUES(7, 1, 23, 'Hospital', 42, 13, 3496.66);
INSERT INTO EMPLEADOS (ID, SERVICIOS_ID, CARGOS_ID, CARGOS_AREA, ESPECIALIDADES_ID, PERSONAS_ID, SUELDO) VALUES(8, 1, 18, 'Clinica', 49, 15, 3748.49);
INSERT INTO EMPLEADOS (ID, SERVICIOS_ID, CARGOS_ID, CARGOS_AREA, ESPECIALIDADES_ID, PERSONAS_ID, SUELDO) VALUES(9, 4, 14, 'Clinica', 56, 17, 3950.48);
INSERT INTO EMPLEADOS (ID, SERVICIOS_ID, CARGOS_ID, CARGOS_AREA, ESPECIALIDADES_ID, PERSONAS_ID, SUELDO) VALUES(10, 3, 18, 'Clinica', 57, 19, 3748.49);
INSERT INTO HORARIOS (ID, DIAS, HORA_ENTRADA, HORA_SALIDA) VALUES (1, 5, sysdate, sysdate + 8/24);
INSERT INTO HORARIOS (ID, DIAS, HORA_ENTRADA, HORA_SALIDA) VALUES (2, 3, sysdate, sysdate + 12/24);
INSERT INTO HORARIOS (ID, DIAS, HORA_ENTRADA, HORA_SALIDA) VALUES (3, 6, sysdate, sysdate + 6/24);
INSERT INTO TURNOS (EMPLEADOS_ID, HORARIOS_ID, ZONA) VALUES (1, 1, '');
INSERT INTO TURNOS (EMPLEADOS_ID, HORARIOS_ID, ZONA) VALUES (3, 2, '');
INSERT INTO TURNOS (EMPLEADOS_ID, HORARIOS_ID, ZONA) VALUES (5, 3, '');
INSERT INTO TURNOS (EMPLEADOS_ID, HORARIOS_ID, ZONA) VALUES (7, 1, '');
INSERT INTO TURNOS (EMPLEADOS_ID, HORARIOS_ID, ZONA) VALUES (9, 2, '');
INSERT INTO TURNOS (EMPLEADOS_ID, HORARIOS_ID, ZONA) VALUES (2, 3, '');
INSERT INTO TURNOS (EMPLEADOS_ID, HORARIOS_ID, ZONA) VALUES (4, 1, '');
INSERT INTO TURNOS (EMPLEADOS_ID, HORARIOS_ID, ZONA) VALUES (6, 2, '');
INSERT INTO TURNOS (EMPLEADOS_ID, HORARIOS_ID, ZONA) VALUES (8, 3, '');
INSERT INTO TURNOS (EMPLEADOS_ID, HORARIOS_ID, ZONA) VALUES (10, 1, '');
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (16, 30);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (5, 29);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (17, 28);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (4, 27);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (18, 26);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (3, 25);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (20, 24);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (2, 23);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (19, 22);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (1, 21);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (10, 20);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (10, 19);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (11, 18);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (9, 17);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (12, 16);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (8, 15);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (13, 14);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (7, 13);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (14, 12);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (6, 11);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (15, 10);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (5, 9);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (16, 8);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (3, 7);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (17, 6);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (2, 5);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (18, 4);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (4, 3);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (19, 2);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (1, 1);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (1, 30);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (1, 29);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (2, 28);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (2, 27);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (3, 26);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (3, 25);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (4, 24);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (4, 26);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (5, 25);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (5, 24);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (6, 23);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (6, 22);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (7, 21);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (7, 20);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (8, 19);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (8, 18);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (9, 17);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (9, 16);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (10, 15);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (10, 14);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (11, 13);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (11, 12);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (12, 11);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (12, 10);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (13, 9);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (13, 8);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (14, 7);
INSERT INTO SERVICIOS_REGISTROS(SERVICIOS_ID, REGISTROS_ID) VALUES (14, 6);
INSERT INTO PERSONAL (REGISTROS_ID, EMPLEADOS_ID) VALUES (31, 1);
INSERT INTO PERSONAL (REGISTROS_ID, EMPLEADOS_ID) VALUES (32, 2);
INSERT INTO PERSONAL (REGISTROS_ID, EMPLEADOS_ID) VALUES (33, 4);
INSERT INTO PERSONAL (REGISTROS_ID, EMPLEADOS_ID) VALUES (34, 3);
INSERT INTO PERSONAL (REGISTROS_ID, EMPLEADOS_ID) VALUES (35, 1);
INSERT INTO PERSONAL (REGISTROS_ID, EMPLEADOS_ID) VALUES (36, 5);
INSERT INTO PERSONAL (REGISTROS_ID, EMPLEADOS_ID) VALUES (37, 2);
INSERT INTO PERSONAL (REGISTROS_ID, EMPLEADOS_ID) VALUES (38, 6);
INSERT INTO PERSONAL (REGISTROS_ID, EMPLEADOS_ID) VALUES (39, 7);
INSERT INTO PERSONAL (REGISTROS_ID, EMPLEADOS_ID) VALUES (40, 8);
INSERT INTO PERSONAL (REGISTROS_ID, EMPLEADOS_ID) VALUES (41, 8);
INSERT INTO PERSONAL (REGISTROS_ID, EMPLEADOS_ID) VALUES (42, 9);
INSERT INTO CLIENTES (REGISTROS_ID, PERSONAS_ID) VALUES(43, 2);
INSERT INTO CLIENTES (REGISTROS_ID, PERSONAS_ID) VALUES(44, 4);
INSERT INTO CLIENTES (REGISTROS_ID, PERSONAS_ID) VALUES(45, 6);
INSERT INTO CLIENTES (REGISTROS_ID, PERSONAS_ID) VALUES(46, 8);
INSERT INTO CLIENTES (REGISTROS_ID, PERSONAS_ID) VALUES(47, 10);
INSERT INTO CLIENTES (REGISTROS_ID, PERSONAS_ID) VALUES(48, 12);
INSERT INTO CLIENTES (REGISTROS_ID, PERSONAS_ID) VALUES(49, 14);
INSERT INTO CLIENTES (REGISTROS_ID, PERSONAS_ID) VALUES(50, 16);
INSERT INTO CLIENTES (REGISTROS_ID, PERSONAS_ID) VALUES(51, 18);
INSERT INTO CLIENTES (REGISTROS_ID, PERSONAS_ID) VALUES(52, 20);
INSERT INTO CLIENTES (REGISTROS_ID, PERSONAS_ID) VALUES(53, 2);
INSERT INTO CLIENTES (REGISTROS_ID, PERSONAS_ID) VALUES(54, 4);
INSERT INTO CLIENTES (REGISTROS_ID, PERSONAS_ID) VALUES(55, 6);
INSERT INTO CLIENTES (REGISTROS_ID, PERSONAS_ID) VALUES(56, 8);
INSERT INTO CLIENTES (REGISTROS_ID, PERSONAS_ID) VALUES(57, 10);
INSERT INTO CLIENTES (REGISTROS_ID, PERSONAS_ID) VALUES(58, 12);
INSERT INTO CLIENTES (REGISTROS_ID, PERSONAS_ID) VALUES(59, 14);
INSERT INTO CLIENTES (REGISTROS_ID, PERSONAS_ID) VALUES(60, 16);
INSERT INTO CLIENTES (REGISTROS_ID, PERSONAS_ID) VALUES(61, 18);
INSERT INTO CLIENTES (REGISTROS_ID, PERSONAS_ID) VALUES(62, 20);
INSERT INTO CLIENTES (REGISTROS_ID, PERSONAS_ID) VALUES(63, 2);
INSERT INTO CLIENTES (REGISTROS_ID, PERSONAS_ID) VALUES(64, 4);
INSERT INTO CLIENTES (REGISTROS_ID, PERSONAS_ID) VALUES(65, 6);
INSERT INTO CLIENTES (REGISTROS_ID, PERSONAS_ID) VALUES(66, 8);
INSERT INTO CLIENTES (REGISTROS_ID, PERSONAS_ID) VALUES(67, 10);
INSERT INTO CLIENTES (REGISTROS_ID, PERSONAS_ID) VALUES(68, 12);
INSERT INTO CLIENTES (REGISTROS_ID, PERSONAS_ID) VALUES(69, 14);
INSERT INTO CITAS (ID, FECHA) VALUES (1, sysdate);
INSERT INTO CITAS (ID, FECHA) VALUES (2, sysdate);
INSERT INTO CITAS (ID, FECHA) VALUES (3, sysdate);
INSERT INTO CITAS (ID, FECHA) VALUES (4, sysdate);
INSERT INTO CITAS (ID, FECHA) VALUES (5, sysdate);
INSERT INTO CITAS (ID, FECHA) VALUES (6, sysdate);
INSERT INTO CITAS (ID, FECHA) VALUES (7, sysdate);
INSERT INTO CITAS (ID, FECHA) VALUES (8, sysdate);
INSERT INTO CITAS (ID, FECHA) VALUES (9, sysdate);
INSERT INTO CITAS (ID, FECHA) VALUES (10, sysdate);
INSERT INTO CITAS (ID, FECHA) VALUES (11, sysdate);
INSERT INTO CITAS (ID, FECHA) VALUES (12, sysdate);
INSERT INTO CITAS (ID, FECHA) VALUES (13, sysdate);
INSERT INTO CITAS (ID, FECHA) VALUES (14, sysdate);
INSERT INTO CITAS (ID, FECHA) VALUES (15, sysdate);
INSERT INTO CITAS (ID, FECHA) VALUES (16, sysdate);
INSERT INTO CITAS (ID, FECHA) VALUES (17, sysdate);
INSERT INTO CITAS (ID, FECHA) VALUES (18, sysdate);
INSERT INTO CITAS (ID, FECHA) VALUES (19, sysdate);
INSERT INTO CITAS (ID, FECHA) VALUES (20, sysdate);
INSERT INTO CITAS (ID, FECHA) VALUES (21, sysdate);
INSERT INTO CITAS (ID, FECHA) VALUES (22, sysdate);
INSERT INTO CITAS (ID, FECHA) VALUES (23, sysdate);
INSERT INTO CITAS (ID, FECHA) VALUES (24, sysdate);
INSERT INTO CITAS (ID, FECHA) VALUES (25, sysdate);
INSERT INTO CITAS (ID, FECHA) VALUES (26, sysdate);
INSERT INTO CITAS (ID, FECHA) VALUES (27, sysdate);
INSERT INTO CITAS (ID, FECHA) VALUES (28, sysdate);
INSERT INTO CITAS (ID, FECHA) VALUES (29, sysdate);
INSERT INTO CITAS (ID, FECHA) VALUES (30, sysdate);
INSERT INTO CITAS (ID, FECHA) VALUES (31, sysdate);
INSERT INTO CITAS (ID, FECHA) VALUES (32, sysdate);
INSERT INTO CITAS (ID, FECHA) VALUES (33, sysdate);
INSERT INTO CITAS (ID, FECHA) VALUES (34, sysdate);
INSERT INTO CITAS (ID, FECHA) VALUES (35, sysdate);
INSERT INTO CITAS (ID, FECHA) VALUES (36, sysdate);
INSERT INTO SERVICIOS_CITAS (CITAS_ID, SERVICIOS_ID) VALUES (2, 1);
INSERT INTO SERVICIOS_CITAS (CITAS_ID, SERVICIOS_ID) VALUES (4, 3);
INSERT INTO SERVICIOS_CITAS (CITAS_ID, SERVICIOS_ID) VALUES (6, 4);
INSERT INTO SERVICIOS_CITAS (CITAS_ID, SERVICIOS_ID) VALUES (8, 6);
INSERT INTO SERVICIOS_CITAS (CITAS_ID, SERVICIOS_ID) VALUES (10, 7);
INSERT INTO SERVICIOS_CITAS (CITAS_ID, SERVICIOS_ID) VALUES (11, 9);
INSERT INTO SERVICIOS_CITAS (CITAS_ID, SERVICIOS_ID) VALUES (13, 10);
INSERT INTO SERVICIOS_CITAS (CITAS_ID, SERVICIOS_ID) VALUES (15, 11);
INSERT INTO SERVICIOS_CITAS (CITAS_ID, SERVICIOS_ID) VALUES (17, 13);
INSERT INTO SERVICIOS_CITAS (CITAS_ID, SERVICIOS_ID) VALUES (19, 15);
INSERT INTO SERVICIOS_CITAS (CITAS_ID, SERVICIOS_ID) VALUES (20, 16);
INSERT INTO SERVICIOS_CITAS (CITAS_ID, SERVICIOS_ID) VALUES (22, 18);
INSERT INTO SERVICIOS_CITAS (CITAS_ID, SERVICIOS_ID) VALUES (24, 20);
INSERT INTO SERVICIOS_CITAS (CITAS_ID, SERVICIOS_ID) VALUES (26, 19);
INSERT INTO SERVICIOS_CITAS (CITAS_ID, SERVICIOS_ID) VALUES (28, 17);
INSERT INTO SERVICIOS_CITAS (CITAS_ID, SERVICIOS_ID) VALUES (30, 8);
INSERT INTO ATENDEDORES(CITAS_ID, EMPLEADOS_ID) VALUES (1, 1);
INSERT INTO ATENDEDORES(CITAS_ID, EMPLEADOS_ID) VALUES (3, 2);
INSERT INTO ATENDEDORES(CITAS_ID, EMPLEADOS_ID) VALUES (5, 3);
INSERT INTO ATENDEDORES(CITAS_ID, EMPLEADOS_ID) VALUES (7, 4);
INSERT INTO ATENDEDORES(CITAS_ID, EMPLEADOS_ID) VALUES (9, 5);
INSERT INTO ATENDEDORES(CITAS_ID, EMPLEADOS_ID) VALUES (12, 6);
INSERT INTO ATENDEDORES(CITAS_ID, EMPLEADOS_ID) VALUES (14, 7);
INSERT INTO ATENDEDORES(CITAS_ID, EMPLEADOS_ID) VALUES (16, 8);
INSERT INTO ATENDEDORES(CITAS_ID, EMPLEADOS_ID) VALUES (18, 9);
INSERT INTO ATENDEDORES(CITAS_ID, EMPLEADOS_ID) VALUES (21, 10);
INSERT INTO PACIENTES (CITAS_ID, PERSONAS_ID) VALUES (23, 2);
INSERT INTO PACIENTES (CITAS_ID, PERSONAS_ID) VALUES (25, 4);
INSERT INTO PACIENTES (CITAS_ID, PERSONAS_ID) VALUES (27, 6);
INSERT INTO PACIENTES (CITAS_ID, PERSONAS_ID) VALUES (29, 8);
INSERT INTO PACIENTES (CITAS_ID, PERSONAS_ID) VALUES (31, 10);
INSERT INTO PACIENTES (CITAS_ID, PERSONAS_ID) VALUES (32, 12);
INSERT INTO PACIENTES (CITAS_ID, PERSONAS_ID) VALUES (33, 14);
INSERT INTO PACIENTES (CITAS_ID, PERSONAS_ID) VALUES (34, 16);
INSERT INTO PACIENTES (CITAS_ID, PERSONAS_ID) VALUES (35, 18);
INSERT INTO PACIENTES (CITAS_ID, PERSONAS_ID) VALUES (36, 20);


-- DROPS  
   
/*drop table servicios_citas cascade constraints;
drop table servicios_registros cascade constraints;
drop table atendedores cascade constraints;
drop table cargos cascade constraints;
drop table citas cascade constraints;
drop table clientes cascade constraints;
drop table empleados cascade constraints;
drop table especialidades cascade constraints;
drop table familiares cascade constraints;
drop table horarios cascade constraints;
drop table pacientes cascade constraints;
drop table personal cascade constraints;
drop table personas cascade constraints;
drop table registros cascade constraints;
drop table servicios cascade constraints;
drop table subservicios cascade constraints;
drop table turnos cascade constraints;

drop sequence cargos_id_seq;
drop sequence citas_id_seq;
drop sequence empleados_id_seq;
drop sequence especialidades_id_seq;
drop sequence familiares_id_seq;
drop sequence horarios_id_seq;
drop sequence personas_id_seq;
drop sequence registros_id_seq;
drop sequence servicios_id_seq;
drop sequence subservicios_id_seq;
*/