/*
============================================================
Testes de Qualidade de Dados da Camada Prata
============================================================

Propósito do Script:
    Este script performa uma variedade de testes de qualidade, consistência,
    normalização e padronização de dados da camada prata. Alguns dos testes são:
    - Teste de chaves primárias duplicadas ou nulas.
    - Teste de espaços extras em colunas de texto.
    - Teste de normalização e padronização de dados.
    - Teste de datas inválidas
    - Teste de consistência de informações entre colunas relacionadas.

Modo de Uso:
    - Utilize este script após o carregamento dos dados da camada prata.
    - Investigue e resolva quaisquer incosistências encontradas durante os testes.
*/

-- =========================================================
-- Testes da prata.crm_clientes_info
-- =========================================================

-- Testando se há duplicatas e valores nulos
SELECT
    clientes_id,
    COUNT(*)
FROM
    prata.crm_clientes_info
GROUP BY
    clientes_id
HAVING
    COUNT(*) > 1 OR clientes_id IS NULL;

-- Testando se há espaços extras nas colunas de nome
SELECT
    *
FROM
    prata.crm_clientes_info
WHERE
    clientes_primeiro_nome != TRIM(clientes_primeiro_nome);

SELECT
    *
FROM
    prata.crm_clientes_info
WHERE
    clientes_ultimo_nome != TRIM(clientes_ultimo_nome);

-- Testando a padronização das colunas de estado civil e sexo
SELECT DISTINCT
    clientes_sexo
FROM
    prata.crm_clientes_info;

SELECT DISTINCT
    clientes_estado_civil
FROM
    prata.crm_clientes_info;

-- =========================================================
-- Testes da prata.crm_produtos_info
-- =========================================================

-- Testando se há duplicatas e valores nulos
SELECT
    produtos_id,
    COUNT(*)
FROM
    prata.crm_produtos_info
GROUP BY
    produtos_id
HAVING
    COUNT(*) > 1 OR
    produtos_id IS NULL;

-- Testando se há valores menores que zero e nulos
SELECT
    produtos_custo
FROM
    prata.crm_produtos_info
WHERE
    produtos_custo < 0 OR
    produtos_custo IS NULL;

-- Testando se há espaços extras nas colunas de nome
SELECT
    *
FROM
    prata.crm_produtos_info
WHERE
    produtos_linha != TRIM(produtos_linha);

SELECT
    *
FROM
    prata.crm_produtos_info
WHERE
    produtos_nome_produto != TRIM(produtos_nome_produto);

-- Testando a padronização da coluna de linha
SELECT DISTINCT
    TRIM(produtos_linha) AS produtos_linha
FROM
    prata.crm_produtos_info;

-- Testando datas não válidas
SELECT
    *
FROM
    prata.crm_produtos_info
WHERE
    produtos_data_final < produtos_data_inicio;

-- =========================================================
-- Testes da prata.crm_vendas_detalhes
-- =========================================================

-- Testando se há valores menores que zero, nulos e inconsistências nas colunas de valores
SELECT
    *
FROM
    prata.crm_vendas_detalhes
WHERE
    vendas_quantidade < 0 OR
    vendas_quantidade IS NULL;

SELECT
    *
FROM
    prata.crm_vendas_detalhes
WHERE
    vendas_valor_venda < 0 OR
    vendas_valor_venda IS NULL;

SELECT
    *
FROM
    prata.crm_vendas_detalhes
WHERE
    vendas_preco < 0 OR
    vendas_preco IS NULL;

SELECT
    *
FROM
    prata.crm_vendas_detalhes
WHERE
    vendas_valor_venda != vendas_quantidade*ABS(vendas_preco);

-- Testando se há espaços extras nas colunas de nome
SELECT
    *
FROM
    prata.crm_vendas_detalhes
WHERE
    vendas_numero_pedido != TRIM(vendas_numero_pedido);

SELECT
    *
FROM
    prata.crm_vendas_detalhes
WHERE
    vendas_produtos_key != TRIM(vendas_produtos_key);

-- Testando datas não válidas
SELECT
    *
FROM
    prata.crm_vendas_detalhes
WHERE
    vendas_data_pedido > vendas_data_envio OR
    vendas_data_pedido > vendas_data_vencimento OR
    vendas_data_envio > vendas_data_vencimento;

-- =========================================================
-- Testes da prata.erp_clientes_info
-- =========================================================

-- Testando padronização da coluna de id
SELECT
    *
FROM
    prata.erp_clientes_info
WHERE
    clientes_id NOT LIKE 'AW%';

-- Testando se há espaços extras nas colunas de nome
SELECT
    *
FROM
    prata.erp_clientes_info
WHERE
    clientes_id != TRIM(clientes_id);

SELECT
    *
FROM
    prata.erp_clientes_info
WHERE
    clientes_sexo != TRIM(clientes_sexo);

-- Testando datas não válidas
SELECT
    *
FROM
    prata.erp_clientes_info
WHERE
    clientes_data_nascimento > CURRENT_DATE;

-- =========================================================
-- Testes da prata.erp_clientes_pais
-- =========================================================

-- Testando padronização das colunas de id e país
SELECT
    clientes_id
FROM
    prata.erp_clientes_pais
WHERE
    clientes_id NOT LIKE 'AW%' OR
    LENGTH(clientes_id) != 10;

SELECT
    clientes_id
FROM
    prata.erp_clientes_pais
WHERE
    clientes_id NOT IN (
        SELECT
            clientes_id
        FROM
            prata.erp_clientes_info
    );

SELECT DISTINCT
    clientes_pais
FROM
    prata.erp_clientes_pais;

-- =========================================================
-- Testes da prata.erp_produtos_cat
-- =========================================================

-- Não há testes a serem feitos. Tabela original com ótima qualidade de dados.