

CREATE OR REPLACE FUNCTION cadastro.fnc_at_geom_null()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
BEGIN
		update  cadastro.imobiliario i set geom=b.geom
		from (select st_centroid(lt.geom) geom,i.id id_imobiliario, lt.id id_lote,i.id_lote id_lote_imo
		from cadastro.lote lt
		join cadastro.imobiliario i on i.id_lote=lt.id and i.geom is null
		and i.ct_cancelamento is not true and i.id=new.id) b 
		where b.id_imobiliario=i.id;
	return new;
END;
$function$
;


CREATE TRIGGER imobiliario_geom_null
after INSERT OR UPDATE of geom ON cadastro.imobiliario
FOR EACH ROW
WHEN (NEW.geom IS null and new.id_lote is not null) --condição dentro da Trigger 
EXECUTE FUNCTION cadastro.fnc_at_geom_null();



