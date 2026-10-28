USE BikeStores_Central;
GO

SET IDENTITY_INSERT production.categories ON;
INSERT INTO production.categories (category_id, category_name)
SELECT category_id, category_name FROM BikeStores.production.categories;
SET IDENTITY_INSERT production.categories OFF;

SET IDENTITY_INSERT production.brands ON;
INSERT INTO production.brands (brand_id, brand_name)
SELECT brand_id, brand_name FROM BikeStores.production.brands;
SET IDENTITY_INSERT production.brands OFF;

SET IDENTITY_INSERT production.products ON;
INSERT INTO production.products (product_id, product_name, brand_id, category_id, model_year, list_price)
SELECT product_id, product_name, brand_id, category_id, model_year, list_price
FROM BikeStores.production.products;
SET IDENTITY_INSERT production.products OFF;

SET IDENTITY_INSERT sales.stores ON;
INSERT INTO sales.stores (store_id, store_name, phone, email, street, city, state, zip_code)
SELECT store_id, store_name, phone, email, street, city, state, zip_code
FROM BikeStores.sales.stores;
SET IDENTITY_INSERT sales.stores OFF;