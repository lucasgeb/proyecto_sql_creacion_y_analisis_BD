USE FastFoodBD;

---------------------||Respuestas a Consultas||-----------------------------

-- 1. �Cu�l es el total de ventas (TotalCompra) a nivel global? 

SELECT SUM(TotalCompra) AS TotalDeVentas
FROM Ordenes;



-- 2. �Cu�l es el precio promedio de los productos dentro de cada categor�a? 

SELECT CategoriaID,
		CAST(ROUND(AVG(Precio), 2) AS DECIMAL(10,2)) AS PrecioPromedio
FROM Productos
GROUP BY CategoriaID;



-- 3. �Cu�l es el valor de la orden m�nima y m�xima por cada sucursal? 

SELECT SucursalID,
		MIN(TotalCompra)AS OrdenMinima,
		MAX(TotalCompra) AS OrdenMaxima
FROM Ordenes
GROUP BY SucursalID;



-- 4. �Cu�l es el mayor n�mero de kil�metros recorridos para una entrega? 

SELECT 
		MAX(KilometrosRecorrer) AS MayorKilometrajeRecorrido
FROM Ordenes;



-- 5. �Cu�l es la cantidad promedio de productos por orden? 

SELECT OrdenID,
        AVG(cantidad) as cantidad_promedio_productos
FROM DetalleOrdenes
GROUP BY OrdenID;




-- 6. �Cu�l es el total de ventas por cada tipo de pago? 

SELECT TipoPagoID,
		SUM(TotalCompra) AS VentasTotales
FROM Ordenes
GROUP BY TipoPagoID;
 


-- 7. �Cu�l sucursal tiene la venta promedio m�s alta? 

SELECT TOP 1 SucursalID, CAST(AVG(TotalCompra) AS DECIMAL(10,2)) AS [Venta Promedio]
FROM Ordenes
Group BY SucursalID
ORDER BY [Venta Promedio] DESC;



-- 8. �Cu�les son las sucursales que han generado ventas por orden por encima de $100, y c�mo se comparan en t�rminos del total de ventas? 

SELECT SUM(totalCompra) AS ValorDeVentas,
SucursalID
FROM Ordenes
GROUP BY SucursalID
HAVING SUM(TotalCompra) > 65; -- PAra realizar la consulta se modifica el criterio a "> 65" porque no hay ning�n resultado cuyo valor supere los 100 como decia el ejercicio



-- 9. �C�mo se comparan las ventas promedio antes y despu�s del 1 de julio de 2023? 

SELECT CAST(AVG(TotalCompra) AS DECIMAL(10,2)) AS [Venta Promedio], 'Promedio Venta Antes de Julio 2023' AS Comentario
FROM Ordenes
WHERE FechaOrdenTomada < '2023-07-01'
UNION -- Anexo las cosultas individuales
SELECT CAST(AVG(TotalCompra) AS DECIMAL(10,2)) AS [Venta Promedio], 'Promedio Venta Despues de Julio 2023' AS Comentario
FROM Ordenes
WHERE FechaOrdenTomada > '2023-07-01';



-- 10. Pregunta: �Durante qu� horario del d�a (ma�ana, tarde, noche) se registra la mayor cantidad de ventas, cu�l es el valor promedio de estas ventas, y cu�l ha sido la venta m�xima alcanzada? 

SELECT 
    HorarioVenta,
    COUNT(OrdenID) AS CantidadVentas,
    CAST(AVG(TotalCompra) AS DECIMAL(10,2)) AS VentaPromedio,
    MAX(TotalCompra) AS VentaMaxima
FROM 
    Ordenes
GROUP BY 
    HorarioVenta
ORDER BY 
    VentaMaxima DESC; -- Se ordena por venta maxima en este caso para ejemplificar, ya que si ordenamos por cantidadVentas en este caso los 3 turnos tienen 3 ventas y no ver�amos un orden.
