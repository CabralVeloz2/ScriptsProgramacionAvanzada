

-- ACID ATOMICITY CONSISTENCY ISOLATION DURABILITY
-- A ATOMICIDAD    TODAS LAS OPERACIONES DE LA TRANSACCIÓN O NINGUNA


-- TRANSACCIONES IMPLICITAS - EXPLICITAS
-- BEGIN TRAN - COMMIT - ROLLBACK
-- UNION ALL
-- TRY-CATCH

-- DEMOSTRACIÓN DE QUE EN OCASIONES USAR TRANSACCIONES IMPLICITAS EN LUGAE DE EXPLICITAS PUEDE PROVOCAR ERRORE

-- NOTA
-- MANTENGO EL EJEMPLO CON INSERT
-- SERÍA MÁS CORRECTO USAR UPDATE 
-- CAMBIAR EJEMPLO PARA USAR UPDATE EN VUESTRA DEMOSTRACIÓN

USE master
GO
DROP DATABASE IF EXISTS Explicita_JCV
GO
CREATE DATABASE Explicita_JCV
GO
USE Explicita_JCV
GO

DROP TABLE IF EXISTS Disponible
GO
CREATE TABLE dbo.Disponible
(
    ID INT PRIMARY KEY,
    Cantidad INT CHECK (Cantidad <= 20),
    Descripcion VARCHAR(100),
    TransactionDate DATE
);
GO
DROP TABLE IF EXISTS Ocupado
GO
CREATE TABLE dbo.Ocupado
(
    ID INT PRIMARY KEY,
    Cantidad INT CHECK (Cantidad <= 20),
    Descripcion VARCHAR(100),
    TransactionDate DATE
);
GO
-- INSERTO EN MI CUENTA CORRIENTE

INSERT INTO dbo.Disponible
(
    ID,
    Cantidad,
    Descripcion,
    TransactionDate
)
VALUES
(1, 20, 'Primeros campings disponibles', GETDATE());
GO

-- INSERTO EN MI CUENTA DE AHORRO

INSERT INTO dbo.Ocupado
(
    ID,
    Cantidad,
    Descripcion,
    TransactionDate
)
VALUES
(1, 20, 'Primeros campings ocupados', GETDATE());
GO

-- LISTADO FILAS (PODIA HACERLO CON 2 SELECT)
--SELECT SUM(Amount) AS [Total], -- SELECT Statement
--       'Savings' AS [AccountType]
--FROM dbo.Savings
--GO

--Total	AccountType
--100.00	Savings

-- UNION ALL ME SALE EL RESULTADO COMO SI ESTUVIERA EN UNA ÚNICA TABLA

SELECT SUM(Cantidad) AS [Total], -- SELECT Statement
       'Disponible' AS [Estado]
FROM dbo.Disponible
UNION ALL
SELECT SUM(Cantidad) AS [Total],
       'Ocupado' AS [Estado]
FROM dbo.Ocupado;
GO

--Total	Estado
--20	Disponible
--20	Ocupado

-- CONFIRMACIÓN IMPLICITA DE LA TRANSACCIÓN USA MENOS CODIGO 
-- PERO A VECES PUEDE PROVOCAR RESULTADOS INCORRECTOS

-- Auto-commit is about as simple as it gets. 
-- It's going to require the least amount of code. 
-- However, it does have drawbacks. 

-- ALGO VA MAL CON EL PRIMER INSERT ENTONCES NO QUIERES QUE SE EJECUTE EL 2 INSERT

--The primary one we'll focus on here is if something goes wrong with the first insert statement 
-- and you don't want the second insert statement to execute, you're out of luck. 
-- Let's look at this in action. 
-- VOY A INTENTAR MOVER 100 DESDE MI CUENTA DE AHORRO A MI CUENTA CORRIENTE
--In the example below, I'm moving $100 from my savings account into my checking.  
-- See the following example:

-- NOTA : EJECUTO LAS 2 INSERCIONES JUNTAS
-- PERO LA PRIMERA FALLA

