-- ============================================================
-- 01_create_database.sql
-- Purpose : Create the Enterprise Retail Sales database
-- Run     : First script to execute
-- ============================================================
DROP DATABASE IF EXISTS retail_sales_db;

CREATE DATABASE retail_sales_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_general_ci;

USE retail_sales_db;
