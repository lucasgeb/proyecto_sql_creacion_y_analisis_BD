USE FastFoodBD;

-- Eficiencia de los mensajeros: 
-- Cuál es el tiempo promedio desde el despacho hasta la entrega de los pedidos por los mensajeros?

SELECT 
    m.MensajeroID,
    m.Nombre,
    AVG(DATEDIFF(MINUTE, o.FechaDespacho, o.FechaEntrega)) AS TiempoPromedioDespachoEntrega
FROM 
    Ordenes o
RIGHT JOIN 
    Mensajeros m ON o.MensajeroID = m.MensajeroID
WHERE 
    o.FechaDespacho IS NOT NULL 
    AND o.FechaEntrega IS NOT NULL
    AND m.MensajeroID IS NOT NULL
GROUP BY
    m.MensajeroID,
    m.Nombre
ORDER BY
    TiempoPromedioDespachoEntrega;



-- Análisis de Ventas por Origen de Orden: 
-- Qué canal de ventas genera más ingresos?

SELECT od.Descripcion, SUM (TotalCompra) AS [Total de Ventas]
FROM Ordenes o
INNER JOIN OrigenesOrden Od ON o.OrigenID = od.OrigenID
GROUP BY od.Descripcion
ORDER BY [Total de Ventas] DESC;



-- Productividad de los Empleados: 
-- ¿Cuál es el volumen de ventas promedio gestionado por empleado?

SELECT e.Nombre, COUNT(OrdenID) AS [Volumen de venta] FROM Ordenes o
INNER JOIN Empleados e ON o.EmpleadoID = e.EmpleadoID
GROUP BY e.Nombre;



/* Análisis de Demanda por Horario y Día: 
¿Cómo varía la demanda de productos a lo largo del día? 
NOTA: Esta consulta no puede ser implementada sin una definición clara del horario (mañana, tarde, noche) en la base de datos existente.
Asumiremos que HorarioVenta refleja esta información correctamente. */

Select o.HorarioVenta AS [Horario de Venta],
		SUM(d.cantidad) AS [Demanda de productos]
FROM Ordenes o
LEFT JOIN DetalleOrdenes d ON o.OrdenID = d.OrdenID
GROUP BY o.HorarioVenta;
--En este caso, solo se van a obtener las demandas de productos en el horario de la mañana (ya que sumarisa solo los productos de DetalleOrden correspondiente a la OrdenID= 1 ,
--Cuando se ingresen los datos de las demás ordenes, que correspondan a tarde y noche, se cargaran en la tabla resultante



-- Comparación de Ventas Mensuales
-- ¿Cómo se comparan las ventas mensuales de este año con el año anterior?

SELECT SUM(totalCompra) AS [Total de Ventas], MONTH(FechaOrdenTomada) AS [Mes], YEAR(FechaOrdenTomada) AS [Año]
FROM ordenes
GROUP BY FechaOrdenTomada;



/*Análisis de Fidelidad del Cliente: 
¿Qué porcentaje de clientes son recurrentes versus nuevos clientes cada mes?
NOTA: La consulta se enfocaría en la frecuencia de órdenes por cliente para inferir la fidelidad.*/

-- Con este código solo podríamos obtener la cantidad de ordenes respecto a cada cliente
-- Al ser acotada la BD, solo obtenemos una orden por cliente
-- No hay información historica para obtener la fidelidad del cliente.

SELECT CLienteID,
	   COUNT(OrdenID) AS [Número de Ordenes]
FROM Ordenes
GROUP BY ClienteID;

-- Con este codigo más avanzado en cambio, podríamos ver reflejado en una tabla los requerimientos pedidos
WITH ClientesPorMes AS (
SELECT 
    ClienteID,
    YEAR(FechaOrdenTomada) AS [Año],
    MONTH(FechaOrdenTomada) AS [Mes],
    COUNT(DISTINCT OrdenID) AS [NumeroOrdenes]
    FROM 
        Ordenes
    GROUP BY 
        ClienteID, YEAR(FechaOrdenTomada), MONTH(FechaOrdenTomada)
),
FidelidadCliente AS (
    SELECT 
        Año,
        Mes,
        SUM(CASE WHEN NumeroOrdenes > 1 THEN 1 ELSE 0 END) AS Recurrentes,
        SUM(CASE WHEN NumeroOrdenes = 1 THEN 1 ELSE 0 END) AS Nuevos,
        COUNT(*) AS TotalClientes
    FROM 
        ClientesPorMes
    GROUP BY 
        Año, Mes
)
SELECT 
    Año,
    Mes,
    Recurrentes,
    Nuevos,
    TotalClientes,
    CAST(Recurrentes AS FLOAT) / TotalClientes AS PorcentajeRecurrentes,
    CAST(Nuevos AS FLOAT) / TotalClientes AS PorcentajeNuevos
FROM 
    FidelidadCliente
ORDER BY 
    Año, Mes;