-- INTENTO RETIRAR 25 CAMPING DISPONIBLES
INSERT INTO dbo.Disponible
(
    ID,
    Cantidad,
    Descripcion,
    TransactionDate
)
VALUES
(2, -25, 'Reserva de 25 campings', GETDATE());
GO
-- INTENTO CARGAR 5 CAMPING QUE ESTABAN DISPONIBLES

INSERT INTO dbo.Ocupado
(
    ID,
    Cantidad,
    Descripcion,
    TransactionDate
)
VALUES
(2, 25, 'Se han reservado 25 camping', GETDATE());
GO

--(1 row affected)
--Msg 547, Level 16, State 0, Line 130
--Instrucción INSERT en conflicto con la restricción CHECK 'CK__Ocupado__Cantida__47DBAE45'. El conflicto ha aparecido en la base de datos 'Explicita_JCV', tabla 'dbo.Ocupado', column 'Cantidad'.

-- NOS DA ERROR AL INTENTAR INSERTAR EN table 'EXPLITRAN.dbo.Checking'
-- SIN EMBARGO LA INSERCIÓN EN LA TABLA DE AHORRO "FUNCIONA"
-- Notice that the first insert SQL command will fail.
-- I hope my savings account isn't missing $100. However, I would be wrong.

-- Compruebo
SELECT SUM(Cantidad) AS [Total], 
       'Disponible' AS [Estado]
FROM dbo.Disponible
UNION ALL
SELECT SUM(Cantidad) AS [Total],
       'Ocupado' AS [Estado]
FROM dbo.Ocupado;
GO

--Total	Estado
---5	Disponible
--20	Ocupado

-- CONFIRMANDO CON SELECT INDIVIDUALES
SELECT * FROM Disponible
GO
--ID	Cantidad	Descripcion	TransactionDate
--1	20	Primeros campings disponibles	2023-12-05
--2	-25	Reserva de 25 campings	2023-12-05


SELECT SUM(Cantidad) AS [Total], 'Disponible' AS [ESTADO]
FROM dbo.Disponible
GO
--Total	ESTADO
---5	Disponible


SELECT * FROM Ocupado
GO
--ID	Cantidad	Descripcion	TransactionDate
--1	20	Primeros campings ocupados	2023-12-05

SELECT SUM(Cantidad) AS [Total],
       'Ocupado' AS [Estado]
FROM dbo.Ocupado;
GO

--Total	Estado
--20	Ocupado

----------------------------------------------------
--------------------------------------------------------

-- TRANSACCIONES EXPLICITAS
-- MANTENER ACID
-- ATOMICITY CONSISTENCY ISOLATION DURABILITY
-- Nuestro Caso ATOMICITY
-- ATOMICITY SE TIENE QUE EJECUTAR TODAS LAS OPERACIONES DE LA TRANSACCIÓN O NINGUN
-- BEGIN - END TRANSACTION
-- COMMIT TRANSACTION		confirmar
-- ROLLBACK TRANSACTION		deshacer

-- PUEDES CONTROLAR EXCEPCIONES Y/O ERRORES CON TRY...CATCH
-- EN LUGAR DE TRY...CATCH PUEDES USAR SET XACT_ABORT ON
-- Hace ROLLBACK SI SE PRODUCE UNA EXCEPCIÓN
-- 
--Explicit Transaction in T-SQL
--With explicit transactions, you tell SQL Server to start a transaction by issuing the BEGIN TRANSACTION
-- syntax. Once your statement finishes, you can ROLLBACK or COMMIT. 
-- Ideally, you would wrap the transaction in a TRY...CATCH block. 
--You can roll back the transaction and raise the exception if an error occurs.

--If you don't want to deal with a TRY...CATCH, 
-- you can SET XACT_ABORT ON. 
-- This command is handy because it will roll back the transaction if an exception occurs.
-- By default, XACT_ABORT is off.

--Suppose you repeat the example from above by using an explicit transaction and XACT_ABORT.
-- The entire transaction will roll back after the first exception occurs, which is the expected result. 
-- In my opinion, this is the primary reason to use explicit transactions.

