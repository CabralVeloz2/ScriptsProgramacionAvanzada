-- TABLA SP VISTA
-- USUARIO ROL PERMISOS GRANT IMPERSONATE
-- IMPORT ARCHIVO DE TEXTO PLANO

-- Problem
-- I understand that, through the use of SQL Server ownership chaining, I can restrict access to 
-- the underlying tables with data while still allowing applications to query and modify data.
-- How does this work? Are there any examples which I might be able to use in my own code?

-- Solution
-- Ownership chaining is a great way to prevent direct access to the base tables. 
-- If you're not familiar with ownership chaining, in SQL Server, when one object refers to another object,
-- and both objects have the same owner, SQL Server will only look at the security on the first object.
-- For instance, if a stored procedure references a table, SQL Server will only check security 
-- on the stored procedure and not the table, as long as both objects have the same owner.

-- This allows us to control access through stored procedures and views and never give users 
-- direct access to the base tables. This effectively allows us to hide columns, control how data 
-- is queried and modified, and even perform business rules checks or complex data integrity rules. 
-- Let's take a look at some examples where this comes in handy.


-- https://www.mssqltips.com/sqlservertip/6545/implementing-sql-server-security-with-stored-procedures-and-views/

-- OWNERSHIP CHAINING
-- Implementing SQL Server Security with Stored Procedures and Views


DROP DATABASE IF EXISTS CampingJCV2
GO
CREATE DATABASE CampingJCV2;
GO 
 
USE CampingJCV2;
GO

DROP SCHEMA IF EXISTS JC
GO
CREATE SCHEMA JC;
GO 

DROP TABLE IF EXISTS JC.Cliente2
GO
CREATE TABLE JC.Cliente2
(
   ID CHAR(2),
   Nombre VARCHAR(50),
   Apellido VARCHAR(50),
   DNI CHAR(9) -- No queremos que los Becarios vean esto
);
GO 

-- Vemos IMPORT / EXPORT
-- GUI IMPORT FLAT FILE Employees
-- Creamos con NOTEPAD (o cualquier otro Editor de Texto) este fichero
-- Employees.txt
-- Tasks Import in GUI

SELECT * FROM JC.Cliente2
GO

--ID	Nombre	Apellido	DNI
--1 	Jose	Cabral		111111111
--2 	Ivan	Centeno		222222222
--3 	Diana	Alvarez		333333333
     

DROP VIEW IF EXISTS JC.LookupCliente2
GO
CREATE VIEW JC.LookupCliente2
AS
SELECT 
   ID, Nombre, Apellido
FROM JC.Cliente2;
GO

DROP ROLE IF EXISTS JCsupervisor
GO
CREATE ROLE JCsupervisor;
GO 

GRANT SELECT ON JC.LookupCliente2 TO JCsupervisor;
GO 

DROP USER IF EXISTS IvanCenteno
GO
CREATE USER IvanCenteno WITHOUT LOGIN;
GO 

ALTER ROLE JCsupervisor
ADD MEMBER IvanCenteno;
GO 

-- Esto Funciona
-- Usuaria tiene permisos sobre la Vista
-- No tiene permisos para ejecutar SELECT sobre la Tabla
-- El concepto de Cadena de Propiedad provoca esta posibilidad
-- This will work
-- JaneDoe has SELECT against the view
-- She does not have SELECT against the table
-- Ownership chaining makes this happen


-- USANDO LA VISTA
-- Impersona
EXECUTE AS USER = 'IvanCenteno';
GO 

SELECT * FROM JC.LookupCliente2;
GO 

PRINT USER
GO

-- IvanCenteno


REVERT;
GO 

PRINT USER
GO

-- dbo

-- USANDO SELECT DIRECTAMENTE SOBRE LA TABLA
-- NO FUNCIONARA
-- This will not work
-- Since JaneDoe doesn't have SELECT permission
-- She cannot query the table in this way
EXECUTE AS USER = 'IvanCenteno';
GO 

