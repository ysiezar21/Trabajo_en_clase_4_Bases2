USE BikeStores_Central;
GO

CREATE SCHEMA production;
GO
CREATE SCHEMA sales;
GO

-- Catálogos corporativos
CREATE TABLE production.categories (
    category_id   INT IDENTITY(1,1) PRIMARY KEY,
    category_name VARCHAR(255) NOT NULL
);

CREATE TABLE production.brands (
    brand_id   INT IDENTITY(1,1) PRIMARY KEY,
    brand_name VARCHAR(255) NOT NULL
);

CREATE TABLE production.products (
    product_id   INT IDENTITY(1,1) PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    brand_id     INT NOT NULL,
    category_id  INT NOT NULL,
    model_year   SMALLINT NOT NULL,
    list_price   DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (category_id) REFERENCES production.categories(category_id),
    FOREIGN KEY (brand_id)    REFERENCES production.brands(brand_id)
);

-- Sucursales (referencia corporativa)
CREATE TABLE sales.stores (
    store_id   INT IDENTITY(1,1) PRIMARY KEY,
    store_name VARCHAR(255) NOT NULL,
    phone      VARCHAR(25),
    email      VARCHAR(255),
    street     VARCHAR(255),
    city       VARCHAR(255),
    state      VARCHAR(10),
    zip_code   VARCHAR(5)
);