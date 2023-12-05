-- Crear un procedimiento almacenado para obtener clientes por municipio
CREATE PROCEDURE sp_ObtenerClientesPorMunicipio
AS
BEGIN
    SELECT MUNICIPIO.ID_municipio, MUNICIPIO.municipio AS NombreMunicipio, CLIENTE.*
    FROM MUNICIPIO
    LEFT JOIN CLIENTE ON MUNICIPIO.ID_municipio = CLIENTE.MUNICIPIO_ID_municipio
    ORDER BY MUNICIPIO.ID_municipio, CLIENTE.ID_cliente;
END;


EXEC sp_ObtenerClientesPorMunicipio;





-- Crear un procedimiento almacenado para obtener la cantidad de clientes por municipio
CREATE PROCEDURE sp_SumarClientesPorMunicipio
AS
BEGIN
    SELECT MUNICIPIO.ID_municipio, MUNICIPIO.municipio AS NombreMunicipio, COUNT(CLIENTE.ID_cliente) AS CantidadClientes
    FROM MUNICIPIO
    LEFT JOIN CLIENTE ON MUNICIPIO.ID_municipio = CLIENTE.MUNICIPIO_ID_municipio
    GROUP BY MUNICIPIO.ID_municipio, MUNICIPIO.municipio
    ORDER BY MUNICIPIO.ID_municipio;
END;


EXEC sp_SumarClientesPorMunicipio;

--ID_municipio	NombreMunicipio	CantidadClientes
--1	Barcelona	2
--2	Castelldefels	2
--3	Hospitalet	2
--4	Arteixo	2
--5	Carballo	2
--6	Finisterra	0
--7	Ferrol	0
--8	Oleiros	0














-- Crear un procedimiento almacenado para obtener el municipio por ID_cliente
CREATE PROCEDURE sp_ObtenerMunicipioPorCliente
    @ID_cliente INT
AS
BEGIN
    SELECT MUNICIPIO.*
    FROM MUNICIPIO
    JOIN CLIENTE ON MUNICIPIO.ID_municipio = CLIENTE.MUNICIPIO_ID_municipio
    WHERE CLIENTE.ID_cliente = @ID_cliente;
END;
GO

-- Ejecuto el SP
DECLARE @ClienteID INT = 1;
EXEC sp_ObtenerMunicipioPorCliente @ClienteID;
--ID_municipio	Municipio	PROVINCIA_ID_provincia
--1	            Barcelona	1

SELECT * FROM Cliente
GO

SELECT * FROM Municipio
GO

