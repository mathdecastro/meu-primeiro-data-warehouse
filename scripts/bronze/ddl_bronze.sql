/*
============================================================
Criação das tabelas da camada bronze
============================================================

Propósito do Script:
    Este script tem como objetivo criar as tabelas da camada bronze do data warehouse, que receberão os dados provenientes das fontes CRM e ERP.
    As tabelas são criadas com base na estrutura dos arquivos CSV que serão utilizados para o carregamento dos dados.

AVISO:
    Este script irá apagar as tabelas existentes na camada bronze antes de recriá-las.
    Certifique-se de que não há dados importantes que possam ser perdidos.
*/

-- Se conectando ao banco de dados
\c datawarehouse;

-- Criando tabela para cust_info.csv
DROP TABLE IF EXISTS bronze.crm_cust_info;
CREATE TABLE bronze.crm_cust_info(
    cst_id INT,
    cst_key VARCHAR(50),
    cst_firstname VARCHAR(50),
    cst_lastname VARCHAR(50),
    cst_marital_status VARCHAR(50),
    cst_gndr VARCHAR(50),
    cst_create_date DATE
);

-- Criando tabela para prd_info.csv
DROP TABLE IF EXISTS bronze.crm_prd_info;
CREATE TABLE bronze.crm_prd_info(
    prd_id INT,
    prd_key VARCHAR(50),
    prd_nm VARCHAR(100),
    prd_cost INT,
    prd_line VARCHAR(50),
    prd_start_date DATE,
    prd_end_date DATE
);

-- Criando tabela para sales_details.csv
DROP TABLE IF EXISTS bronze.crm_sales_details;
CREATE TABLE bronze.crm_sales_details(
    sls_ord_num VARCHAR(50),
    sls_prd_key VARCHAR(50),
    sls_cust_id INT,
    sls_order_dt VARCHAR(50),
    sls_ship_dt VARCHAR(50),
    sls_due_dt VARCHAR(50),
    sls_sales INT,
    sls_quantity INT,
    sls_price INT
);

-- Criando tabela para CUST_AZ12.csv
DROP TABLE IF EXISTS bronze.erp_cust_az12;
CREATE TABLE bronze.erp_cust_az12(
    cid VARCHAR(50),
    bdate DATE,
    gen VARCHAR(50)
);

-- Criando tabela para LOC_A101.csv
DROP TABLE IF EXISTS bronze.erp_loc_a101;
CREATE TABLE bronze.erp_loc_a101(
    cid VARCHAR(50),
    cntry VARCHAR(50)
);

-- Criando tabela para PX_CAT_G1V2.csv
DROP TABLE IF EXISTS bronze.erp_px_cat_g1v2;
CREATE TABLE bronze.erp_px_cat_g1v2(
    id VARCHAR(50),
    cat VARCHAR(50),
    subcat VARCHAR(50),
    maintenance VARCHAR(50)
);
