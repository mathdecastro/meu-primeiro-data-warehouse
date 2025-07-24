/*
============================================================
Criação das tabelas da camada prata
============================================================

Propósito do Script:
    Este script tem como objetivo criar as tabelas da camada prata do data warehouse, que receberão os dados provenientes das fontes CRM e ERP.
    As tabelas são criadas com base na estrutura dos arquivos CSV que serão utilizados para o carregamento dos dados.

AVISO:
    Este script irá apagar as tabelas existentes na camada prata antes de recriá-las.
    Certifique-se de que não há dados importantes que possam ser perdidos.
*/

-- Se conectando ao banco de dados
\c datawarehouse;

-- Criando tabela prata.crm_clientes_info utilizando a bronze.crm_cust_info
DROP TABLE IF EXISTS prata.crm_clientes_info;
CREATE TABLE prata.crm_clientes_info(
    clientes_id INT,
    clientes_key VARCHAR(50),
    clientes_primeiro_nome VARCHAR(50),
    clientes_ultimo_nome VARCHAR(50),
    clientes_estado_civil VARCHAR(50),
    clientes_sexo VARCHAR(50),
    clientes_data_cadastro DATE,
    dwh_data_criacao TIMESTAMP DEFAULT CURRENT_DATE
);

-- Criando tabela prata.crm_produtos_info utilizando a bronze.crm_prd_info
DROP TABLE IF EXISTS prata.crm_produtos_info;
CREATE TABLE prata.crm_produtos_info(
    produtos_id INT,
    produtos_key VARCHAR(50),
    produtos_nome_produto VARCHAR(100),
    produtos_custo INT,
    produtos_linha_producao VARCHAR(50),
    produtos_data_inicio DATE,
    produtos_data_final DATE,
    dwh_data_criacao TIMESTAMP DEFAULT CURRENT_DATE
);

-- Criando tabela prata.crm_vendas_detalhes utilizando a bronze.crm_sales_details
DROP TABLE IF EXISTS prata.crm_vendas_detalhes;
CREATE TABLE prata.crm_vendas_detalhes(
    vendas_numero_pedido VARCHAR(50),
    vendas_produtos_key VARCHAR(50),
    vendas_clientes_id INT,
    vendas_data_pedido VARCHAR(50),
    vendas_data_envio VARCHAR(50),
    vendas_data_vencimento VARCHAR(50),
    vendas_valor_venda INT,
    vendas_quantidade INT,
    vendas_preco INT,
    dwh_data_criacao TIMESTAMP DEFAULT CURRENT_DATE
);

-- Criando tabela prata.erp_clientes_info utilizando a bronze.erp_cust_az12
DROP TABLE IF EXISTS prata.erp_clientes_info;
CREATE TABLE prata.erp_clientes_info(
    clientes_id VARCHAR(50),
    clientes_data_nascimento DATE,
    clientes_sexo VARCHAR(50),
    dwh_data_criacao TIMESTAMP DEFAULT CURRENT_DATE
);

-- Criando tabela prata.erp_clientes_pais utilizando a bronze.erp_loc_a101
DROP TABLE IF EXISTS prata.erp_clientes_pais;
CREATE TABLE prata.erp_clientes_pais(
    clientes_id VARCHAR(50),
    clientes_pais VARCHAR(50),
    dwh_data_criacao TIMESTAMP DEFAULT CURRENT_DATE
);

-- Criando tabela prata.erp_produtos_cat utilizando a bronze.erp_px_cat_g1v2
DROP TABLE IF EXISTS prata.erp_produtos_cat;
CREATE TABLE prata.erp_produtos_cat(
    produtos_id VARCHAR(50),
    produtos_categoria_produto VARCHAR(50),
    produtos_subcategoria_produto VARCHAR(50),
    produtos_manutencao VARCHAR(50),
    dwh_data_criacao TIMESTAMP DEFAULT CURRENT_DATE
);
