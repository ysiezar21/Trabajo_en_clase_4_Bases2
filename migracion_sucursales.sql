-- ============ INSTRUCCIONES IMPORTANTES ============
-- Este bloque se ejecuta 3 veces, cambiando solo dos cosas:
-- 1) El nombre de la base de datos en el USE (BikeStores_Sucursal1, BikeStores_Sucursal2, BikeStores_Sucursal3)
-- 2) El valor de los WHEREs de store_id (1, 2 o 3)
-- ===================================================


USE BikeStores_Sucursal1; -- ← cambiar para cada sucursal
GO

-- Staffs
SET IDENTITY_INSERT sales.staffs ON;
INSERT INTO sales.staffs (staff_id, first_name, last_name, email, phone, active, store_id, manager_id)
SELECT staff_id, first_name, last_name, email, phone, active, store_id, manager_id
FROM BikeStores.sales.staffs
WHERE store_id = 1; -- ← cambiar para cada sucursal
SET IDENTITY_INSERT sales.staffs OFF;

-- Customers: fragmento identidad (todos los clientes)
SET IDENTITY_INSERT sales.customers_identidad ON;
INSERT INTO sales.customers_identidad (customer_id, first_name, last_name)
SELECT customer_id, first_name, last_name FROM BikeStores.sales.customers;
SET IDENTITY_INSERT sales.customers_identidad OFF;

-- Customers: fragmento contacto (todos los clientes)
INSERT INTO sales.customers_contacto (customer_id, phone, email, street, city, state, zip_code)
SELECT customer_id, phone, email, street, city, state, zip_code
FROM BikeStores.sales.customers;

-- Orders: parte operativa
SET IDENTITY_INSERT sales.orders_operativo ON;
INSERT INTO sales.orders_operativo (order_id, customer_id, order_status, order_date, store_id, staff_id)
SELECT order_id, customer_id, order_status, order_date, store_id, staff_id
FROM BikeStores.sales.orders
WHERE store_id = 1; -- ← cambiar para cada sucursal
SET IDENTITY_INSERT sales.orders_operativo OFF;

-- Orders: parte logística
INSERT INTO sales.orders_logistico (order_id, required_date, shipped_date)
SELECT order_id, required_date, shipped_date
FROM BikeStores.sales.orders
WHERE store_id = 1; -- ← cambiar para cada sucursal

-- Order_items derivados
INSERT INTO sales.order_items (order_id, item_id, product_id, quantity, list_price, discount)
SELECT oi.order_id, oi.item_id, oi.product_id, oi.quantity, oi.list_price, oi.discount
FROM BikeStores.sales.order_items oi
INNER JOIN BikeStores.sales.orders o ON oi.order_id = o.order_id
WHERE o.store_id = 1; -- ← cambiar para cada sucursal

-- Stocks
INSERT INTO production.stocks (store_id, product_id, quantity)
SELECT store_id, product_id, quantity
FROM BikeStores.production.stocks
WHERE store_id = 1; -- ← cambiar para cada sucursal