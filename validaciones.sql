
-- 1) Conteos origen vs. destino
SELECT 'Pedidos - Origen' AS Métrica, COUNT(*) AS Total FROM BikeStores.sales.orders
UNION ALL SELECT 'Pedidos - Suc1', COUNT(*) FROM BikeStores_Sucursal1.sales.orders_operativo
UNION ALL SELECT 'Pedidos - Suc2', COUNT(*) FROM BikeStores_Sucursal2.sales.orders_operativo
UNION ALL SELECT 'Pedidos - Suc3', COUNT(*) FROM BikeStores_Sucursal3.sales.orders_operativo
UNION ALL SELECT 'Detalles - Origen', COUNT(*) FROM BikeStores.sales.order_items
UNION ALL SELECT 'Detalles - Suc1', COUNT(*) FROM BikeStores_Sucursal1.sales.order_items
UNION ALL SELECT 'Detalles - Suc2', COUNT(*) FROM BikeStores_Sucursal2.sales.order_items
UNION ALL SELECT 'Detalles - Suc3', COUNT(*) FROM BikeStores_Sucursal3.sales.order_items
UNION ALL SELECT 'Staffs - Origen', COUNT(*) FROM BikeStores.sales.staffs
UNION ALL SELECT 'Staffs - Suc1', COUNT(*) FROM BikeStores_Sucursal1.sales.staffs
UNION ALL SELECT 'Staffs - Suc2', COUNT(*) FROM BikeStores_Sucursal2.sales.staffs
UNION ALL SELECT 'Staffs - Suc3', COUNT(*) FROM BikeStores_Sucursal3.sales.staffs
UNION ALL SELECT 'Stocks - Origen', COUNT(*) FROM BikeStores.production.stocks
UNION ALL SELECT 'Stocks - Suc1', COUNT(*) FROM BikeStores_Sucursal1.production.stocks
UNION ALL SELECT 'Stocks - Suc2', COUNT(*) FROM BikeStores_Sucursal2.production.stocks
UNION ALL SELECT 'Stocks - Suc3', COUNT(*) FROM BikeStores_Sucursal3.production.stocks;


-- 2) Pedidos faltantes
SELECT o.order_id
FROM BikeStores.sales.orders o
LEFT JOIN BikeStores_Sucursal1.sales.orders_operativo s1 ON o.order_id = s1.order_id
LEFT JOIN BikeStores_Sucursal2.sales.orders_operativo s2 ON o.order_id = s2.order_id
LEFT JOIN BikeStores_Sucursal3.sales.orders_operativo s3 ON o.order_id = s3.order_id
WHERE s1.order_id IS NULL AND s2.order_id IS NULL AND s3.order_id IS NULL;


-- 3) Pedidos en sucursal incorrecta
SELECT * FROM BikeStores_Sucursal1.sales.orders_operativo WHERE store_id <> 1
UNION ALL
SELECT * FROM BikeStores_Sucursal2.sales.orders_operativo WHERE store_id <> 2
UNION ALL
SELECT * FROM BikeStores_Sucursal3.sales.orders_operativo WHERE store_id <> 3;


-- 4) Referencias a productos inexistentes en Central
SELECT DISTINCT oi.product_id
FROM BikeStores_Sucursal1.sales.order_items oi
LEFT JOIN BikeStores_Central.production.products p ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;


-- 5) Prueba negativa (fallo esperado del CHECK)
USE BikeStores_Sucursal1;
GO
INSERT INTO sales.staffs (first_name, last_name, email, active, store_id)
VALUES ('Yader', 'Siezar', 'y.siezar@gmail.com', 1, 2);
-- Error esperado: "The INSERT statement conflicted with the CHECK constraint chk_staffs_store"