-- REPETIMOS EJEMPLO USANDO TRANSACCIONES EXPLICITAS

-- NOTA : EJECUTAR DESDE EL PRINCIPIO (DESDE GENERAR LAS TABLAS PARA TENET LOS MISMOS VALORES)
DROP TABLE IF EXISTS Ocupado
GO
CREATE TABLE dbo.Ocupado
(
    ID INT NOT NULL,
    Cantidad INT CHECK (Cantidad <= 20),
    Descripcion VARCHAR(100) NOT NULL,
    TransactionDate DATE NOT NULL
);
GO

DROP TABLE IF EXISTS Disponible
GO
CREATE TABLE dbo.Disponible
(
    ID INT NOT NULL,
    Cantidad INT CHECK (Cantidad <= 20),
    Descripcion VARCHAR(100) NOT NULL,
    TransactionDate DATE NOT NULL
);
GO

-- INSERTO EN MI CUENTA CORRIENTE

INSERT INTO dbo.Disponible
(
    ID,
    Cantidad,
    Descripcion,
    TransactionDate
)
VALUES
(1, 20, 'Primeros campings disponibles', GETDATE());
GO

-- INSERTO EN MI CUENTA DE AHORRO

INSERT INTO dbo.Ocupado
(
    ID,
    Cantidad,
    Descripcion,
    TransactionDate
)
VALUES
(1, 20, 'Primeros campings ocupados', GETDATE());
GO




-- UNION ALL ME SALE EL RESULTADO COMO SI ESTUVIERA EN UNA ÚNICA TABLA
SELECT SUM(Cantidad) AS [Total], -- SELECT Statement
       'Disponible' AS [Estado]
FROM dbo.Disponible
UNION ALL
SELECT SUM(Cantidad) AS [Total],
       'Ocupado' AS [Estado]
FROM dbo.Ocupado;
GO
--Total	Estado
--20	Disponible
--20	Ocupado

SET XACT_ABORT ON;

BEGIN TRANSACTION; -- EMPIEZA TRANSACCIÓN
-- MISMAS INSERCIONES
INSERT INTO dbo.Disponible
(
    ID,
    Cantidad,
    Descripcion,
    TransactionDate
)
VALUES
(2, -25, 'Retiro 5 campings disponibles', GETDATE());

INSERT INTO dbo.Ocupado
(
    ID,
    Cantidad,
    Descripcion,
    TransactionDate
)
VALUES
(2, 25, 'Añado 5 campings ocupados', GETDATE());

COMMIT TRANSACTION;

--(1 row affected)
--Msg 547, Level 16, State 0, Line 305
--Instrucción INSERT en conflicto con la restricción CHECK 'CK__Ocupado__Cantida__403A8C7D'. El conflicto ha aparecido en la base de datos 'Explicita_JCV', tabla 'dbo.Ocupado', column 'Cantidad'.


SELECT SUM(Cantidad) AS [Total], -- SELECT Statement
       'Disponible' AS [Estado]
FROM dbo.Disponible
UNION ALL
SELECT SUM(Cantidad) AS [Total],
       'Ocupado' AS [Estado]
FROM dbo.Ocupado;
GO

--Total	Estado
--20	Disponible
--20	Ocupado

-- AL NO FUNCIONAR EL PRIMER INSERT LA TRANSACCIÓN (ATOMICITY) PROVOCA UN ROLLBACK.
-- VALOR EN LAS 2 TABLAS NO CAMBIA


--The money stays in my savings account until I shorten the message and make it to the store.

--------------------------
----------------------------
-- USANDO UPDATE

-- DESDE EL PRINCIPIO
DROP TABLE IF EXISTS Disponible
GO
CREATE TABLE dbo.Disponible
(
    ID INT NOT NULL,
    Cantidad INT CHECK (Cantidad <= 20),
    Descripcion VARCHAR(100) NOT NULL,
    TransactionDate DATE NOT NULL
);
GO

