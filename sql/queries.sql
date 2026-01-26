-------------------------------------------------
-- 1. Queries a KPIs
-------------------------------------------------
-- 1. Búsqueda de productos por nombre y categoría
SELECT productos.nombre, productos.precio, categorias.nombre AS nombre_categoria
FROM productos
JOIN categorias ON productos.categoria_id = categorias.categoria_id
WHERE productos.nombre LIKE '%Sérum%' AND categorias.nombre = 'Sérums';

-- 2. Alerta de Stock Bajo
-- Compara el stock actual con el mínimo definido en la tabla inventario_productos
SELECT productos.nombre, inventario_productos.stock_actual, inventario_productos.stock_minimo
FROM productos
JOIN inventario_productos ON productos.producto_id = inventario_productos.producto_id
WHERE inventario_productos.stock_actual < inventario_productos.stock_minimo;

-- 3. Ticket Promedio (Valor medio de compra)
-- Calculamos el promedio de la columna total de la tabla pedidos
SELECT ROUND(AVG(pedidos.total)) AS ticket_promedio_clp
FROM pedidos;

-- 4. Top 3 productos más vendidos (por cantidad acumulada)
-- Unimos productos con detalle_pedidos para sumar las cantidades vendidas
SELECT productos.nombre, SUM(detalle_pedidos.cantidad) AS total_vendido
FROM productos
JOIN detalle_pedidos ON productos.producto_id = detalle_pedidos.producto_id
GROUP BY productos.nombre
ORDER BY total_vendido DESC
LIMIT 3;

-- 5. Clientes frecuentes
-- Cuenta cuántas veces aparece el cliente_id en la tabla pedidos
SELECT clientes.nombre, clientes.apellido, COUNT(pedidos.pedido_id) AS total_compras
FROM clientes
JOIN pedidos ON clientes.cliente_id = pedidos.cliente_id
GROUP BY clientes.cliente_id, clientes.nombre, clientes.apellido
HAVING COUNT(pedidos.pedido_id) >= 1;

-------------------------------------------------
-- 2. Transacción
-------------------------------------------------
BEGIN;

-- 1. Crear el pedido para Carla (ID 3)
INSERT INTO pedidos (cliente_id, total, estado) 
VALUES (3, 21500, 'Procesando');

-- 2. Insertar el detalle (1 Protector Solar SKU-SUN-003 / ID 3)
-- El ID del pedido se asume como el último generado (usando subconsulta o LASTVAL)
INSERT INTO detalle_pedidos (pedido_id, producto_id, cantidad, precio_unitario)
VALUES (currval('pedidos_pedido_id_seq'), 3, 1, 21500);

-- 3. Actualizar el inventario descontando la cantidad
UPDATE inventario_productos 
SET stock_actual = stock_actual - 1, ultima_actualizacion = NOW()
WHERE producto_id = 3;

-- 4. Registrar el pago
INSERT INTO pagos (pedido_id, monto, metodo_pago, estado_pago)
VALUES (currval('pedidos_pedido_id_seq'), 21500, 'Webpay', 'Completado');

COMMIT;
-- En caso de error, pgAdmin permite ejecutar ROLLBACK;