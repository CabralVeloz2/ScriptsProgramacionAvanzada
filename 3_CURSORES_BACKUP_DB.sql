--
-- INCLUDE ACTUAL EXECUTION PLAN

USE CampingJCV2
GO
DECLARE Cliente2_Cursor CURSOR FOR  
	SELECT ID_cliente, Nombre
	FROM Cliente2;  
OPEN Cliente2_Cursor;  
FETCH NEXT FROM Cliente2_Cursor;  
WHILE @@FETCH_STATUS = 0  
   BEGIN  
	   FETCH NEXT FROM Cliente2_Cursor  
   END;  
CLOSE Cliente2_Cursor;  
DEALLOCATE Cliente2_Cursor;  
GO



--
--SQL Server Cursor Components
--Based on the example above, cursors include these components:

--DECLARE statements - Declare variables used in the code block
--SET\SELECT statements - Initialize the variables to a specific value
--DECLARE CURSOR statement - Populate the cursor with values that will be evaluated
--NOTE - There are an equal number of variables in the DECLARE CURSOR FOR statement as there are in the SELECT statement.  This could be 1 or many variables and associated columns.
--OPEN statement - Open the cursor to begin data processing
--FETCH NEXT statements - Assign the specific values from the cursor to the variables
--NOTE - This logic is used for the initial population before the WHILE statement and then again during each loop in the process as a portion of the WHILE statement
--WHILE statement - Condition to begin and continue data processing
--BEGIN...END statement - Start and end of the code block
--NOTE - Based on the data processing multiple BEGIN...END statements can be used
--Data processing - In this example, this logic is to backup a database to a specific path and file name, but this could be just about any DML or administrative logic
--CLOSE statement - Releases the current data and associated locks, but permits the cursor to be re-opened
--DEALLOCATE statement - Destroys the cursor

-- Backup 
USE master
GO

DECLARE @name VARCHAR(50) -- database name 
DECLARE @path VARCHAR(256) -- path for backup files 
DECLARE @fileName VARCHAR(256) -- filename for backup 
DECLARE @fileDate VARCHAR(20) -- used for file name 

SET @path = 'C:\BackupJCV\' 

SELECT @fileDate = CONVERT(VARCHAR(20),GETDATE(),112) 

DECLARE db_cursor CURSOR FOR 
SELECT name 
FROM MASTER.dbo.sysdatabases 
WHERE name NOT IN ('master','model','msdb','tempdb') 

OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @name  

WHILE @@FETCH_STATUS = 0  
BEGIN  
      SET @fileName = @path + @name + '_' + @fileDate + '.BAK' 
      BACKUP DATABASE @name TO DISK = @fileName 

      FETCH NEXT FROM db_cursor INTO @name 
END 

CLOSE db_cursor  
DEALLOCATE db_cursor 

-------

