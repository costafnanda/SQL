update cadastro.lote l 
set id_bairro = b.id
join cadastro.bairro b 
where st_contains(b.geom,st_pointonsurface(l.geom))



update cadastro.logradouro l
set id_bairro = tb.id_bairro
from(select l.id,
case		
	when st_length(st_intersection(l.geom , b_start.geom))>st_length(st_intersection(l.geom , b_end.geom)) then b_start.id
	when st_length(st_intersection(l.geom , b_start.geom))<st_length(st_intersection(l.geom , b_end.geom)) then b_end.id
	when st_length(st_intersection(l.geom , b_start.geom))=st_length(st_intersection(l.geom , b_end.geom)) then b_start.id
end as id_bairro
from cadastro.logradouro l 
join cadastro.bairro b_start on st_contains(b_start.geom,st_startpoint(l.geom))
join cadastro.bairro b_end on st_contains(b_end.geom,st_endpoint(l.geom))) tb
where tb.id=l.id and (l.id_bairro <>tb.id_bairro or l.id_bairro is null)


update controle_interno.area_cadastro ac 
set id_bairro =tb.id
from (select ac.id,ac.geom
,(array_agg(b.id order by st_area(st_intersection(ST_MakeValid(ac.geom),b.geom),true)desc))[1] as id_bairro
from controle_interno.area_cadastro ac 
join cadastro.bairro b on st_intersects(ST_MakeValid(ac.geom),b.geom)
group by ac.id)tb
where tb.id=ac.id and( ac.id_bairro <>tb.id_bairro or ac.id_bairro is null)



create trigger attt_id_bairro_all after insert
or update of geom on
cadastro.bairro for each row execute function cadastro.fnc_at_id_bairro_all()



CREATE OR REPLACE FUNCTION cadastro.fnc_at_id_bairro_all()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
begin
		update controle_interno.area_cadastro ac 
		set id_bairro =tb.id
		from (select ac.id,ac.geom
		,(array_agg(b.id order by st_area(st_intersection(ST_MakeValid(ac.geom),b.geom),true)desc))[1] as id_bairro
		from controle_interno.area_cadastro ac 
		join cadastro.bairro b on st_intersects(ST_MakeValid(ac.geom),b.geom)
		where b.id=new.id
		group by ac.id)tb
		where tb.id=ac.id and( ac.id_bairro <>tb.id_bairro or ac.id_bairro is null);

		update cadastro.lote l 
		set id_bairro = b.id
		from cadastro.bairro b 
		where st_contains(b.geom,st_pointonsurface(l.geom))
		and b.id=new.id;

		update cadastro.logradouro l
		set id_bairro = tb.id_bairro
		from(select l.id,
		case		
			when st_length(st_intersection(l.geom , b_start.geom))>st_length(st_intersection(l.geom , b_end.geom)) then b_start.id
			when st_length(st_intersection(l.geom , b_start.geom))<st_length(st_intersection(l.geom , b_end.geom)) then b_end.id
			when st_length(st_intersection(l.geom , b_start.geom))=st_length(st_intersection(l.geom , b_end.geom)) then b_start.id
		end as id_bairro
		from cadastro.logradouro l 
		join cadastro.bairro b_start on st_contains(b_start.geom,st_startpoint(l.geom))
		join cadastro.bairro b_end on st_contains(b_end.geom,st_endpoint(l.geom))) tb
		where tb.id=l.id and (l.id_bairro <>tb.id_bairro or l.id_bairro is null) and tb.id_bairro=new.id;
		return new;
END;
$function$
;

