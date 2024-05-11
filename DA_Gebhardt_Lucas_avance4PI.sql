USE FastFoodBD;

/* 1. Listar todos los productos y sus categor�as - �C�mo puedo obtener una lista de todos los productos junto con sus categor�as?*/

SELECT p.Nombre, 
	   c.Nombre AS [Categoria] 
FROM Productos p
INNER JOIN 
	Categorias c ON p.CategoriaID = c.CategoriaID;



/*2. Obtener empleados y su sucursal asignada - �C�mo puedo saber a qu� sucursal est� asignado cada empleado?*/

SELECT e.Nombre,
	   e.Departamento,
	   s.Nombre AS [Sucursal]
FROM Empleados e
INNER JOIN 
	Sucursales s ON e.SucursalID = s.SucursalID;



/*3. Identificar productos sin categor�a asignada - �Existen productos que no tienen una categor�a asignada?*/
--En este caso, todos los productos tienen categor�a asignada, por ende, al correr el c�digo no devolver� datos.
--Pero si ingresaran nuevos productos a los cuales no se le ha asignado una categor�a se visualiza� el ID del producto y el nombre

SELECT p.ProductoID,
	   p.Nombre  
FROM Productos p
LEFT JOIN 
	Categorias c ON p.CategoriaID = c.CategoriaID
WHERE c.CategoriaID IS NULL;



/*4. Detalle completo de �rdenes - �C�mo puedo obtener un detalle completo de las �rdenes, incluyendo cliente, empleado que tom� la orden, y el mensajero que la entreg�?*/

SELECT o.ordenID,
	   o.HorarioVenta,
	   o.TotalCompra,
	   o.KilometrosRecorrer,
	   o.FechaOrdenLista,
	   c.Nombre AS [Nombre del cliente],
	   c.Direccion AS [Direccion del cliente],
	   e.Nombre As [Orden Tomada Por],
	   m.Nombre AS [Orden Entregada Por] 
FROM Ordenes o
INNER JOIN 
	Clientes c ON o.ClienteID = c.ClienteID
INNER JOIN
	Empleados e ON o.EmpleadoID = e.EmpleadoID
INNER JOIN 
	Mensajeros m ON o.MensajeroID = m.MensajeroID;



/*5. Productos vendidos por sucursal - �Cu�ntos productos de cada tipo se han vendido en cada sucursal?*/

SELECT s.Nombre AS [Sucursal], c.Nombre, SUM(Cantidad) AS [Articulos Vendidos]
FROM Ordenes o
	INNER JOIN DetalleORdenes d
		ON o.OrdenID = d.OrdenID
	INNER JOIN Productos p
	    ON d.ProductoID = p.ProductoID
	INNER JOIN Categorias c
		ON p.CategoriaID = c.CategoriaID
	INNER JOIN Sucursales s
		ON o.SucursalID = s.SucursalID
GROUP BY c.Nombre,s.Nombre;

