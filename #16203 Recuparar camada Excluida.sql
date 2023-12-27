explain
select la.original_data::json->>'id' as id
,la.original_data::json->>'nome' as nome
,la.original_data::json->>'geometriaaproximada' as geometriaaproximada
,la.original_data::json->>'classificacaoporte' as classificacaoporte
,la.original_data::json->>'antropizada' as antropizada
,la.original_data::json->>'densidade' as densidade
,la.original_data::json->>'secundaria' as secundaria
,la.original_data::json->>'vereda' as vereda
,st_geomfromgeojson(la.original_data::json->'geom') as geom
from audit.logged_actions la 
where la.schema_name='mapeamento_urbano'
and la.table_name ='veg_cerrado_a'
and action_tstamp::date  ='2023-07-12'
and "action"='D'


pg_restore --host 10.61.112.11 --port 5433 --username gabriel_oliveira -d seduh_teste -n mapeamento_urbano -t veg_cerrado_a --verbose /bkpcomp/10_61_128_11/DIARIO/BKP_seduh_20230703.compressed


--acelera Consulta No audit
CREATE INDEX sidx_logged_actions_tabela_id 
ON audit.logged_actions 
USING btree (schema_name, table_name, tabela_id);

