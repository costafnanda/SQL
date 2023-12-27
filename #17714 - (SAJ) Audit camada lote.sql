------------------
--insert into cadastro.lote 
select tb.*
from audit.logged_actions la 
cross join lateral json_populate_record(null::cadastro.lote,la.original_data::json) as tb
where la.schema_name ='cadastro'
and la.table_name ='lote'
and la.tabela_id in (34975, 34974, 34972)
and la."action" ='D'
and user_name <>'gabriel_oliveira'


