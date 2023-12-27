CREATE OR REPLACE FUNCTION cadastro.func_att_status_proprietario_imob_visita()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER AS
$$
BEGIN
   update cadastro.imobiliario i 
	set status_proprietario =  tb.status_proprietario 
	from (select v.id_imobiliario ,(array_agg(v.status_proprietario order by v.id_imobiliario desc))[1] as status_proprietario
	from cadastro.visitas v 
	where id_imobiliario is not null
	and v.status_proprietario is not null
	group by v.id_imobiliario) tb
	where i.id=tb.id_imobiliario
	and i.id =new.id_imobiliario;
	4fee9af2-3655-41d0-85c2-d71c6db4644aRETURN NEW;
	raise notice 'Status Proprietario Do Imobiliario: % Atualizado',new.id_imobiliario;
END;
$$
;

create trigger visita_status_proprietario_audit_trg after
insert or update on cadastro.visitas  
for each row when (new.status_proprietario is not null) 
execute function cadastro.func_att_status_proprietario_imob_visita();



