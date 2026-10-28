
-- 1) Pedidos por sucursal y estado
SELECT 'Sucursal1' AS Sucursal, store_id, order_status, COUNT(*) AS Total
FROM BikeStores_Sucursal1.sales.orders_operativo
GROUP BY store_id, order_status
UNION ALL
SELECT 'Sucursal2', store_id, order_status, COUNT(*)
FROM BikeStores_Sucursal2.sales.orders_operativo
GROUP BY store_id, order_status
UNION ALL
SELECT 'Sucursal3', store_id, order_status, COUNT(*)
FROM BikeStores_Sucursal3.sales.orders_operativo
GROUP BY store_id, order_status
ORDER BY Sucursal, order_status;


-- 2) Reconstruir clientes (JOIN vertical)
SELECT i.customer_id, i.first_name, i.last_name,
       c.phone, c.email, c.street, c.city, c.state, c.zip_code
FROM BikeStores_Sucursal1.sales.customers_identidad i
INNER JOIN BikeStores_Sucursal1.sales.customers_contacto c
    ON i.customer_id = c.customer_id;


-- 3) Consolidar pedidos (UNION ALL)
SELECT 'Sucursal1' AS Origen, order_id, customer_id, order_status, order_date, store_id, staff_id
FROM BikeStores_Sucursal1.sales.orders_operativo
UNION ALL
SELECT 'Sucursal2', order_id, customer_id, order_status, order_date, store_id, staff_id
FROM BikeStores_Sucursal2.sales.orders_operativo
UNION ALL
SELECT 'Sucursal3', order_id, customer_id, order_status, order_date, store_id, staff_id
FROM BikeStores_Sucursal3.sales.orders_operativo
ORDER BY order_id;


-- 4) Inventario global
SELECT 'Sucursal1' AS Sucursal, store_id, product_id, quantity
FROM BikeStores_Sucursal1.production.stocks
UNION ALL
SELECT 'Sucursal2', store_id, product_id, quantity
FROM BikeStores_Sucursal2.production.stocks
UNION ALL
SELECT 'Sucursal3', store_id, product_id, quantity
FROM BikeStores_Sucursal3.production.stocks;


-- 5) Productos no migrados a Central
SELECT p.product_id, p.product_name
FROM BikeStores.production.products p
LEFT JOIN BikeStores_Central.production.products pc
    ON p.product_id = pc.product_id
WHERE pc.product_id IS NULL;


-- 6) Detalles con su producto desde el catálogo central (join entre BD)
SELECT oi.order_id, oi.item_id, oi.product_id,
       p.product_name, p.list_price AS precio_catalogo,
       oi.quantity, oi.list_price AS precio_venta
FROM BikeStores_Sucursal1.sales.order_items oi
INNER JOIN BikeStores_Central.production.products p
    ON oi.product_id = p.product_id;
