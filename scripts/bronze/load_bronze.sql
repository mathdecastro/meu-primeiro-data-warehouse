/*
============================================================
Carregamento de Dados na Camada Bronze do Data Warehouse
============================================================

Propósito do Script:
  Este script tem como objetivo carregar dados nas tabelas da camada bronze do data warehouse, utilizando arquivos CSV como fonte.
  Ele realiza a limpeza (truncate) das tabelas de destino antes de inserir os novos dados.
  As tabelas de origem incluem informações do CRM e do ERP.
  O script é executado como um procedimento armazenado para facilitar a execução e manutenção.
*/

-- Se conectando ao banco de dados
\c datawarehouse;

-- Criando o procedimento armazenado para carregar os dados na camada bronze
CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS
$$
DECLARE
    tempo_inicial TIMESTAMP;
    tempo_final TIMESTAMP;
    duracao INTERVAL;
BEGIN
    RAISE NOTICE '=========================================================';
    RAISE NOTICE 'Carregando dados na camada bronze';
    RAISE NOTICE '=========================================================';
    RAISE NOTICE '';
    RAISE NOTICE '---------------------------------------------------------';
    RAISE NOTICE 'Carregando tabelas do CRM';
    RAISE NOTICE '---------------------------------------------------------';

    -- Truncando dados da tabela crm_cust_info
    tempo_inicial := CLOCK_TIMESTAMP();
    RAISE NOTICE '>> Truncando dados da tabela: bronze.crm_cust_info';
    TRUNCATE TABlE bronze.crm_cust_info;

    -- Inserindo dados na tabela crm_cust_info
    RAISE NOTICE '>> Inserindo dados na tabela: bronze.crm_cust_info';
    COPY bronze.crm_cust_info
    FROM 'c:\Users\Antonio Mailson\Desktop\projetos\datawarehouse\data\fonte_crm\cust_info.csv' --Utilizando o usuário Windows do meu irmão :)
    DELIMITER ',' CSV HEADER;
    tempo_final := CLOCK_TIMESTAMP();
    duracao := tempo_final - tempo_inicial;
    RAISE NOTICE '>> Tempo de carregamento (em segundos): %', duracao;
    RAISE NOTICE '';

    -- Truncando dados da tabela crm_prd_info
    tempo_inicial := CLOCK_TIMESTAMP();
    RAISE NOTICE '>> Truncando dados da tabela: bronze.crm_prd_info';
    TRUNCATE TABLE bronze.crm_prd_info;

    -- Inserindo dados na tabela crm_prd_info
    RAISE NOTICE '>> Inserindo dados na tabela: bronze.crm_prd_info';
    COPY bronze.crm_prd_info
    FROM 'c:\Users\Antonio Mailson\Desktop\projetos\datawarehouse\data\fonte_crm\prd_info.csv'
    DELIMITER ',' CSV HEADER;
    tempo_final := CLOCK_TIMESTAMP();
    duracao := tempo_final - tempo_inicial;
    RAISE NOTICE '>> Tempo de carregamento (em segundos): %', duracao;
    RAISE NOTICE '';

    -- Truncando dados da tabela crm_sales_details
    tempo_inicial := CLOCK_TIMESTAMP();
    RAISE NOTICE '>> Truncando dados da tabela: bronze.crm_sales_details';
    TRUNCATE TABLE bronze.crm_sales_details;

    -- Inserindo dados na tabela crm_sales_details
    RAISE NOTICE '>> Inserindo dados na tabela: bronze.crm_sales_details';
    COPY bronze.crm_sales_details
    FROM 'c:\Users\Antonio Mailson\Desktop\projetos\datawarehouse\data\fonte_crm\sales_details.csv'
    DELIMITER ',' CSV HEADER;
    tempo_final := CLOCK_TIMESTAMP();
    duracao := tempo_final - tempo_inicial;
    RAISE NOTICE '>> Tempo de carregamento (em segundos): %', duracao;
    RAISE NOTICE '';

    RAISE NOTICE '---------------------------------------------------------';
    RAISE NOTICE 'Carregando tabelas do ERP';
    RAISE NOTICE '---------------------------------------------------------';

    -- Truncando dados da tabela erp_cust_az12
    tempo_inicial := CLOCK_TIMESTAMP();
    RAISE NOTICE '>> Truncando dados da tabela: bronze.erp_cust_az12';
    TRUNCATE TABLE bronze.erp_cust_az12;

    -- Inserindo dados na tabela erp_cust_az12
    RAISE NOTICE '>> Inserindo dados na tabela: bronze.erp_cust_az12';
    COPY bronze.erp_cust_az12
    FROM 'c:\Users\Antonio Mailson\Desktop\projetos\datawarehouse\data\fonte_erp\CUST_AZ12.csv'
    DELIMITER ',' CSV HEADER;
    tempo_final := CLOCK_TIMESTAMP();
    duracao := tempo_final - tempo_inicial;
    RAISE NOTICE '>> Tempo de carregamento (em segundos): %', duracao;
    RAISE NOTICE '';

    -- Truncando dados da tabela erp_loc_a101
    tempo_inicial := CLOCK_TIMESTAMP();
    RAISE NOTICE '>> Truncando dados da tabela: bronze.erp_loc_a101';
    TRUNCATE TABLE bronze.erp_loc_a101;

    -- Inserindo dados na tabela erp_loc_a101
    RAISE NOTICE '>> Inserindo dados na tabela: bronze.erp_loc_a101';
    COPY bronze.erp_loc_a101
    FROM 'c:\Users\Antonio Mailson\Desktop\projetos\datawarehouse\data\fonte_erp\LOC_A101.csv'
    DELIMITER ',' CSV HEADER;
    tempo_final := CLOCK_TIMESTAMP();
    duracao := tempo_final - tempo_inicial;
    RAISE NOTICE '>> Tempo de carregamento (em segundos): %', duracao;
    RAISE NOTICE '';

    -- Truncando dados da tabela erp_px_cat_g1v2
    tempo_inicial := CLOCK_TIMESTAMP();
    RAISE NOTICE '>> Truncando dados da tabela: bronze.erp_px_cat_g1v2';
    TRUNCATE TABLE bronze.erp_px_cat_g1v2;

    -- Inserindo dados na tabela erp_px_cat_g1v2
    RAISE NOTICE '>> Inserindo dados na tabela: bronze.erp_px_cat_g1v2';
    COPY bronze.erp_px_cat_g1v2
    FROM 'c:\Users\Antonio Mailson\Desktop\projetos\datawarehouse\data\fonte_erp\PX_CAT_G1V2.csv'
    DELIMITER ',' CSV HEADER;
    tempo_final := CLOCK_TIMESTAMP();
    duracao := tempo_final - tempo_inicial;
    RAISE NOTICE '>> Tempo de carregamento (em segundos): %', duracao;
    RAISE NOTICE '';
END;
$$;