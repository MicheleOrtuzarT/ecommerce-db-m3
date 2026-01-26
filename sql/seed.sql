-------------------------------------------------
-- 1. Datos de prueba para poblar las tablas
-------------------------------------------------
-- Insertar Categorías
INSERT INTO categorias (nombre) VALUES 
('Limpiadores'), 
('Sérums'), 
('Protectores Solares'), 
('Hidratantes');

-- Insertar Productos
INSERT INTO productos (sku, nombre, descripcion, precio, categoria_id) VALUES
('SKU-CLE-001', 'Gel Limpiador Espumoso', 'Limpiador para piel normal a grasa 400ml', 15990, 1),
('SKU-SER-002', 'Sérum Vitamina C10', 'Sérum renovador antioxidante 30ml', 32990, 2),
('SKU-SUN-003', 'Anthelios UVmune 400', 'Protector solar fluido invisible FPS50', 21500, 3),
('SKU-HID-004', 'Hyalu B5 Crema', 'Crema hidratante anti-arrugas 40ml', 28490, 4),
('SKU-SER-005', 'Sérum Retinol B3', 'Sérum dermatológico anti-arrugas 30ml', 34990, 2);

-- Insertar Inventario (Relación 1:1)
-- El producto 1 tiene stock bajo a propósito para probar la consulta de stock
INSERT INTO inventario_productos (producto_id, stock_actual, stock_minimo) VALUES
(1, 8, 10),  -- Alerta de stock bajo (8 < 10)
(2, 25, 10),
(3, 50, 15),
(4, 12, 10),
(5, 0, 5);   -- Agotado

-- Insertar Clientes
INSERT INTO clientes (rut, nombre, apellido, email, password_hash, telefono) VALUES
('12.345.678-9', 'Juan', 'Pérez', 'juan.perez@email.cl', 'hash_seguro_1', '+56911111111'),
('18.765.432-K', 'María', 'Soto', 'm.soto@email.cl', 'hash_seguro_2', '+56922222222'),
('15.555.444-3', 'Carla', 'Ibáñez', 'c.ibanez@email.cl', 'hash_seguro_3', '+56933333333');

-- Insertar Pedidos y Pagos (Simulando historial)
-- Pedido 1: Juan Pérez
INSERT INTO pedidos (cliente_id, fecha_pedido, estado, total) VALUES (1, '2024-01-10 10:00:00', 'Entregado', 37490);
INSERT INTO detalle_pedidos (pedido_id, producto_id, cantidad, precio_unitario) VALUES (1, 1, 1, 15990), (1, 3, 1, 21500);
INSERT INTO pagos (pedido_id, monto, metodo_pago, estado_pago) VALUES (1, 37490, 'Tarjeta de Crédito', 'Completado');

-- Pedido 2: María Soto
INSERT INTO pedidos (cliente_id, fecha_pedido, estado, total) VALUES (2, '2024-01-15 15:30:00', 'Entregado', 32990);
INSERT INTO detalle_pedidos (pedido_id, producto_id, cantidad, precio_unitario) VALUES (2, 2, 1, 32990);
INSERT INTO pagos (pedido_id, monto, metodo_pago, estado_pago) VALUES (2, 32990, 'Transferencia', 'Completado');