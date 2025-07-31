/*
============================================================
Carregamento de Dados na Camada Prata do Data Warehouse
============================================================

Propósito do Script:
  Este script tem como objetivo carregar dados nas tabelas da camada prata do data warehouse, utilizando dados da camada bronze como fonte.
  Ele realiza a limpeza (truncate) das tabelas de destino antes de inserir os novos dados padronizados, normalizados e limpos.
  O script é executado como um procedimento armazenado para facilitar a execução e manutenção.
*/

-- Se conectando ao banco de dados
\c datawarehouse;

-- Criando o procedimento armazenado para carregar os dados da camada bronze na camada prata
CREATE OR REPLACE PROCEDURE prata.load_prata()
LANGUAGE plpgsql
AS
$$
DECLARE
    tempo_inicial TIMESTAMP;
    tempo_final TIMESTAMP;
    duracao INTERVAL;
BEGIN
    RAISE NOTICE '=========================================================';
    RAISE NOTICE 'Carregando dados da camada bronze na camada prata';
    RAISE NOTICE '=========================================================';
    RAISE NOTICE '';
    RAISE NOTICE '---------------------------------------------------------';
    RAISE NOTICE 'Aplicando transformacoes e carregando dados do CRM';
    RAISE NOTICE '---------------------------------------------------------';

    -- Truncando dados da tabela crm_clientes_info
    tempo_inicial := CLOCK_TIMESTAMP();
    RAISE NOTICE '>> Truncando dados da tabela: prata.crm_clientes_info';
    TRUNCATE TABlE prata.crm_clientes_info;

    -- Inserindo dados na tabela crm_clientes_info
    RAISE NOTICE '>> Inserindo dados na tabela: prata.crm_clientes_info';
    INSERT INTO
        prata.crm_clientes_info(
            clientes_id,
            clientes_key,
            clientes_primeiro_nome,
            clientes_ultimo_nome,
            clientes_sexo,
            clientes_estado_civil,
            clientes_data_cadastro
        )
    SELECT
        cst_id,
        cst_key,
        TRIM(cst_firstname) AS cst_firstname, -- Limpeza: Retirando espaços extras nesta coluna
        TRIM(cst_lastname) AS cst_lastname, -- Limpeza: Retirando espaços extras nesta coluna
        CASE
            WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male' -- Limpeza e Padronização: Se for M, então é Married (Masculino)
            WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female' -- Limpeza e Padronização: Se for F, então é Female (Feminino)
            ELSE 'Unknown' -- Limpeza e Padronização: Se não for nenhum dos anteriores, então é Unknown (Desconhecido)
        END AS cst_gndr,
        CASE
            WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married' -- Limpeza e Padronização: Se for M, então é Married (Casado)
            WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single' -- Limpeza e Padronização: Se for S, então é Single (Solteiro)
            ELSE 'Unknown' -- Limpeza e Padronização: Se não for nenhum dos anteriores, então é Unknown (Desconhecido)
        END AS cst_marital_status,
        cst_create_date
    FROM
        (SELECT
            *,
            ROW_NUMBER() OVER ( -- Limpeza: Window Function para rastrear clientes com dados duplicados, para depois retornar somente os dados mais recentes destes clientes
                PARTITION BY cst_id
                ORDER BY cst_create_date DESC
            ) AS ranking
        FROM
            bronze.crm_cust_info)
    WHERE
        ranking = 1 AND cst_id IS NOT NULL;
    tempo_final := CLOCK_TIMESTAMP();
    duracao := tempo_final - tempo_inicial;
    RAISE NOTICE '>> Tempo de carregamento (em segundos): %', duracao;
    RAISE NOTICE '';

    -- Truncando dados da tabela crm_produtos_info
    tempo_inicial := CLOCK_TIMESTAMP();
    RAISE NOTICE '>> Truncando dados da tabela: prata.crm_produtos_info';
    TRUNCATE TABlE prata.crm_produtos_info;

    -- Inserindo dados na tabela crm_produtos_info
    RAISE NOTICE '>> Inserindo dados na tabela: prata.crm_produtos_info';
    INSERT INTO
        prata.crm_produtos_info(
            produtos_id,
            produtos_key,
            produtos_nome_produto,
            produtos_custo,
            produtos_linha,
            produtos_data_inicio,
            produtos_data_final,
            produtos_id_categoria
        )
    SELECT
        prd_id,
        SUBSTR(prd_key, 7, LENGTH(prd_key)) AS prd_key, -- Coluna Derivada: Extraindo uma chave primária da antiga coluna prd_key
        TRIM(prd_nm) AS prd_nm, -- Limpeza: Retirando espaços extras nesta coluna
        NULLIF(prd_cost, 0) AS prd_cost, -- Limpeza: Se o custo do produto for nulo, então é zero
        CASE UPPER(TRIM(prd_line))
            WHEN 'R' THEN 'Road' -- Limpeza e Padronização: Se for R, então é Road
            WHEN 'M' THEN 'Mountain' -- Limpeza e Padronização: Se for M, então é Mountain
            WHEN 'T' THEN 'Touring' -- Limpeza e Padronização: Se for T, então é Touring
            WHEN 'S' THEN 'Other Sales' -- Limpeza e Padronização: Se for S, então é Other Sales
            ELSE 'Unknown' -- Limpeza e Padronização: Se não for nenhum dos anteriores, então é Unknown
        END AS prd_line,
        prd_start_date,
        LEAD(prd_start_date) OVER ( -- Limpeza e Coluna Derivada: Utilizando a coluna de data de início do preço de um produto para criar a data final do preço deste produto
            PARTITION BY prd_key
            ORDER BY prd_start_date ASC
        ) - 1 AS prd_end_date,
        REPLACE(SUBSTR(prd_key, 1, 5), '-', '_') AS prd_idcat -- Coluna Derivada: Extraindo a categoria do produto da antiga coluna prd_key
    FROM
        bronze.crm_prd_info;
    tempo_final := CLOCK_TIMESTAMP();
    duracao := tempo_final - tempo_inicial;
    RAISE NOTICE '>> Tempo de carregamento (em segundos): %', duracao;
    RAISE NOTICE '';

    -- Truncando dados da tabela crm_vendas_detalhes
    tempo_inicial := CLOCK_TIMESTAMP();
    RAISE NOTICE '>> Truncando dados da tabela: prata.crm_vendas_detalhes';
    TRUNCATE TABlE prata.crm_vendas_detalhes;

    -- Inserindo dados na tabela crm_vendas_detalhes
    RAISE NOTICE '>> Inserindo dados na tabela: prata.crm_vendas_detalhes';
    INSERT INTO
        prata.crm_vendas_detalhes(
            vendas_numero_pedido,
            vendas_produtos_key,
            vendas_clientes_id,
            vendas_data_pedido,
            vendas_data_envio,
            vendas_data_vencimento,
            vendas_valor_venda,
            vendas_quantidade,
            vendas_preco
        )
    SELECT
        sls_ord_num,
        sls_prd_key,
        sls_cust_id,
        CASE
            WHEN CAST(sls_order_dt AS INTEGER) = 0 THEN NULL
            WHEN LENGTH(sls_order_dt) != 8 THEN NULL
            ELSE TO_DATE(sls_order_dt, 'YYYYMMDD')
        END AS sls_order_dt,
        CASE
            WHEN CAST(sls_ship_dt AS INTEGER) = 0 THEN NULL
            WHEN LENGTH(sls_ship_dt) != 8 THEN NULL
            ELSE TO_DATE(sls_ship_dt, 'YYYYMMDD')
        END AS sls_ship_dt,
        CASE
            WHEN CAST(sls_due_dt AS INTEGER) = 0 THEN NULL
            WHEN LENGTH(sls_due_dt) != 8 THEN NULL
            ELSE TO_DATE(sls_due_dt, 'YYYYMMDD')
        END AS sls_due_dt,
        CASE
            WHEN sls_sales IS NULL THEN sls_quantity*ABS(sls_price)
            WHEN sls_sales <= 0 THEN sls_quantity*ABS(sls_price)
            WHEN sls_sales != sls_quantity*ABS(sls_price) THEN sls_quantity*ABS(sls_price)
            ELSE sls_sales
        END AS sls_sales,
        sls_quantity,
        CASE
            WHEN sls_price IS NULL THEN sls_sales/NULLIF(sls_quantity, 0) 
            WHEN sls_price <= 0 THEN sls_sales/NULLIF(sls_quantity, 0)
            ELSE sls_price
        END AS sls_price
    FROM
        bronze.crm_sales_details;
    tempo_final := CLOCK_TIMESTAMP();
    duracao := tempo_final - tempo_inicial;
    RAISE NOTICE '>> Tempo de carregamento (em segundos): %', duracao;
    RAISE NOTICE '';

    RAISE NOTICE '---------------------------------------------------------';
    RAISE NOTICE 'Aplicando transformacoes e carregando dados do ERP';
    RAISE NOTICE '---------------------------------------------------------';

    -- Truncando dados da tabela erp_clientes_info
    tempo_inicial := CLOCK_TIMESTAMP();
    RAISE NOTICE '>> Truncando dados da tabela: prata.erp_clientes_info';
    TRUNCATE TABlE prata.erp_clientes_info;

    -- Inserindo dados na tabela erp_clientes_info
    RAISE NOTICE '>> Inserindo dados na tabela: prata.erp_clientes_info';
    INSERT INTO
        prata.erp_clientes_info(
            clientes_id,
            clientes_data_nascimento,
            clientes_sexo
        )
    SELECT
        CASE
            WHEN cid LIKE 'NAS%' THEN SUBSTR(cid, 4, LENGTH(cid))
            ELSE cid
        END AS cid,
        CASE
            WHEN bdate > current_date THEN NULL
            ELSE bdate
        END AS bdate,
        CASE
            WHEN UPPER(TRIM(gen)) LIKE 'M%' THEN 'Male'
            WHEN UPPER(TRIM(gen)) LIKE 'F%' THEN 'Female'
            ELSE 'Unknown'
        END AS gen
    FROM
        bronze.erp_cust_az12;
    tempo_final := CLOCK_TIMESTAMP();
    duracao := tempo_final - tempo_inicial;
    RAISE NOTICE '>> Tempo de carregamento (em segundos): %', duracao;
    RAISE NOTICE '';

    -- Truncando dados da tabela erp_clientes_pais
    tempo_inicial := CLOCK_TIMESTAMP();
    RAISE NOTICE '>> Truncando dados da tabela: prata.erp_clientes_pais';
    TRUNCATE TABlE prata.erp_clientes_pais;

    -- Inserindo dados na tabela erp_clientes_pais
    RAISE NOTICE '>> Inserindo dados na tabela: prata.erp_clientes_pais';
    INSERT INTO
        prata.erp_clientes_pais(
            clientes_id,
            clientes_pais
        )
    SELECT
        REPLACE(cid, '-', CAST('' AS VARCHAR)) AS cid,
        CASE
            WHEN UPPER(TRIM(cntry)) IN ('US', 'USA', 'UNITED STATES', 'UNITED STATES OF AMERICA', 'AMERICA') THEN 'United States'
            WHEN UPPER(TRIM(cntry)) IN ('UK', 'UNITED KINGDOM') THEN 'United Kingdom'
            WHEN UPPER(TRIM(cntry)) IN ('DE', 'DEUTSCHLAND', 'GERMANY') THEN 'Germany'
            WHEN UPPER(TRIM(cntry)) IN ('CANADA') THEN 'Canada'
            WHEN UPPER(TRIM(cntry)) IN ('FRANCE') THEN 'France'
            WHEN UPPER(TRIM(cntry)) IN ('AUSTRALIA') THEN 'Australia'
            WHEN UPPER(TRIM(cntry)) = '' THEN 'Unknown'
            WHEN UPPER(TRIM(cntry)) IS NULL THEN 'Unknown'
            ELSE cntry
        END AS cntry
    FROM
        bronze.erp_loc_a101;
    tempo_final := CLOCK_TIMESTAMP();
    duracao := tempo_final - tempo_inicial;
    RAISE NOTICE '>> Tempo de carregamento (em segundos): %', duracao;
    RAISE NOTICE '';

    -- Truncando dados da tabela erp_produtos_cat
    tempo_inicial := CLOCK_TIMESTAMP();
    RAISE NOTICE '>> Truncando dados da tabela: prata.erp_produtos_cat';
    TRUNCATE TABlE prata.erp_produtos_cat;

    -- Inserindo dados na tabela erp_produtos_cat
    RAISE NOTICE '>> Inserindo dados na tabela: prata.erp_produtos_cat';
    INSERT INTO
        prata.erp_produtos_cat(
            produtos_id,
            produtos_categoria_produto,
            produtos_subcategoria_produto,
            produtos_manutencao
        )
    SELECT
        id,
        cat,
        subcat,
        maintenance
    FROM
        bronze.erp_px_cat_g1v2;
    tempo_final := CLOCK_TIMESTAMP();
    duracao := tempo_final - tempo_inicial;
    RAISE NOTICE '>> Tempo de carregamento (em segundos): %', duracao;
    RAISE NOTICE '';
END;
$$;