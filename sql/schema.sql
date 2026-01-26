-------------------------------------------------
-- 1. Borrado en orden inverso de dependencias
-------------------------------------------------
DROP TABLE IF EXISTS pagos;
DROP TABLE IF EXISTS detalle_pedidos;
DROP TABLE IF EXISTS pedidos;
DROP TABLE IF EXISTS inventario_productos;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS categorias;
DROP TABLE IF EXISTS clientes;
-------------------------------------------------
-- 2. Clientes
-------------------------------------------------
CREATE TABLE clientes (
    cliente_id SERIAL PRIMARY KEY,
    rut VARCHAR(12) NOT NULL UNIQUE, -- "12.345.678-K"
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL, -- Los hash suelen ser largos
    telefono VARCHAR(20),
    created_at TIMESTAMPTZ DEFAULT NOW() -- Estándar profesional
);
-------------------------------------------------
-- 3. Categorías (debe ir antes que productos)
-------------------------------------------------
CREATE TABLE categorias (
    categoria_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE
);
-------------------------------------------------
-- 4. Productos
-------------------------------------------------
CREATE TABLE productos (
    producto_id SERIAL PRIMARY KEY,
    sku VARCHAR(50) UNIQUE NOT NULL, -- Identificador de inventario
    nombre VARCHAR(255) NOT NULL,
    descripcion TEXT,
    precio NUMERIC(12, 0) NOT NULL CHECK (precio >= 0), -- En Chile no usamos decimales para CLP
    categoria_id INTEGER NOT NULL REFERENCES categorias(categoria_id), -- Sintaxis inline
    created_at TIMESTAMPTZ DEFAULT NOW()
);
-------------------------------------------------
-- 5. Inventario (Relación 1:1 con Productos)
-------------------------------------------------
CREATE TABLE inventario_productos (
    inventario_id SERIAL PRIMARY KEY,
    producto_id INTEGER NOT NULL UNIQUE REFERENCES productos(producto_id),
    stock_actual INTEGER NOT NULL CHECK (stock_actual >= 0),
    stock_minimo INTEGER DEFAULT 10, -- Para alertas de stock bajo
    ultima_actualizacion TIMESTAMPTZ DEFAULT NOW()
);
-------------------------------------------------
-- 6. Pedidos
-------------------------------------------------
CREATE TABLE pedidos (
    pedido_id SERIAL PRIMARY KEY,
    cliente_id INTEGER NOT NULL REFERENCES clientes(cliente_id),
    fecha_pedido TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    estado VARCHAR(50) NOT NULL DEFAULT 'Pendiente' 
        CHECK (estado IN ('Pendiente', 'Procesando', 'Enviado', 'Entregado', 'Cancelado')),
    total NUMERIC(12, 0) NOT NULL DEFAULT 0 CHECK (total >= 0)
);
-------------------------------------------------
-- 7. Detalle de Pedidos
-------------------------------------------------
CREATE TABLE detalle_pedidos (
    detalle_id SERIAL PRIMARY KEY,
    pedido_id INTEGER NOT NULL REFERENCES pedidos(pedido_id) ON DELETE CASCADE,
    producto_id INTEGER NOT NULL REFERENCES productos(producto_id),
    cantidad INTEGER NOT NULL CHECK (cantidad > 0),
    precio_unitario NUMERIC(12, 0) NOT NULL CHECK (precio_unitario >= 0),
    UNIQUE (pedido_id, producto_id)
);
-------------------------------------------------
-- 8. Tabla de Pagos 
-------------------------------------------------
CREATE TABLE pagos (
    pago_id SERIAL PRIMARY KEY,
    pedido_id INTEGER NOT NULL UNIQUE REFERENCES pedidos(pedido_id), -- 1:1
    monto NUMERIC(12, 0) NOT NULL CHECK (monto > 0),
    metodo_pago VARCHAR(50) NOT NULL, -- 'Tarjeta de Crédito', 'Transferencia', etc.
    estado_pago VARCHAR(50) DEFAULT 'Pendiente',
    fecha_pago TIMESTAMPTZ DEFAULT NOW()
);
-------------------------------------------------
-- ÍNDICES 
-------------------------------------------------
CREATE INDEX idx_productos_nombre ON productos(nombre);
CREATE INDEX idx_pedidos_cliente ON pedidos(cliente_id);
CREATE INDEX idx_productos_categoria ON productos(categoria_id);