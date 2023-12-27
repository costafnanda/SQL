--gera script de criacao da view traduzida
select 'SELECT mapeamento_urbano.fc_criar_view_com_joins(''mapeamento_urbano.vw_'||tablename||''',''mapeamento_urbano.'||tablename||'''); '
from pg_tables where tablename in (SELECT cl.relname
FROM pg_catalog.pg_attribute a   
  JOIN pg_catalog.pg_class cl ON (a.attrelid = cl.oid AND cl.relkind = 'r')
  JOIN pg_catalog.pg_namespace n ON (n.oid = cl.relnamespace)   
  JOIN pg_catalog.pg_constraint ct ON (a.attrelid = ct.conrelid AND   
       ct.confrelid != 0 AND ct.conkey[1] = a.attnum)   
  JOIN pg_catalog.pg_class clf ON (ct.confrelid = clf.oid AND clf.relkind = 'r')
  JOIN pg_catalog.pg_namespace nf ON (nf.oid = clf.relnamespace)   
  JOIN pg_catalog.pg_attribute af ON (af.attrelid = ct.confrelid AND   
       af.attnum = ct.confkey[1])   
where
   n.nspname = 'mapeamento_urbano')
and
schemaname='mapeamento_urbano' and tablename not like '%apl%';

Exemplo:
SELECT mapeamento_urbano.fc_criar_view_com_joins('mapeamento_urbano.vw_cbge_delimitacao_fisica_l'::text, 'mapeamento_urbano.cbge_delimitacao_fisica_l'::text);

--tipo_edificacao

CREATE OR REPLACE VIEW mapeamento_urbano.vw_edf_edificacao_a 
AS 
SELECT mapeamento_urbano.edf_edificacao_a.id,nome,geometriaaproximada,alturaaproximada,geom,pavimento,numeropavimentos,
id_lote,area,beiral_tam,auxiliar_beiral.code_name as beiral,auxiliar_cultura.code_name as cultura,
mat_constr_matconstr.code_name as matconstr,auxiliar_operacional.code_name as operacional,
situacao_fisica_situacaofisica.code_name as situacaofisica,auxiliar_turistica.code_name as turistica,
tipo_edificacao_tipo_edificacao.descricao as tipo_edificacao 
FROM mapeamento_urbano.edf_edificacao_a 
LEFT JOIN dominio_mapeamento.auxiliar AS auxiliar_beiral ON mapeamento_urbano.edf_edificacao_a.beiral = auxiliar_beiral.code 
LEFT JOIN dominio_mapeamento.auxiliar AS auxiliar_cultura ON mapeamento_urbano.edf_edificacao_a.cultura = auxiliar_cultura.code 
LEFT JOIN dominio_mapeamento.mat_constr AS mat_constr_matconstr ON mapeamento_urbano.edf_edificacao_a.matconstr = mat_constr_matconstr.code 
LEFT JOIN dominio_mapeamento.auxiliar AS auxiliar_operacional ON mapeamento_urbano.edf_edificacao_a.operacional = auxiliar_operacional.code 
LEFT JOIN dominio_mapeamento.situacao_fisica AS situacao_fisica_situacaofisica ON mapeamento_urbano.edf_edificacao_a.situacaofisica = situacao_fisica_situacaofisica.code 
LEFT JOIN dominio_mapeamento.auxiliar AS auxiliar_turistica ON mapeamento_urbano.edf_edificacao_a.turistica = auxiliar_turistica.code
LEFT JOIN dominio_mapeamento.tipo_edificacao AS tipo_edificacao_tipo_edificacao ON mapeamento_urbano.edf_edificacao_a.tipo_edificacao = tipo_edificacao_tipo_edificacao.id

----------------------
--verifica quais tabelas que não teve view criada