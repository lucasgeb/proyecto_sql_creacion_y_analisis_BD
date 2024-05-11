
--------------CREACIÓN DE LA BASE DE DATOS (BD)--------------
CREATE DATABASE FastFoodBD;


--------------POSICIONAMIENTO SOBRE LA BASE DE DATOS---------
USE FastFoodBD;


--------------CREACIÓN DE TABLAS-----------------------------
CREATE TABLE Productos(
	ProductoID INT PRIMARY KEY IDENTITY ,  
	Nombre VARCHAR(255),
	CategoriaID INT, -- FK, referencia a PK de la tabla Categoria
	Precio DECIMAL(10,2) NOT NULL DEFAULT (0) 
);

CREATE TABLE Categorias(
	CategoriaID INT PRIMARY KEY IDENTITY,
	Nombre VARCHAR(255)NOT NULL
);

CREATE TABLE Sucursales(
	SucursalID INT PRIMARY KEY IDENTITY,
	Nombre VARCHAR(255) NOT NULL,
	Direccion VARCHAR(255)
);

CREATE TABLE Empleados(
	EmpleadoID INT PRIMARY KEY IDENTITY,
	Nombre VARCHAR(255) NOT NULL,
	Posicion VARCHAR(255),
	Departamento VARCHAR(255),
	SucursalID INT,
	Rol VARCHAR(255),

);

CREATE TABLE Clientes(
	ClienteID INT PRIMARY KEY IDENTITY,
	Nombre VARCHAR(255) NOT NULL,
	Direccion VARCHAR(255)
);

CREATE TABLE OrigenesOrden(
	OrigenID INT PRIMARY KEY IDENTITY,
	Descripcion VARCHAR(25) NOT NULL
);

CREATE TABLE TiposPago(
	TipoPagoID INT PRIMARY KEY IDENTITY,
	Descripcion VARCHAR(255) NOT NULL
);


CREATE TABLE Mensajeros(
	MensajeroID INT PRIMARY KEY IDENTITY,
	Nombre VARCHAR(255) NOT NULL,
	EsExterno BIT NOT NULL,
);

CREATE TABLE Ordenes (
	OrdenID INT PRIMARY KEY IDENTITY,
	ClienteID INT,
	EmpleadoID INT,
	SucursalID INT,
	MensajeroID INT,
	TipoPagoID INT,
	OrigenID INT,
	HorarioVenta VARCHAR(50), -- Mañana | Tarde | Noche
	TotalCompra DECIMAL(10,2),
	KilometrosRecorrer DECIMAL(10,2), -- Si es entrega a domicilio
	FechaDespacho DATETIME, -- Hora y Fecha de entrega al repartidor
	FechaEntrega DATETIME, -- Hora y Fecha de la orden entregada
	FechaOrdenTomada DATETIME, 
	FechaOrdenLista DATETIME,
	
);

CREATE TABLE DetalleOrdenes (
	OrdenID INT,
	ProductoID INT,
	Cantidad INT,
	Precio DECIMAL(10,2),
	PRIMARY KEY (OrdenID, ProductoID)
);


--------------GENERACION DE RELACIONES ENTRE TABLAS----------
ALTER TABLE Productos
ADD CONSTRAINT FK_Productos_Categorias 
FOREIGN KEY(CategoriaID) REFERENCES Categorias(CategoriaID);

ALTER TABLE Empleados
ADD CONSTRAINT FK_Empleados_Sucursales
FOREIGN KEY(SucursalID) REFERENCES Sucursales(SucursalID);

ALTER TABLE Ordenes
ADD CONSTRAINT FK_Ordenes_Sucursales 
FOREIGN KEY(SucursalID) REFERENCES Sucursales(SucursalID);

ALTER TABLE Ordenes
ADD CONSTRAINT FK_Ordenes_Mensajeros 
FOREIGN KEY(MensajeroID) REFERENCES Mensajeros(MensajeroID);

ALTER TABLE Ordenes
ADD CONSTRAINT FK_Ordenes_Clientes 
FOREIGN KEY(ClienteID) REFERENCES Clientes(ClienteID);

ALTER TABLE Ordenes
ADD CONSTRAINT FK_Ordenes_Empleados 
FOREIGN KEY(EmpleadoID) REFERENCES Empleados(EmpleadoID);

ALTER TABLE Ordenes
ADD CONSTRAINT FK_Ordenes_Origenes 
FOREIGN KEY(OrigenID) REFERENCES OrigenesOrden(OrigenID);

ALTER TABLE Ordenes
ADD CONSTRAINT FK_Ordenes_tipopago 
FOREIGN KEY(TipoPagoID) REFERENCES TiposPago(TipoPagoID);

ALTER TABLE DetalleOrdenes
ADD CONSTRAINT FK_DetalleOrdenes_Ordenes
FOREIGN KEY(OrdenID) REFERENCES Ordenes(OrdenID);

ALTER TABLE DetalleOrdenes
ADD CONSTRAINT FK_DetalleOrdenes_Productos
FOREIGN KEY(ProductoID) REFERENCES Productos(ProductoID);


