/*
============================================================
Criação do Database e Schemas
============================================================

Propósito do Script:
  Este script tem como objetivo apagar e recriar um novo banco de dados chamado "datawarehouse" e os schemas "bronze", "prata" e "ouro" dentro dele, seguindo o padrão da arquitetura medalhão.
  Ele também garante que quaisquer conexões existentes com o banco de dados sejam terminadas antes de recriá-lo, para evitar conflitos.

AVISO:
  Este script irá apagar o banco de dados "datawarehouse" se ele já existir.
  Certifique-se de que não há dados importantes que possam ser perdidos. 

*/

-- Se conectando ao banco postgres, padrão do PostgreSQL
\c postgres;

-- Terminando conexões com o banco, se existirem
DO
$$
BEGIN
    IF EXISTS (SELECT FROM pg_database WHERE datname = 'datawarehouse') THEN
        RAISE NOTICE 'A base de dados "datawarehouse" ja existe. Terminando conexoes...';
        PERFORM pg_terminate_backend(pid)
        FROM pg_stat_activity
        WHERE datname = 'datawarehouse'
          AND pid <> pg_backend_pid();
    END IF;
END
$$;

-- Dropando o banco de dados datawarehouse, se existir
-- Isso é necessário para garantir que o banco de dados seja recriado do zero.
DROP DATABASE IF EXISTS datawarehouse;

-- Criando o banco de dados datawarehouse
CREATE DATABASE datawarehouse;

-- Se conectando ao banco de dados datawarehouse, que acabamos de criar.
\c datawarehouse;

-- Criando os schemas bronze, prata e ouro
CREATE SCHEMA IF NOT EXISTS bronze;
CREATE SCHEMA IF NOT EXISTS prata;
CREATE SCHEMA IF NOT EXISTS ouro;