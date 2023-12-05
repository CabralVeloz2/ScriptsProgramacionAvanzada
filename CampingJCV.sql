-- Generado por Oracle SQL Developer Data Modeler 22.2.0.165.1149
--   en:        2023-10-23 02:16:41 CEST
--   sitio:      SQL Server 2012
--   tipo:      SQL Server 2012

-- Crear Base de Datos
DROP DATABASE IF EXISTS CampingJCV;
GO
CREATE DATABASE CampingJCV;
GO
USE CampingJCV;
GO

CREATE TABLE ACTIVIDAD 
    (
     ID_actividad INTEGER NOT NULL , 
     Nombre VARCHAR (20) NOT NULL , 
     Descripcion VARCHAR (80) 
    )
GO

ALTER TABLE ACTIVIDAD ADD CONSTRAINT ACTIVIDAD_PK PRIMARY KEY CLUSTERED (ID_actividad)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE CAMPING 
    (
     ID_camping INTEGER NOT NULL , 
     Nombre VARCHAR (20) NOT NULL , 
     Ubicacion VARCHAR (20) , 
     Capacidad INTEGER NOT NULL , 
     Tarifa NUMERIC (20) NOT NULL , 
     Descripcion VARCHAR (80) , 
     RESERVA_ID_reserva INTEGER NOT NULL 
    )
GO

ALTER TABLE CAMPING ADD CONSTRAINT CAMPING_PK PRIMARY KEY CLUSTERED (ID_camping)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE CAMPING_ACTIVIDAD 
    (
     CAMPING_ID_camping INTEGER NOT NULL , 
     ACTIVIDAD_ID_actividad INTEGER NOT NULL 
    )
GO

ALTER TABLE CAMPING_ACTIVIDAD ADD CONSTRAINT CAMPING_ACTIVIDAD_PK PRIMARY KEY CLUSTERED (CAMPING_ID_camping, ACTIVIDAD_ID_actividad)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE CAMPING_COMODIDAD 
    (
     CAMPING_ID_camping INTEGER NOT NULL , 
     COMODIDAD_ID_comodidad INTEGER NOT NULL 
    )
GO

ALTER TABLE CAMPING_COMODIDAD ADD CONSTRAINT CAMPING_COMODIDAD_PK PRIMARY KEY CLUSTERED (CAMPING_ID_camping, COMODIDAD_ID_comodidad)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE CLIENTE 
    (
     ID_cliente INTEGER NOT NULL , 
     DNI CHAR (9) , 
     Nombre VARCHAR (20) NOT NULL , 
     Apellido VARCHAR (20) NOT NULL , 
     Segundo_apellido VARCHAR (20) , 
     Email VARCHAR (20) NOT NULL , 
     Telefono CHAR (9) NOT NULL , 
     Direccion VARCHAR (80) NOT NULL , 
     MUNICIPIO_ID_municipio INTEGER NOT NULL 
    )
GO

ALTER TABLE CLIENTE ADD CONSTRAINT CLIENTE_PK PRIMARY KEY CLUSTERED (ID_cliente)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE COMODIDAD 
    (
     ID_comodidad INTEGER NOT NULL , 
     Nombre VARCHAR (20) NOT NULL , 
     Descripcion VARCHAR (80) 
    )
GO

ALTER TABLE COMODIDAD ADD CONSTRAINT COMODIDAD_PK PRIMARY KEY CLUSTERED (ID_comodidad)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE EMPLEADO 
    (
     ID_empleado INTEGER NOT NULL , 
     DNI CHAR (9) NOT NULL , 
     Nombre VARCHAR (20) NOT NULL , 
     Apellido VARCHAR (20) NOT NULL , 
     Segundo_apellido VARCHAR (20) , 
     Puesto VARCHAR (20) NOT NULL , 
     Fecha_contratacion DATE NOT NULL , 
     MUNICIPIO_ID_municipio INTEGER NOT NULL 
    )
GO

ALTER TABLE EMPLEADO ADD CONSTRAINT EMPLEADO_PK PRIMARY KEY CLUSTERED (ID_empleado)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE EMPLEADO_CAMPING 
    (
     CAMPING_ID_camping INTEGER NOT NULL , 
     EMPLEADO_ID_empleado INTEGER NOT NULL 
    )
GO

ALTER TABLE EMPLEADO_CAMPING ADD CONSTRAINT EMPLEADO_CAMPING_PK PRIMARY KEY CLUSTERED (CAMPING_ID_camping, EMPLEADO_ID_empleado)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE FACTURA 
    (
     ID_factura INTEGER NOT NULL , 
     Fecha_emision DATE NOT NULL , 
     Monto_total NUMERIC (20) NOT NULL , 
     CLIENTE_ID_cliente INTEGER NOT NULL , 
     PAGO_ID_pago INTEGER NOT NULL 
    )
GO

