USE FastFoodBD;

-- Eficiencia de los mensajeros: 
-- Cu�l es el tiempo promedio desde el despacho hasta la entrega de los pedidos por los mensajeros?

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



-- An�lisis de Ventas por Origen de Orden: 
-- Qu� canal de ventas genera m�s ingresos?

SELECT od.Descripcion, SUM (TotalCompra) AS [Total de Ventas]
FROM Ordenes o
INNER JOIN OrigenesOrden Od ON o.OrigenID = od.OrigenID
GROUP BY od.Descripcion
ORDER BY [Total de Ventas] DESC;



-- Productividad de los Empleados: 
-- �Cu�l es el volumen de ventas promedio gestionado por empleado?

SELECT e.Nombre, COUNT(OrdenID) AS [Volumen de venta] FROM Ordenes o
INNER JOIN Empleados e ON o.EmpleadoID = e.EmpleadoID
GROUP BY e.Nombre;



/* An�lisis de Demanda por Horario y D�a: 
�C�mo var�a la demanda de productos a lo largo del d�a? 
NOTA: Esta consulta no puede ser implementada sin una definici�n clara del horario (ma�ana, tarde, noche) en la base de datos existente.
Asumiremos que HorarioVenta refleja esta informaci�n correctamente. */

Select o.HorarioVenta AS [Horario de Venta],
		SUM(d.cantidad) AS [Demanda de productos]
FROM Ordenes o
LEFT JOIN DetalleOrdenes d ON o.OrdenID = d.OrdenID
GROUP BY�o.HorarioVenta;
--En este caso, solo se van a obtener las demandas de productos en el horario de la ma�ana (ya que sumarisa solo los productos de DetalleOrden correspondiente a la OrdenID= 1 ,
--Cuando se ingresen los datos de las dem�s ordenes, que correspondan a tarde y noche, se cargaran en la tabla resultante



-- Comparaci�n de Ventas Mensuales
-- �C�mo se comparan las ventas mensuales de este a�o con el a�o anterior?

SELECT SUM(totalCompra) AS [Total de Ventas], MONTH(FechaOrdenTomada) AS [Mes], YEAR(FechaOrdenTomada) AS [A�o]
FROM ordenes
GROUP BY FechaOrdenTomada;



/*An�lisis de Fidelidad del Cliente: 
�Qu� porcentaje de clientes son recurrentes versus nuevos clientes cada mes?
NOTA: La consulta se enfocar�a en la frecuencia de �rdenes por cliente para inferir la fidelidad.*/

-- Con este c�digo solo podr�amos obtener la cantidad de ordenes respecto a cada cliente
-- Al ser acotada la BD, solo obtenemos una orden por cliente
-- No hay informaci�n historica para obtener la fidelidad del cliente.

SELECT CLienteID,
	   COUNT(OrdenID) AS [N�mero de Ordenes]
FROM Ordenes
GROUP BY ClienteID;

-- Con este codigo m�s avanzado en cambio, podr�amos ver reflejado en una tabla los requerimientos pedidos
WITH ClientesPorMes AS (
SELECT 
    ClienteID,
    YEAR(FechaOrdenTomada) AS [A�o],
    MONTH(FechaOrdenTomada) AS [Mes],
    COUNT(DISTINCT OrdenID) AS [NumeroOrdenes]
    FROM 
        Ordenes
    GROUP BY 
        ClienteID, YEAR(FechaOrdenTomada), MONTH(FechaOrdenTomada)
),
FidelidadCliente AS (
    SELECT 
        A�o,
        Mes,
        SUM(CASE WHEN NumeroOrdenes > 1 THEN 1 ELSE 0 END) AS Recurrentes,
        SUM(CASE WHEN NumeroOrdenes = 1 THEN 1 ELSE 0 END) AS Nuevos,
        COUNT(*) AS TotalClientes
    FROM 
        ClientesPorMes
    GROUP BY 
        A�o, Mes
)
SELECT 
    A�o,
    Mes,
    Recurrentes,
    Nuevos,
    TotalClientes,
    CAST(Recurrentes AS FLOAT) / TotalClientes AS PorcentajeRecurrentes,
    CAST(Nuevos AS FLOAT) / TotalClientes AS PorcentajeNuevos
FROM 
    FidelidadCliente
ORDER BY 
    A�o, Mes;
