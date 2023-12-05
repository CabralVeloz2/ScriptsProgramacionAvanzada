-- Simple Image Import and Export Using T-SQL for SQL Server
-- https://www.mssqltips.com/sqlservertip/4963/simple-image-import-and-export-using-tsql-for-sql-server/

-- IMPORTAR - EXPORTAR IMAGEN A SQL SERVER

-- SIN USAR FILESTREAM
-- PictureData VARBINARY (max)
-- STORED PROCEDURE
-- ALTER SERVER ROLE [bulkadmin] ADD MEMBER 
-- OPENROWSET function combined with the BULK option
-- the statement is executed dynamically using the SQL EXEC function using dynamic SQL
-- CONTROL DE EXCEPCIONES TRY - CATCH
-- SQL Server's OLE Automation Procedures sp_OAMethod system procedure.
-- xp_cmdshell 


USE tempdb
GO
DROP TABLE IF EXISTS PicturesJCV
GO
CREATE TABLE Logo_camping (
     pictureName NVARCHAR(40) PRIMARY KEY NOT NULL
   , picFileName NVARCHAR (100)
   , PictureData VARBINARY (max)
   )
GO
USE master
GO
EXEC sp_configure 'show advanced options', 1; 
GO 
RECONFIGURE; 
GO 
--RECONFIGURE WITH OVERRIDE; 
--GO
EXEC sp_configure 'Ole Automation Procedures', 1; 
GO 
RECONFIGURE; 
GO

--ALTER SERVER ROLE [bulkadmin] ADD MEMBER [Enter here the Login Name that will execute the Import] 
--GO  

ALTER SERVER ROLE [bulkadmin] ADD MEMBER [DESKTOP-V8CLLV8\Daniel]
GO

USE tempdb
GO
-- Image Import Stored Procedure
-- IMPORTAR IMAGENES

CREATE OR ALTER PROCEDURE dbo.importar_imagenes_JCV (
     @PicName NVARCHAR (100)
   , @ImageFolderPath NVARCHAR (1000)
   , @Filename NVARCHAR (1000)
   )
AS
BEGIN
   DECLARE @Path2OutFile NVARCHAR (2000);
   DECLARE @tsql NVARCHAR (2000);
   SET NOCOUNT ON
   SET @Path2OutFile = CONCAT (
         @ImageFolderPath
         ,'\'
         , @Filename
         );
   SET @tsql = 'insert into Logo_camping (pictureName, picFileName, PictureData) ' +
               ' SELECT ' + '''' + @PicName + '''' + ',' + '''' + @Filename + '''' + ', * ' + 
               'FROM Openrowset( Bulk ' + '''' + @Path2OutFile + '''' + ', Single_Blob) as img'
   EXEC (@tsql)
   SET NOCOUNT OFF
END
GO

--Image Export Stored Procedure
-- EXPORT IMAGENES

CREATE OR ALTER PROCEDURE dbo.exportar_imagenes_JCV (
   @PicName NVARCHAR (100)
   ,@ImageFolderPath NVARCHAR(1000)
   ,@Filename NVARCHAR(1000)
   )
AS
BEGIN
   DECLARE @ImageData VARBINARY (max);
   DECLARE @Path2OutFile NVARCHAR (2000);
   DECLARE @Obj INT
 
   SET NOCOUNT ON
 
   SELECT @ImageData = (
         SELECT convert (VARBINARY (max), PictureData, 1)
         FROM Logo_camping
         WHERE pictureName = @PicName
         );
 
   SET @Path2OutFile = CONCAT (
         @ImageFolderPath
         ,'\'
         , @Filename
         );
    BEGIN TRY
     EXEC sp_OACreate 'ADODB.Stream' ,@Obj OUTPUT;
     EXEC sp_OASetProperty @Obj ,'Type',1;
     EXEC sp_OAMethod @Obj,'Open';
     EXEC sp_OAMethod @Obj,'Write', NULL, @ImageData;
     EXEC sp_OAMethod @Obj,'SaveToFile', NULL, @Path2OutFile, 2;
     EXEC sp_OAMethod @Obj,'Close';
     EXEC sp_OADestroy @Obj;
    END TRY
    
 BEGIN CATCH
  EXEC sp_OADestroy @Obj;
 END CATCH
 
   SET NOCOUNT OFF
END
GO

SELECT * FROM Logo_camping
GO

-- PROBANDO
-- CARPETA C:\IMAGENES\ENTRADA

-- In order to import to SQL Server execute the following:

exec dbo.importar_imagenes_JCV 'PRIMERA_PRUEBA','C:\IMAGENES\ENTRADA','PRIMERA.jpg' 
GO
exec dbo.importar_imagenes_JCV 'SEGUNDA_PRUEBA','C:\IMAGENES\ENTRADA','SEGUNDA.png' 
GO
exec dbo.importar_imagenes_JCV 'TERCERA_PRUEBA','C:\IMAGENES\ENTRADA','TERCERA.gif' 
GO

SELECT * FROM Logo_camping
GO


-- in order to export the file, use the following:
-- EXPORTAR FICHERO USANDO LA EJECUCI N SIGUIENTE
exec dbo.exportar_imagenes_JCV  'PRIMERA_PRUEBA','C:\IMAGENES\SALIDA','PRIMERA.jpg'
GO
exec dbo.exportar_imagenes_JCV  'SEGUNDA_PRUEBA','C:\IMAGENES\SALIDA','SEGUNDA.jpg'
GO
exec dbo.exportar_imagenes_JCV  'TERCERA_PRUEBA','C:\IMAGENES\SALIDA','TERCERA.jpg'
GO

EXEC sp_configure 'xp_cmdshell', 1; 
GO 
RECONFIGURE; 
GO

xp_cmdshell "dir C:\IMAGENES\SALIDA"
go