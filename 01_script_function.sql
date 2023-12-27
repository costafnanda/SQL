--1)função que tras os codigos e descricoes dos dominios

-- FUNCTION: mapeamento_urbano.fc_criar_view_com_joins(text, text)

-- DROP FUNCTION IF EXISTS mapeamento_urbano.fc_criar_view_com_joins(text, text);

CREATE OR REPLACE FUNCTION mapeamento_urbano.fc_criar_view_com_joins(
	nome_view text,
	tabela_principal text)
    RETURNS void
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
coluna_fk record;
colunas_select text := '';
joins text := '';
BEGIN
-- Criação da parte SELECT da view
FOR coluna_fk IN ( 
				  SELECT
   nf.nspname,
  a.attname AS atributo,   
  clf.relname AS tabela_referenciada,   
  af.attname AS coluna_referenciada   
FROM pg_catalog.pg_attribute a   
  JOIN pg_catalog.pg_class cl ON (a.attrelid = cl.oid AND cl.relkind = 'r')
  JOIN pg_catalog.pg_namespace n ON (n.oid = cl.relnamespace)   
  JOIN pg_catalog.pg_constraint ct ON (a.attrelid = ct.conrelid AND   
       ct.confrelid != 0 AND ct.conkey[1] = a.attnum)   
  JOIN pg_catalog.pg_class clf ON (ct.confrelid = clf.oid AND clf.relkind = 'r')
  JOIN pg_catalog.pg_namespace nf ON (nf.oid = clf.relnamespace)   
  JOIN pg_catalog.pg_attribute af ON (af.attrelid = ct.confrelid AND   
       af.attnum = ct.confkey[1])   
WHERE   
   n.nspname||'.'||cl.relname =  tabela_principal)
LOOP
	colunas_select := colunas_select || ', '||coluna_fk.tabela_referenciada||'_'||coluna_fk.atributo||'.code_name as '||coluna_fk.atributo||'_dominio';
	joins := joins || ' LEFT JOIN ' || coluna_fk.nspname||'.'||coluna_fk.tabela_referenciada || ' AS '||coluna_fk.tabela_referenciada||'_'||coluna_fk.atributo||' ON ' ||
			 tabela_principal || '.' || coluna_fk.atributo || ' = ' ||coluna_fk.tabela_referenciada||'_'||coluna_fk.atributo|| '.' || coluna_fk.coluna_referenciada;
END LOOP;

-- Criação da view
EXECUTE 'CREATE OR REPLACE VIEW ' || nome_view || ' AS SELECT ' || tabela_principal || '.*' || colunas_select ||
		' FROM ' || tabela_principal || joins;
END;
$BODY$;

ALTER FUNCTION mapeamento_urbano.fc_criar_view_com_joins(text, text)
    OWNER TO anapaula;

--2)função que tras apenas as descricoes dos dominios

-- FUNCTION: mapeamento_urbano.fc_criar_view_com_joins_teste(text, text)

-- DROP FUNCTION IF EXISTS mapeamento_urbano.fc_criar_view_com_joins_teste(text, text);

CREATE OR REPLACE FUNCTION mapeamento_urbano.fc_criar_view_com_joins_teste(
	nome_view text,
	tabela_principal text)
    RETURNS void
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
coluna_fk record;
coluna_p record;
colunas_select text := '';
colunas_principal text := '';
colunas_select_in text := '';
joins text := '';

BEGIN
-- Criação da parte SELECT da view
FOR coluna_fk IN ( 
				  SELECT
   nf.nspname,
  a.attname AS atributo,   
  clf.relname AS tabela_referenciada,   
  af.attname AS coluna_referenciada   
FROM pg_catalog.pg_attribute a   
  JOIN pg_catalog.pg_class cl ON (a.attrelid = cl.oid AND cl.relkind = 'r')
  JOIN pg_catalog.pg_namespace n ON (n.oid = cl.relnamespace)   
  JOIN pg_catalog.pg_constraint ct ON (a.attrelid = ct.conrelid AND   
       ct.confrelid != 0 AND ct.conkey[1] = a.attnum)   
  JOIN pg_catalog.pg_class clf ON (ct.confrelid = clf.oid AND clf.relkind = 'r')
  JOIN pg_catalog.pg_namespace nf ON (nf.oid = clf.relnamespace)   
  JOIN pg_catalog.pg_attribute af ON (af.attrelid = ct.confrelid AND   
       af.attnum = ct.confkey[1])   
WHERE   
   n.nspname||'.'||cl.relname =  tabela_principal)
LOOP
	colunas_select := colunas_select || ','||coluna_fk.tabela_referenciada||'_'||coluna_fk.atributo||'.code_name as '||coluna_fk.atributo;
	joins := joins || ' LEFT JOIN ' || coluna_fk.nspname||'.'||coluna_fk.tabela_referenciada || ' AS '||coluna_fk.tabela_referenciada||'_'||coluna_fk.atributo||' ON ' ||
			 tabela_principal || '.' || coluna_fk.atributo || ' = ' ||coluna_fk.tabela_referenciada||'_'||coluna_fk.atributo|| '.' || coluna_fk.coluna_referenciada;
  END LOOP;

FOR coluna_p IN ( SELECT * FROM information_schema.columns WHERE
				 table_schema||'.'||table_name=tabela_principal and column_name not in (			  SELECT 
  a.attname AS atributo     
FROM pg_catalog.pg_attribute a   
  JOIN pg_catalog.pg_class cl ON (a.attrelid = cl.oid AND cl.relkind = 'r')
  JOIN pg_catalog.pg_namespace n ON (n.oid = cl.relnamespace)   
  JOIN pg_catalog.pg_constraint ct ON (a.attrelid = ct.conrelid AND   
       ct.confrelid != 0 AND ct.conkey[1] = a.attnum)   
  JOIN pg_catalog.pg_class clf ON (ct.confrelid = clf.oid AND clf.relkind = 'r')
  JOIN pg_catalog.pg_namespace nf ON (nf.oid = clf.relnamespace)   
  JOIN pg_catalog.pg_attribute af ON (af.attrelid = ct.confrelid AND   
       af.attnum = ct.confkey[1])   
WHERE   
   n.nspname||'.'||cl.relname =  tabela_principal)
)loop

colunas_principal := colunas_principal || coluna_p.column_name||',';
RAISE NOTICE 'resutado colunas_principal:%',colunas_principal;
END LOOP;

EXECUTE 'SELECT left('''||colunas_principal||''',-1)' into colunas_principal;
RAISE NOTICE 'resutado colunas_principal:%',colunas_principal;

-- Criação da view
EXECUTE 'CREATE OR REPLACE VIEW ' || nome_view || ' AS SELECT ' || colunas_principal || colunas_select ||
		' FROM ' || tabela_principal || joins;
END;
$BODY$;

ALTER FUNCTION mapeamento_urbano.fc_criar_view_com_joins_teste(text, text)
    OWNER TO anapaula;
