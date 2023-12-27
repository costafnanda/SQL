--Atualiza o id_bairro em lote quando tem alteração da geometria na camada bairro
CREATE OR REPLACE FUNCTION cadastro.fnc_at_id_bairro_lt_bairro()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
BEGIN
		update cadastro.lote l 
		set id_bairro =b.id
		from cadastro.bairro b 
		where st_contains(b.geom,st_centroid(l.geom))
		and b.id = new.id;
		return new;
END;
$function$
;



create trigger bairro_at_id_bairro_lt_bairro after
insert
    or
update
    on
    cadastro.bairro for each row execute function cadastro.fnc_at_id_bairro_lt_bairro();
