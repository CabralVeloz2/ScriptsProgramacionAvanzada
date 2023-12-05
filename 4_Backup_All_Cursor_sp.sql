USE master
GO
CREATE OR ALTER PROC Backup_con_Cursores_JCV
AS
	BEGIN
		DECLARE @name VARCHAR(50) -- database name  
		DECLARE @path VARCHAR(256) -- path for backup files  
		DECLARE @fileName VARCHAR(256) -- filename for backup  
		DECLARE @fileDate VARCHAR(20) -- used for file name
 
		-- specify database backup directory
		SET @path = 'C:\BackupJCV2\'  
		SELECT @fileDate = CONVERT(VARCHAR(20),GETDATE(),112) + REPLACE(CONVERT(VARCHAR(20),GETDATE(),108),':','')
		DECLARE db_cursor CURSOR READ_ONLY FOR  
		SELECT name 
		FROM master.dbo.sysdatabases 
		WHERE name IN ('Camping_JCV', 'CampingJCV2')
 
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
	END
GO
EXECUTE Backup_con_Cursores_JCV
GO
--End Script
--Se han procesado 640 páginas para la base de datos 'CampingJCV2', archivo 'CampingJCV2' en el archivo 1.
--Se han procesado 1 páginas para la base de datos 'CampingJCV2', archivo 'CampingJCV2_log' en el archivo 1.
--BACKUP DATABASE procesó correctamente 641 páginas en 0.077 segundos (64.954 MB/s).

--Completion time: 2023-12-05T04:10:33.2434401+01:00