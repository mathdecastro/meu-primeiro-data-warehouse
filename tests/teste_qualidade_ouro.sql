/*
============================================================
Testes de Qualidade de Dados da Camada Ouro
============================================================

Propósito do Script:
    Este script performa testes básicos de qualidade de integração
    de dados da camada ouro. Alguns dos testes são:
    - Teste de chaves substitutas (surrogate keys) duplicadas.
    - Teste de integração de dados.

Modo de Uso:
    - Utilize este script após o carregamento dos dados da camada ouro.
    - Investigue e resolva quaisquer incosistências encontradas durante os testes.
*/

-- =========================================================
-- Teste da ouro.dim_clientes
-- =========================================================

-- Testando se há dados duplicados
SELECT
    clientes_key,
    COUNT(*)
FROM
    ouro.dim_clientes
GROUP BY
    clientes_key
HAVING
    COUNT(*) > 1;

-- =========================================================
-- Teste da ouro.dim_produtos
-- =========================================================

-- Testando se há dados duplicados
SELECT
    produtos_key,
    COUNT(*)
FROM
    ouro.dim_produtos
GROUP BY
    produtos_key
HAVING
    COUNT(*) > 1;

-- =========================================================
-- Teste da ouro.fato_vendas
-- =========================================================

-- Testando a integração entre a fato e as dimensões
SELECT
    *
FROM
    ouro.fato_vendas AS vendas
LEFT JOIN
    ouro.dim_clientes AS clientes ON vendas.clientes_key = clientes.clientes_key
LEFT JOIN
    ouro.dim_produtos AS produtos ON vendas.produtos_key = produtos.produtos_key
WHERE
    clientes.clientes_key IS NULL OR
    produtos.produtos_key IS NULL;