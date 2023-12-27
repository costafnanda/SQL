select la.user_name,la.action_tstamp::Date ,count(1)
from mapeamento_urbano.df_lote_a lt 
join mapeamento_urbano.edf_edificacao_a ed on st_contains(lt.geom,ed.geom)
join audit.logged_actions la on la.tabela_id =ed.id and  la.table_name = 'edf_edificacao_a'
where la.action_tstamp::Date ='2023-09-06'
group by la.user_name ,la.action_tstamp::Date 