SELECT * FROM JC.Cliente2;
GO 

--Msg 229, Level 14, State 5, Line 134
--Se denegó el permiso SELECT en el objeto 'Cliente2', base de datos 'CampingJCV2', esquema 'JC'.

PRINT USER
GO
REVERT;
GO
PRINT USER
GO


-- DEMOSTRACIÓN USANDO SP
-- STORED PROCEDURE (PROCEDIMIENTO ALMACENADO)

CREATE OR ALTER PROC JC.InsertNewCustomer
	-- INPUT PARAMETERS
   @ID INT,
   @Nombre VARCHAR(50),
   @Apellido VARCHAR(50),
   @DNI CHAR(9)
AS
BEGIN
   INSERT INTO JC.Cliente2
   ( ID, Nombre, Apellido, DNI )
   VALUES
   ( @ID, @Nombre, @Apellido, @DNI );
END;
GO 

DROP ROLE IF EXISTS  JCseguridad
GO
CREATE ROLE JCseguridad;
GO 

GRANT EXECUTE ON SCHEMA::[JC] TO JCseguridad;
GO 

-- CREO OTRO USUARIO PARA DEMOSTRACIÓN
DROP USER IF EXISTS VictorPerez
GO
CREATE USER VictorPerez WITHOUT LOGIN;
GO 

-- AÑADO AL USUARIO AL ROL
ALTER ROLE JCseguridad
ADD MEMBER VictorPerez;
GO

-- FALLARA PORQUE EL USUARIO NO PUEDE INSERTAR DIRECTAMENTE EN LA TABLA
-- This will fail as JohnSmith doesn't have the ability to
-- insert directly into the table.

EXECUTE AS USER = 'VictorPerez';
GO 

INSERT INTO JC.Cliente2
   ( ID, Nombre, Apellido, DNI )
   -- (GivenName, Surname, SSN ) con IDENTITY
   VALUES
   (4, 'Juan', 'Lopez', '444444444' );
GO 

--Msg 229, Level 14, State 5, Line 192
--Se denegó el permiso INSERT en el objeto 'Cliente2', base de datos 'CampingJCV2', esquema 'JC'.


REVERT;
GO

-- This will succeed because JohnSmith can execute any 
-- stored procedure in the HR schema. An ownership chain forms,
-- allowing the insert to happen.

--	DELETE HR.Employee 
--	WHERE EmployeeID = 4
--	GO

-- SIN EMBARGO, SI QUE PODRA INSERTAR USANDO EL SP

EXECUTE AS USER = 'VictorPerez';
GO 

EXEC JC.InsertNewCustomer 
      @ID = 4, 
      @Nombre = 'Juan', 
      @Apellido = 'Lopez', 
      @DNI = '444444444';
GO 
-- (1 row affected)

PRINT USER
GO
-- VictorPerez

-- SOLO PARA DEMOSTRAR QUE EL OBJETO Employee ES DIFERENTE DE HR.Employee 
SELECT * FROM Cliente2
GO
 
-- El nombre de objeto 'Cliente2' no es válido.
-- WRONG SCHEMA dbo

-- ESTO NO FUNCIONARA EL USUARIO TAMPOCO TIENE PERMISOS DE CONSULTA SOBRE LA TABLA

SELECT * FROM JC.Cliente2;
GO 

--Msg 229, Level 14, State 5, Line 240
--Se denegó el permiso SELECT en el objeto 'Cliente2', base de datos 'CampingJCV2', esquema 'JC'.

REVERT;
GO

-- COMPROBANDO QUE INSERT ANTERIOR FUNCIONO
-- Verifying the insert
SELECT ID, Nombre, Apellido, DNI 
FROM JC.Cliente2;
GO 

--ID	Nombre	Apellido	DNI
--1 	Jose	Cabral		111111111
--2 	Ivan	Centeno		222222222
--3 	Diana	Alvarez		333333333
--4 	Juan	Lopez		444444444   