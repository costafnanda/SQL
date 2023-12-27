rollback;
begin transaction; 
update cadastro.imobiliario i
set id_logradouro =tb.original_data::int
from (select l.tabela_id ,l.original_data::json->>'id_logradouro' as original_data,l.new_data::json->>'id_logradouro' as new_data
		from cadastro.imobiliario i
		join audit.logged_actions l on l.schema_name ='cadastro' and l.table_name  ='imobiliario' and l.tabela_id =i.id
		where i.id_logradouro =132156 
		and l.new_data::json->>'id_logradouro' is not null 
		and l.new_data::json->>'id_logradouro' ='132156' and l.user_name='sthefany_henrique') tb
where tb.tabela_id=i.id
commit;