DROP TABLE IF EXISTS Ocupado
GO
CREATE TABLE dbo.Ocupado
(
    ID INT NOT NULL,
    Cantidad INT CHECK (Cantidad <= 20),
    Descripcion VARCHAR(100) NOT NULL,
    TransactionDate DATE NOT NULL
);
GO
-- INSERTO EN DISPONIBLE

INSERT INTO dbo.Disponible
(
    ID,
    Cantidad,
    Descripcion,
    TransactionDate
)
VALUES
(1, 20, 'Starting', GETDATE());
GO

-- INSERTO EN MI CUENTA DE AHORRO

INSERT INTO dbo.Ocupado
(
    ID,
    Cantidad,
    Descripcion,
    TransactionDate
)
VALUES
(1, 20, 'Starting Ocupado', GETDATE());
GO

-- LISTADO FILAS (PODIA HACERLO CON 2 SELECT)
--SELECT SUM(Amount) AS [Total], -- SELECT Statement
--       'Savings' AS [AccountType]
--FROM dbo.Savings
--GO

--Total	AccountType
--100.00	Savings

-- UNION ALL ME SALE EL RESULTADO COMO SI ESTUVIERA EN UNA ÚNICA TABLA

SELECT SUM(Cantidad) AS [Total], -- SELECT Statement
       'Disponible' AS [Estado]
FROM dbo.Disponible
UNION ALL
SELECT SUM(Cantidad) AS [Total],
       'Ocupado' AS [Estado]
FROM dbo.Ocupado;
GO

--Total	Estado
--20	Disponible
--20	Ocupado


-- TRANSACCIÓN IMPLICITA
SELECT *
FROM dbo.Disponible
GO

--Cantidad	Descripcion	TransactionDate
--20	Starting	2023-12-05

SELECT *
FROM Ocupado
GO

--Cantidad	Descripcion	TransactionDate
--20	Starting Ocupado	2023-12-05



-- EJECUTAR LOS 2 UPDATES JUNTOS

UPDATE Disponible
SET  Cantidad=Cantidad-10,Descripcion='Resto 10 campings',
    TransactionDate = GETDATE()
WHERE ID = 1

-- ESTE UPDATE VA A FALLAR

UPDATE Ocupado
SET  Cantidad=Cantidad+25,Descripcion='añado 25 campings',
    TransactionDate = GETDATE()
WHERE ID = 1

--(1 row affected)
--Msg 547, Level 16, State 0, Line 443
--Instrucción UPDATE en conflicto con la restricción CHECK 'CK__Ocupado__Cantida__628FA481'. El conflicto ha aparecido en la base de datos 'Explicita_JCV', tabla 'dbo.Ocupado', column 'Cantidad'.


-- COMPRUEBO
SELECT SUM(Cantidad) AS [Total], -- SELECT Statement
       'Disponible' AS [Estado]
FROM dbo.Disponible
UNION ALL
SELECT SUM(Cantidad) AS [Total],
       'Ocupado' AS [Estado]
FROM dbo.Ocupado;
GO

--Total	Estado
--10	Disponible
--20	Ocupado




-- TRANSACCIÓN EXPLICITA

SET XACT_ABORT ON;-- CONTROLAR EXCEPCIONES
BEGIN TRANSACTION; -- EMPIEZA TRANSACCIÓN
-- MISMAS ACTUALIZACIONES
UPDATE Disponible
SET  Cantidad=Cantidad-10,Descripcion='Resto 10 campings',
    TransactionDate = GETDATE()
WHERE ID = 1
-- ESTE UPDATE VA A FALLAR
UPDATE Ocupado
SET  Cantidad=Cantidad+25,Descripcion='añado 25 campings',
    TransactionDate = GETDATE()
WHERE ID = 1
COMMIT TRAN

-- TAMBIEN DIO ERROR
(1 row affected)
Msg 547, Level 16, State 0, Line 480
Instrucción UPDATE en conflicto con la restricción CHECK 'CK__Ocupado__Cantida__628FA481'. El conflicto ha aparecido en la base de datos 'Explicita_JCV', tabla 'dbo.Ocupado', column 'Cantidad'.