ALTER TABLE FACTURA ADD CONSTRAINT FACTURA_PK PRIMARY KEY CLUSTERED (ID_factura)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE FORMA_PAGO 
    (
     ID_forma_pago INTEGER NOT NULL , 
     Descripcion VARCHAR (80) , 
     TARJETA_ID_forma_pago INTEGER NOT NULL , 
     TRANSFERENCIA_ID_forma_pago INTEGER NOT NULL 
    )
GO

ALTER TABLE FORMA_PAGO ADD CONSTRAINT FORMA_PAGO_PK PRIMARY KEY CLUSTERED (ID_forma_pago)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE MUNICIPIO 
    (
     ID_municipio INTEGER NOT NULL , 
     Municipio VARCHAR (20) NOT NULL , 
     PROVINCIA_ID_provincia INTEGER NOT NULL 
    )
GO

ALTER TABLE MUNICIPIO ADD CONSTRAINT MUNICIPIO_PK PRIMARY KEY CLUSTERED (ID_municipio)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE NOMINA 
    (
     ID_nomina INTEGER NOT NULL , 
     Fecha_alta DATE NOT NULL , 
     Numero_seguridad_social CHAR (12) NOT NULL , 
     Salario NUMERIC (20) NOT NULL , 
     EMPLEADO_ID_empleado INTEGER NOT NULL 
    )
GO

ALTER TABLE NOMINA ADD CONSTRAINT NOMINA_PK PRIMARY KEY CLUSTERED (ID_nomina)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE PAGO 
    (
     ID_pago INTEGER NOT NULL , 
     Estado_pago VARCHAR (20) NOT NULL , 
     Fecha_pago DATE NOT NULL , 
     FORMA_PAGO_ID_forma_pago INTEGER NOT NULL , 
     CLIENTE_ID_cliente INTEGER NOT NULL 
    )
GO

ALTER TABLE PAGO ADD CONSTRAINT PAGO_PK PRIMARY KEY CLUSTERED (ID_pago)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE PROVINCIA 
    (
     ID_provincia INTEGER NOT NULL , 
     Provincia VARCHAR (20) NOT NULL 
    )
GO

ALTER TABLE PROVINCIA ADD CONSTRAINT PROVINCIA_PK PRIMARY KEY CLUSTERED (ID_provincia)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE RESERVA 
    (
     ID_reserva INTEGER NOT NULL , 
     Fecha_entrada DATE NOT NULL , 
     Fecha_salida DATE NOT NULL , 
     Numero_personas INTEGER NOT NULL , 
     CLIENTE_ID_cliente INTEGER NOT NULL 
    )
GO

ALTER TABLE RESERVA ADD CONSTRAINT RESERVA_PK PRIMARY KEY CLUSTERED (ID_reserva)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE TARJETA 
    (
     ID_forma_pago INTEGER NOT NULL , 
     Nombre_titular VARCHAR (20) NOT NULL , 
     Numero_tarjeta INTEGER NOT NULL , 
     Fecha_caducidad DATE NOT NULL , 
     CCV INTEGER NOT NULL 
    )
GO

ALTER TABLE TARJETA ADD CONSTRAINT TARJETA_PK PRIMARY KEY CLUSTERED (ID_forma_pago)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE TRANSFERENCIA 
    (
     ID_forma_pago INTEGER NOT NULL , 
     Nombre_cuenta VARCHAR (20) NOT NULL , 
     Numero_cuenta VARCHAR (20) NOT NULL , 
     Entidad_bancaria VARCHAR (20) NOT NULL , 
     Detalle VARCHAR (80) 
    )
GO

ALTER TABLE TRANSFERENCIA ADD CONSTRAINT TRANSFERENCIA_PK PRIMARY KEY CLUSTERED (ID_forma_pago)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

