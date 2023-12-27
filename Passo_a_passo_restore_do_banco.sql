--**Passo a passo restore banco

--1) criar banco
CREATE DATABASE seduh
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'pt_BR.UTF-8'
    LC_CTYPE = 'pt_BR.UTF-8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
   Template template0;
 
--2)Criar extensão
CREATE EXTENSION IF NOT EXISTS postgis
    SCHEMA public;
	
--3)Criar schemas

CREATE SCHEMA dominio_mapeamento;

CREATE SCHEMA mapemanto_urbano;
 
 --4) Restore do backup:

--Através do pgadmin ou linha de comando:

Exemplo:
--comando usado pelo linux:
 /usr/lib/postgresql/14/bin/pg_restore --host localhost --port 5432 --username postgres  -d seduh  --verbose /temp/"BKP - seduh-2023-08-04"