-- 
--Se han procesado 25376 páginas para la base de datos 'AdventureWorks2019', archivo 'AdventureWorks2019' en el archivo 1.
--Se han procesado 1 páginas para la base de datos 'AdventureWorks2019', archivo 'AdventureWorks2019_log' en el archivo 1.
--BACKUP DATABASE procesó correctamente 25377 páginas en 8.441 segundos (23.486 MB/s).
--Se han procesado 616 páginas para la base de datos 'Northwind', archivo 'Northwind' en el archivo 1.
--Se han procesado 1 páginas para la base de datos 'Northwind', archivo 'Northwind_log' en el archivo 1.
--BACKUP DATABASE procesó correctamente 617 páginas en 0.249 segundos (19.333 MB/s).
--Se han procesado 704 páginas para la base de datos 'pubs', archivo 'pubs' en el archivo 1.
--Se han procesado 1 páginas para la base de datos 'pubs', archivo 'pubs_log' en el archivo 1.
--BACKUP DATABASE procesó correctamente 705 páginas en 0.389 segundos (14.142 MB/s).
--Se han procesado 952 páginas para la base de datos 'WideWorldImporters-Full', archivo 'WideWorldImporters-Full_Data' en el archivo 1.
--Se han procesado 46424 páginas para la base de datos 'WideWorldImporters-Full', archivo 'USERDATA_53CB83A8' en el archivo 1.
--Se han procesado 1 páginas para la base de datos 'WideWorldImporters-Full', archivo 'WWI_InMemory_Data_68CCD076' en el archivo 1.
--Se han procesado 10438 páginas para la base de datos 'WideWorldImporters-Full', archivo 'WideWorldImporters-Full_Log' en el archivo 1.
--BACKUP DATABASE procesó correctamente 57815 páginas en 16.641 segundos (27.142 MB/s).
--Se han procesado 464 páginas para la base de datos 'CampingJCV', archivo 'CampingJCV' en el archivo 1.
--Se han procesado 1 páginas para la base de datos 'CampingJCV', archivo 'CampingJCV_log' en el archivo 1.
--BACKUP DATABASE procesó correctamente 465 páginas en 0.264 segundos (13.736 MB/s).
--Se han procesado 640 páginas para la base de datos 'CampingJCV2', archivo 'CampingJCV2' en el archivo 1.
--Se han procesado 1 páginas para la base de datos 'CampingJCV2', archivo 'CampingJCV2_log' en el archivo 1.
--BACKUP DATABASE procesó correctamente 534 páginas en 0.481 segundos (8.657 MB/s).
--Se han procesado 648 páginas para la base de datos 'CampingJCV_PS', archivo 'CampingJCV_PS' en el archivo 1.
--Se han procesado 1 páginas para la base de datos 'CampingJCV_PS', archivo 'CampingJCV_PS_log' en el archivo 1.
--BACKUP DATABASE procesó correctamente 649 páginas en 0.453 segundos (11.178 MB/s).
--Se han procesado 672 páginas para la base de datos 'db_smo', archivo 'db_smo' en el archivo 1.
--Se han procesado 1 páginas para la base de datos 'db_smo', archivo 'db_smo_log' en el archivo 1.
--BACKUP DATABASE procesó correctamente 673 páginas en 0.516 segundos (10.177 MB/s).
--Se han procesado 416 páginas para la base de datos 'Daniel1_PS', archivo 'Daniel1_PS' en el archivo 1.
--Se han procesado 1 páginas para la base de datos 'Daniel1_PS', archivo 'Daniel1_PS_log' en el archivo 1.
--BACKUP DATABASE procesó correctamente 417 páginas en 0.273 segundos (11.910 MB/s).

--Completion time: 2023-12-05T03:36:25.5918289+01:00
































USE TEMPDB
GO
CREATE TABLE #ITEMS (ITEM_ID uniqueidentifier NOT NULL, ITEM_DESCRIPTION VARCHAR(250) NOT NULL)
INSERT INTO #ITEMS
VALUES
(NEWID(), 'This is a wonderful car'),
(NEWID(), 'This is a fast bike'),
(NEWID(), 'This is a expensive aeroplane'),
(NEWID(), 'This is a cheap bicycle'),
(NEWID(), 'This is a dream holiday')
GO
SELECT * FROM #ITEMS
GO

-- Starting Cursor

DECLARE @ITEM_ID uniqueidentifier  -- Here we create a variable that will contain the ID of each row.
DECLARE ITEM_CURSOR CURSOR  -- Here we prepare the cursor and give the select statement to iterate through
FOR
SELECT ITEM_ID
FROM #ITEMS
 
OPEN ITEM_CURSOR -- This charges the results to memory
 
FETCH NEXT FROM ITEM_CURSOR INTO @ITEM_ID -- We fetch the first result
 
WHILE @@FETCH_STATUS = 0 --If the fetch went well then we go for it
BEGIN
 
SELECT ITEM_DESCRIPTION -- Our select statement (here you can do whatever work you wish)
FROM #ITEMS
WHERE ITEM_ID = @ITEM_ID -- In regards to our latest fetched ID
 
FETCH NEXT FROM ITEM_CURSOR INTO @ITEM_ID -- Once the work is done we fetch the next result
 
END
-- We arrive here when @@FETCH_STATUS shows there are no more results to treat
CLOSE ITEM_CURSOR  
DEALLOCATE ITEM_CURSOR -- CLOSE and DEALLOCATE remove the data from memory and clean up the process
GO
