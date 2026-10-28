-- ============ INSTRUCCIONES IMPORTANTES ============
-- Este bloque se ejecuta 3 veces, cambiando solo dos cosas:
-- 1) El nombre de la base de datos en el USE (BikeStores_Sucursal1, BikeStores_Sucursal2, BikeStores_Sucursal3)
-- 2) El valor de los CHECKs de store_id (1, 2 o 3)
-- ===================================================

USE BikeStores_Sucursal1; 
GO

CREATE SCHEMA sales;
GO
CREATE SCHEMA production;
GO

-- ============ HORIZONTAL: staffs ============
CREATE TABLE sales.staffs (
    staff_id   INT IDENTITY(1,1) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name  VARCHAR(50) NOT NULL,
    email      VARCHAR(255) NOT NULL UNIQUE,
    phone      VARCHAR(25),
    active     TINYINT NOT NULL,
    store_id   INT NOT NULL,
    manager_id INT,   -- sin FK: un jefe podría estar en otra sucursal
    CONSTRAINT chk_staffs_store CHECK (store_id = 1)   -- ← cambiar para cada sucursal
);

-- ============ VERTICAL: customers (identidad) ============
CREATE TABLE sales.customers_identidad (
    customer_id INT IDENTITY(1,1) PRIMARY KEY,
    first_name  VARCHAR(255) NOT NULL,
    last_name   VARCHAR(255) NOT NULL
);

-- ============ VERTICAL: customers (contacto) ============
CREATE TABLE sales.customers_contacto (
    customer_id INT PRIMARY KEY,   -- misma clave para reconstruir
    phone       VARCHAR(25),
    email       VARCHAR(255) NOT NULL,
    street      VARCHAR(255),
    city        VARCHAR(50),
    state       VARCHAR(25),
    zip_code    VARCHAR(5),
    CONSTRAINT fk_contacto_identidad
        FOREIGN KEY (customer_id) REFERENCES sales.customers_identidad(customer_id)
);

-- ============ HÍBRIDA: orders (operativo) ============
CREATE TABLE sales.orders_operativo (
    order_id     INT IDENTITY(1,1) PRIMARY KEY,
    customer_id  INT,
    order_status TINYINT NOT NULL,
    order_date   DATE NOT NULL,
    store_id     INT NOT NULL,
    staff_id     INT NOT NULL,
    CONSTRAINT chk_orders_store CHECK (store_id = 1),   -- ← cambiar para cada sucursal
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id) REFERENCES sales.customers_identidad(customer_id),
    CONSTRAINT fk_orders_staff
        FOREIGN KEY (staff_id) REFERENCES sales.staffs(staff_id)
);

-- ============ HÍBRIDA: orders (logístico) ============
CREATE TABLE sales.orders_logistico (
    order_id      INT PRIMARY KEY,
    required_date DATE NOT NULL,
    shipped_date  DATE,
    CONSTRAINT fk_logistico_operativo
        FOREIGN KEY (order_id) REFERENCES sales.orders_operativo(order_id)
);

-- ============ HORIZONTAL DERIVADA: order_items ============
-- El FK a orders_operativo garantiza que solo entren detalles
-- de pedidos de ESTA sucursal (junto con el CHECK de orders_operativo).
CREATE TABLE sales.order_items (
    order_id   INT NOT NULL,
    item_id    INT NOT NULL,
    product_id INT NOT NULL,   -- sin FK: productos viven en Central
    quantity   INT NOT NULL,
    list_price DECIMAL(10,2) NOT NULL,
    discount   DECIMAL(4,2) NOT NULL DEFAULT 0,
    PRIMARY KEY (order_id, item_id),
    CONSTRAINT fk_items_order
        FOREIGN KEY (order_id) REFERENCES sales.orders_operativo(order_id)
);

-- ============ HORIZONTAL: stocks ============
CREATE TABLE production.stocks (
    store_id   INT NOT NULL,
    product_id INT NOT NULL,   -- sin FK: productos viven en Central
    quantity   INT,
    PRIMARY KEY (store_id, product_id),
    CONSTRAINT chk_stocks_store CHECK (store_id = 1)   -- ← cambiar para cada sucursal
);