-- COMPRUEBO
SELECT SUM(Cantidad) AS [Total], -- SELECT Statement
       'Disponible' AS [Estado]
FROM dbo.Disponible
UNION ALL
SELECT SUM(Cantidad) AS [Total],
       'Ocupado' AS [Estado]
FROM dbo.Ocupado;
GO
--Total	Estado
--20	Disponible
--20	Ocupado
-- NO CAMBIA






-- USANDO TRY - CATCH - THROW

-- DESDE EL PRINCIPIO

DROP TABLE IF EXISTS Disponible
GO
CREATE TABLE dbo.Disponible
(
    ID INT NOT NULL,
    Cantidad INT CHECK (Cantidad <= 20),
    Descripcion VARCHAR(100) NOT NULL,
    TransactionDate DATE NOT NULL
);
GO

DROP TABLE IF EXISTS Ocupado
GO
CREATE TABLE dbo.Ocupado
(
    ID INT NOT NULL,
    Cantidad INT CHECK (Cantidad <= 20),
    Descripcion VARCHAR(100) NOT NULL,
    TransactionDate DATE NOT NULL
);
GO

-- INSERTO EN DISPONIBLE
INSERT INTO dbo.Disponible
(
    ID,
    Cantidad,
    Descripcion,
    TransactionDate
)
VALUES
(1, 20, 'Starting', GETDATE());
GO

-- INSERTO EN OCUPADO
INSERT INTO dbo.Ocupado
(
    ID,
    Cantidad,
    Descripcion,
    TransactionDate
)
VALUES
(1, 20, 'Starting Ocupado', GETDATE());
GO

-- LISTADO FILAS (PODIA HACERLO CON 2 SELECT)
--SELECT SUM(Amount) AS [Total], -- SELECT Statement
--       'Savings' AS [AccountType]
--FROM dbo.Savings
--GO

--Total	AccountType
--100.00	Savings

-- UNION ALL ME SALE EL RESULTADO COMO SI ESTUVIERA EN UNA ÚNICA TABLA

SELECT SUM(Cantidad) AS [Total], -- SELECT Statement
       'Disponible' AS [Estado]
FROM dbo.Disponible
UNION ALL
SELECT SUM(Cantidad) AS [Total],
       'Ocupado' AS [Estado]
FROM dbo.Ocupado;
GO
--Total	Estado
--20	Disponible
--20	Ocupado


BEGIN TRY  
BEGIN TRANSACTION; -- EMPIEZA TRANSACCIÓN
-- MISMAS INSERCIONES
INSERT INTO dbo.Disponible
(
    ID,
    Cantidad,
    Descripcion,
    TransactionDate
)
VALUES
(2, -25, 'Taking money out of my savings account.', GETDATE());

INSERT INTO dbo.Ocupado
(
    ID,
    Cantidad,
    Descripcion,
    TransactionDate
)
VALUES
(2, 20, 'Taking money out of my account for a copy of a new NES games, sorry dad! I will replace it after I get a job.', GETDATE());

COMMIT TRANSACTION; 
END TRY  
BEGIN CATCH  
    PRINT 'Truncated value:';  
    THROW;  
END CATCH;  
 GO 


 
--(1 row affected)

--(0 rows affected)
--Truncated value:
--Msg 2628, Level 16, State 1, Line 597
--Los datos binarios o de la cadena se truncan en la columna "Descripcion" de la tabla "Explicita_JCV.dbo.Ocupado". Valor truncado: "Taking money out of my account for a copy of a new NES games, sorry dad! I will replace it after I g".

-- COMPROBACIÓN

SELECT SUM(Cantidad) AS [Total], -- SELECT Statement
       'Disponible' AS [Estado]
FROM dbo.Disponible
UNION ALL
SELECT SUM(Cantidad) AS [Total],
       'Ocupado' AS [Estado]
FROM dbo.Ocupado;
GO

-- NO EJECUTA . ATOMICIDAD (TODAS O NINGUNA)
--Total	Estado
--20	Disponible
--20	Ocupado