/*
============================================================
Criação das views da camada ouro
============================================================

Propósito do Script:
    Este script tem como objetivo criar as views da camada ouro do data warehouse.
    A camada ouro contém as tabelas dimensão e fato, que estão limpas e padronizadas.

AVISO:
    Este script irá apagar as views existentes na camada ouro antes de recriá-las.
    Certifique-se de que não há dados importantes que possam ser perdidos.
*/

-- Se conectando ao banco de dados
\c datawarehouse;

-- Criando view ouro.dim_clientes
DROP VIEW IF EXISTS
    ouro.dim_clientes CASCADE;
CREATE VIEW
    ouro.dim_clientes
AS
    SELECT
        ROW_NUMBER() OVER (
            ORDER BY crm_ci.clientes_id
        ) AS clientes_key,
        crm_ci.clientes_id AS id_cliente,
        crm_ci.clientes_key AS cadastro_cliente,
        crm_ci.clientes_primeiro_nome AS primeiro_nome,
        crm_ci.clientes_ultimo_nome AS ultimo_nome,
        crm_ci.clientes_estado_civil AS estado_civil,
        CASE
            WHEN crm_ci.clientes_sexo != 'Unknown' THEN crm_ci.clientes_sexo
            ELSE COALESCE(erp_ci.clientes_sexo, 'Unknown')
        END AS sexo,
        erp_cp.clientes_pais AS pais,
        erp_ci.clientes_data_nascimento AS data_nascimento,
        crm_ci.clientes_data_cadastro AS data_cadastro
    FROM
        prata.crm_clientes_info AS crm_ci
    LEFT JOIN
        prata.erp_clientes_info AS erp_ci ON crm_ci.clientes_key = erp_ci.clientes_id
    LEFT JOIN
        prata.erp_clientes_pais AS erp_cp ON crm_ci.clientes_key = erp_cp.clientes_id;

-- Criando view ouro.dim_produtos
DROP VIEW IF EXISTS
    ouro.dim_produtos CASCADE;
CREATE VIEW
    ouro.dim_produtos
AS
    SELECT
        ROW_NUMBER() OVER (
            ORDER BY crm_pi.produtos_data_inicio
        ) AS produtos_key,
        crm_pi.produtos_id AS id_produto,
        crm_pi.produtos_key AS cadastro_produto,
        crm_pi.produtos_id_categoria AS id_categoria,
        erp_pc.produtos_categoria_produto AS categoria,
        crm_pi.produtos_nome_produto AS nome_produto,
        erp_pc.produtos_subcategoria_produto AS subcategoria,
        crm_pi.produtos_linha AS linha,
        erp_pc.produtos_manutencao AS manutencao,
        crm_pi.produtos_custo AS custo,
        crm_pi.produtos_data_inicio AS data_inicio
    FROM
        prata.crm_produtos_info AS crm_pi
    LEFT JOIN
        prata.erp_produtos_cat AS erp_pc ON crm_pi.produtos_id_categoria = erp_pc.produtos_id
    WHERE
        crm_pi.produtos_data_final IS NULL;

-- Criando view ouro.fato_vendas
DROP VIEW IF EXISTS
    ouro.fato_vendas CASCADE;
CREATE VIEW
    ouro.fato_vendas
AS
    SELECT
        crm_vd.vendas_numero_pedido AS numero_pedido,
        dim_pr.produtos_key AS produtos_key,
        dim_cl.clientes_key AS clientes_key,
        crm_vd.vendas_data_pedido AS data_pedido,
        crm_vd.vendas_data_envio AS data_envio,
        crm_vd.vendas_data_vencimento AS data_vencimento,
        crm_vd.vendas_valor_venda AS valor_venda,
        crm_vd.vendas_quantidade AS quantidade,
        crm_vd.vendas_preco AS preco
    FROM
        prata.crm_vendas_detalhes AS crm_vd
    LEFT JOIN
        ouro.dim_produtos AS dim_pr ON crm_vd.vendas_produtos_key = dim_pr.cadastro_produto
    LEFT JOIN
        ouro.dim_clientes AS dim_cl ON crm_vd.vendas_clientes_id = dim_cl.id_cliente;