ALTER TABLE CAMPING_ACTIVIDAD 
    ADD CONSTRAINT CAMPING_ACTIVIDAD_ACTIVIDAD_FK FOREIGN KEY 
    ( 
     ACTIVIDAD_ID_actividad
    ) 
    REFERENCES ACTIVIDAD 
    ( 
     ID_actividad 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE CAMPING_ACTIVIDAD 
    ADD CONSTRAINT CAMPING_ACTIVIDAD_CAMPING_FK FOREIGN KEY 
    ( 
     CAMPING_ID_camping
    ) 
    REFERENCES CAMPING 
    ( 
     ID_camping 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE CAMPING_COMODIDAD 
    ADD CONSTRAINT CAMPING_COMODIDAD_CAMPING_FK FOREIGN KEY 
    ( 
     CAMPING_ID_camping
    ) 
    REFERENCES CAMPING 
    ( 
     ID_camping 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE CAMPING_COMODIDAD 
    ADD CONSTRAINT CAMPING_COMODIDAD_COMODIDAD_FK FOREIGN KEY 
    ( 
     COMODIDAD_ID_comodidad
    ) 
    REFERENCES COMODIDAD 
    ( 
     ID_comodidad 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE CAMPING 
    ADD CONSTRAINT CAMPING_RESERVA_FK FOREIGN KEY 
    ( 
     RESERVA_ID_reserva
    ) 
    REFERENCES RESERVA 
    ( 
     ID_reserva 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE CLIENTE 
    ADD CONSTRAINT CLIENTE_MUNICIPIO_FK FOREIGN KEY 
    ( 
     MUNICIPIO_ID_municipio
    ) 
    REFERENCES MUNICIPIO 
    ( 
     ID_municipio 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE EMPLEADO_CAMPING 
    ADD CONSTRAINT EMPLEADO_CAMPING_CAMPING_FK FOREIGN KEY 
    ( 
     CAMPING_ID_camping
    ) 
    REFERENCES CAMPING 
    ( 
     ID_camping 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE EMPLEADO_CAMPING 
    ADD CONSTRAINT EMPLEADO_CAMPING_EMPLEADO_FK FOREIGN KEY 
    ( 
     EMPLEADO_ID_empleado
    ) 
    REFERENCES EMPLEADO 
    ( 
     ID_empleado 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE EMPLEADO 
    ADD CONSTRAINT EMPLEADO_MUNICIPIO_FK FOREIGN KEY 
    ( 
     MUNICIPIO_ID_municipio
    ) 
    REFERENCES MUNICIPIO 
    ( 
     ID_municipio 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE FACTURA 
    ADD CONSTRAINT FACTURA_CLIENTE_FK FOREIGN KEY 
    ( 
     CLIENTE_ID_cliente
    ) 
    REFERENCES CLIENTE 
    ( 
     ID_cliente 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE FACTURA 
    ADD CONSTRAINT FACTURA_PAGO_FK FOREIGN KEY 
    ( 
     PAGO_ID_pago
    ) 
    REFERENCES PAGO 
    ( 
     ID_pago 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE FORMA_PAGO 
    ADD CONSTRAINT FORMA_PAGO_TARJETA_FK FOREIGN KEY 
    ( 
     TARJETA_ID_forma_pago
    ) 
    REFERENCES TARJETA 
    ( 
     ID_forma_pago 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE FORMA_PAGO 
    ADD CONSTRAINT FORMA_PAGO_TRANSFERENCIA_FK FOREIGN KEY 
    ( 
     TRANSFERENCIA_ID_forma_pago
    ) 
    REFERENCES TRANSFERENCIA 
    ( 
     ID_forma_pago 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE MUNICIPIO 
    ADD CONSTRAINT MUNICIPIO_PROVINCIA_FK FOREIGN KEY 
    ( 
     PROVINCIA_ID_provincia
    ) 
    REFERENCES PROVINCIA 
    ( 
     ID_provincia 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE NOMINA 
    ADD CONSTRAINT NOMINA_EMPLEADO_FK FOREIGN KEY 
    ( 
     EMPLEADO_ID_empleado
    ) 
    REFERENCES EMPLEADO 
    ( 
     ID_empleado 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE PAGO 
    ADD CONSTRAINT PAGO_CLIENTE_FK FOREIGN KEY 
    ( 
     CLIENTE_ID_cliente
    ) 
    REFERENCES CLIENTE 
    ( 
     ID_cliente 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE PAGO 
    ADD CONSTRAINT PAGO_FORMA_PAGO_FK FOREIGN KEY 
    ( 
     FORMA_PAGO_ID_forma_pago
    ) 
    REFERENCES FORMA_PAGO 
    ( 
     ID_forma_pago 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE RESERVA 
    ADD CONSTRAINT RESERVA_CLIENTE_FK FOREIGN KEY 
    ( 
     CLIENTE_ID_cliente
    ) 
    REFERENCES CLIENTE 
    ( 
     ID_cliente 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE TARJETA 
    ADD CONSTRAINT TARJETA_FORMA_PAGO_FK FOREIGN KEY 
    ( 
     ID_forma_pago
    ) 
    REFERENCES FORMA_PAGO 
    ( 
     ID_forma_pago 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE TRANSFERENCIA 
    ADD CONSTRAINT TRANSFERENCIA_FORMA_PAGO_FK FOREIGN KEY 
    ( 
     ID_forma_pago
    ) 
    REFERENCES FORMA_PAGO 
    ( 
     ID_forma_pago 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO



-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                            17
-- CREATE INDEX                             0
-- ALTER TABLE                             37
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE DATABASE                          0
-- CREATE DEFAULT                           0
-- CREATE INDEX ON VIEW                     0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE ROLE                              0
-- CREATE RULE                              0
-- CREATE SCHEMA                            0
-- CREATE SEQUENCE                          0
-- CREATE PARTITION FUNCTION                0
-- CREATE PARTITION SCHEME                  0
-- 
-- DROP DATABASE                            0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
