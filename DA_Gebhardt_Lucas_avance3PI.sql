USE FastFoodBD;

---------------------||Respuestas a Consultas||-----------------------------

-- 1. ¿Cuál es el total de ventas (TotalCompra) a nivel global? 

SELECT SUM(TotalCompra) AS TotalDeVentas
FROM Ordenes;



-- 2. ¿Cuál es el precio promedio de los productos dentro de cada categoría? 

SELECT CategoriaID,
		CAST(ROUND(AVG(Precio), 2) AS DECIMAL(10,2)) AS PrecioPromedio
FROM Productos
GROUP BY CategoriaID;



-- 3. ¿Cuál es el valor de la orden mínima y máxima por cada sucursal? 

SELECT SucursalID,
		MIN(TotalCompra)AS OrdenMinima,
		MAX(TotalCompra) AS OrdenMaxima
FROM Ordenes
GROUP BY SucursalID;



-- 4. ¿Cuál es el mayor número de kilómetros recorridos para una entrega? 

SELECT 
		MAX(KilometrosRecorrer) AS MayorKilometrajeRecorrido
FROM Ordenes;



-- 5. ¿Cuál es la cantidad promedio de productos por orden? 

SELECT OrdenID,
        AVG(cantidad) as cantidad_promedio_productos
FROM DetalleOrdenes
GROUP BY OrdenID;




-- 6. ¿Cuál es el total de ventas por cada tipo de pago? 

SELECT TipoPagoID,
		SUM(TotalCompra) AS VentasTotales
FROM Ordenes
GROUP BY TipoPagoID;
 


-- 7. ¿Cuál sucursal tiene la venta promedio más alta? 

SELECT TOP 1 SucursalID, CAST(AVG(TotalCompra) AS DECIMAL(10,2)) AS [Venta Promedio]
FROM Ordenes
Group BY SucursalID
ORDER BY [Venta Promedio] DESC;



-- 8. ¿Cuáles son las sucursales que han generado ventas por orden por encima de $100, y cómo se comparan en términos del total de ventas? 

SELECT SUM(totalCompra) AS ValorDeVentas,
SucursalID
FROM Ordenes
GROUP BY SucursalID
HAVING SUM(TotalCompra) > 65; -- PAra realizar la consulta se modifica el criterio a "> 65" porque no hay ningún resultado cuyo valor supere los 100 como decia el ejercicio



-- 9. ¿Cómo se comparan las ventas promedio antes y después del 1 de julio de 2023? 

SELECT CAST(AVG(TotalCompra) AS DECIMAL(10,2)) AS [Venta Promedio], 'Promedio Venta Antes de Julio 2023' AS Comentario
FROM Ordenes
WHERE FechaOrdenTomada < '2023-07-01'
UNION -- Anexo las cosultas individuales
SELECT CAST(AVG(TotalCompra) AS DECIMAL(10,2)) AS [Venta Promedio], 'Promedio Venta Despues de Julio 2023' AS Comentario
FROM Ordenes
WHERE FechaOrdenTomada > '2023-07-01';



-- 10. Pregunta: ¿Durante qué horario del día (mañana, tarde, noche) se registra la mayor cantidad de ventas, cuál es el valor promedio de estas ventas, y cuál ha sido la venta máxima alcanzada? 

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
    VentaMaxima DESC; -- Se ordena por venta maxima en este caso para ejemplificar, ya que si ordenamos por cantidadVentas en este caso los 3 turnos tienen 3 ventas y no veríamos un orden.
