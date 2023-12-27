

-----------------------------QGIS Filtro-----------------------------
"codigo"  IN (select l.codigo
											from cadastro.logradouro l 
											group by l.codigo  
											having true = any(array_agg(l.inicio_trecho)) 
											and true = any(array_agg(l.fim_trecho)))

-----------------------------Esquerdo Direito-----------------------------
WITH
     cent as (
        SELECT st_lineinterpolatepoint(geom, 0.5) as geom, id 
            FROM cadastro.testada_lote as td
            where td.principal and td.lado is null
            and td.id_lote in(select distinct lt.id
							   from cadastro.imobiliario i 
							   join cadastro.lote lt on st_contains(lt.geom,i.geom)
							   join cadastro.logradouro l on i.id_logradouro = l.id 
							   where l.codigo in (   select l.codigo
											from cadastro.logradouro l 
											group by l.codigo  
											having true = any(array_agg(l.inicio_trecho)) 
											and true = any(array_agg(l.fim_trecho)))
  ))
    , ps as (
        SELECT 
			case 
				WHEN ii.v >= 0.0001 then ST_LineInterpolatePoint(ii.lgeom, ii.v - 0.0001) :: geometry
				ELSE ST_LineInterpolatePoint(ii.lgeom, ii.v) :: geometry 
			end pa,
			case 
				WHEN ii.v >= 0.0001 then ST_LineInterpolatePoint(ii.lgeom, ii.v)
				else ST_LineInterpolatePoint(ii.lgeom, ii.v + 0.0001)
			end pb,
            cent.geom :: geometry pc,
            cent.id as td_id, 
            ii.id as lg_id
        FROM 
            cent 
            LEFT JOIN LATERAL (
            SELECT ST_LineLocatePoint(lg.geom, cent.geom) as v, lg.id as id, lg.geom as lgeom, coalesce(lg.secao, 1) sc
                FROM 
                    cadastro.logradouro as lg 
                ORDER BY ST_Distance(lg.geom :: geography, cent.geom :: geography) ASC
                LIMIT 1 ) ii ON True
            )
    , det as (
        SELECT 
            (ST_X(ps.pb) - ST_X(ps.pa)) * (ST_Y(ps.pc) - ST_Y(ps.pa)) - (ST_Y(ps.pb) - ST_Y(ps.pa)) * (ST_X(ps.pc) - ST_X(ps.pa)) v,
            td_id
        FROM ps
        )
UPDATE  cadastro.testada_lote
    SET  lado =
        CASE
            WHEN det.v > 0 THEN 'E' --Esquerda
            WHEN det.v < 0 THEN 'D' --Direita
            ELSE '0' --
        END
    FROM det
    WHERE 
		id = det.td_id
    RETURNING id, lado;
											
											
-----------------------------Melhor desepenho-----------------------------
CREATE OR REPLACE VIEW stage.nr_porta_inicio_fim_trecho_definitivo as 
select distinct lt.id as id_lote 
,log.codigo
,tl.lado  
,case 
	when row_number () over(partition by log.codigo,nr_porta.nr_porta)=2 then nr_porta.nr_porta+2 
	else nr_porta.nr_porta --para quando o numero de porta e repitido ele vai adicionar mais 2 
end as nr_porta
,line.geom
from cadastro.lote lt 
join cadastro.imobiliario imo on st_contains(lt.geom,imo.geom)
join cadastro.logradouro log on imo.id_logradouro =log.id
join cadastro.testada_lote tl on tl.id_lote =lt.id and tl.principal 
join lateral(select log.id as inicio_trecho_id
					,tb2.fim_trecho_id
					,log.codigo
					,tb2.array_agg as array_seg	
					,st_makeline(log.geom,fim_trecho_geom) as geom_logradouro
				from cadastro.logradouro log
				join lateral(select * 
							 from cadastro.logradouro l2 
							 where log.codigo=l2.codigo and l2.fim_trecho 
							 order by st_distance(log.geom,l2.geom,true)  limit 1) tb on true			 
				join lateral(select log.codigo ,array_agg(l2.id)
									,(array_agg(l2.id) filter(where l2.fim_trecho is true))[1] as fim_trecho_id
									,(array_agg(l2.geom) filter(where l2.fim_trecho is true))[1] as fim_trecho_geom
							 from cadastro.logradouro l2 
							 where log.codigo=l2.codigo
							and st_intersects(st_buffer(st_makeline(log.geom,tb.geom)::geography,50)::geometry,l2.geom)
							group by log.codigo ) tb2 on true 
							where log.inicio_trecho is true) tb on tb.codigo = log.codigo and imo.id_logradouro  =any(tb.array_seg)
cross join lateral(select round(st_length(st_makeline(st_startpoint(tb.geom_logradouro),st_closestpoint(tb.geom_logradouro,st_endpoint(tl.geom))),true)::numeric)) as nr(nr_porta)
cross join lateral (select st_makeline(st_endpoint(tl.geom),st_closestpoint(tb.geom_logradouro,st_endpoint(tl.geom)))) as line(geom)
cross join lateral(select CASE
				            WHEN (nr.nr_porta % 2::numeric) = 0::numeric AND tl.lado = 'D'::text THEN nr.nr_porta
				            WHEN (nr.nr_porta % 2::numeric) <> 0::numeric AND tl.lado = 'D'::text THEN nr.nr_porta + 1::numeric
				            WHEN (nr.nr_porta % 2::numeric) = 0::numeric AND tl.lado = 'E'::text THEN nr.nr_porta - 1::numeric
				            WHEN (nr.nr_porta % 2::numeric) <> 0::numeric AND tl.lado = 'E'::text THEN nr.nr_porta
				            ELSE nr.nr_porta
				        END AS nr_porta) as nr_porta






---criar um array de Id_logradouro com base no inicio e no final mais proximo 
--- isso resolve o problema da propria query que dava problema quando tinha um logradouro como o mesmo mas distantes um do outro
				        
select log.id as inicio_trecho_id
	,tb2.fim_trecho_id
	,log.codigo
	,tb2.array_agg as array_seg	
	,st_makeline(log.geom,fim_trecho_geom) as geom_logradouro
from cadastro.logradouro log
join lateral(select * 
			 from cadastro.logradouro l2 
			 where log.codigo=l2.codigo and l2.fim_trecho 
			 order by st_distance(log.geom,l2.geom,true)  limit 1) tb on true			 
join lateral(select log.codigo ,array_agg(l2.id)
					,(array_agg(l2.id) filter(where l2.fim_trecho is true))[1] as fim_trecho_id
					,(array_agg(l2.geom) filter(where l2.fim_trecho is true))[1] as fim_trecho_geom
			 from cadastro.logradouro l2 
			 where log.codigo=l2.codigo
			and st_intersects(st_buffer(st_makeline(log.geom,tb.geom)::geography,50)::geometry,l2.geom)
			group by log.codigo ) tb2 on true
where log.inicio_trecho is true



-----------------------------Update-----------------------------
begin transaction
rollback
update cadastro.lote lt 
set nr_porta_topo =nr.nr_porta 
from stage.nr_porta_inicio_fim_trecho_definitivo nr
where nr.id_lote=lt.id
and nr.codigo='203443'
returning lt.id,lt.nr_porta_topo



-------Não funcionou legal-----
------ as  vezes pega certo as vezes mas se for um seguimento muito extenso demora muito
WITH RECURSIVE connected_lines AS (
	SELECT
	    l.id AS start_id,
	    l.geom AS start_geom,
	    l.geom AS current_geom,
	    l.codigo ,
	    ARRAY[l.id] AS path,
	    1 AS depth
	FROM cadastro.logradouro l
	where  l.inicio_trecho 
    UNION ALL
    SELECT
        cl.start_id,
        cl.start_geom,
        ls.geom AS current_geom,
        cl.codigo,
        path || ls.id,
        depth + 1
    FROM connected_lines cl
    JOIN cadastro.logradouro ls ON  cl.current_geom && st_buffer(ls.geom::geography,100)::geometry
    and  ST_DWithin(cl.current_geom,ls.geom,100,true) 
	WHERE NOT ls.id = ANY(path) and ls.codigo =cl.codigo )
SELECT distinct on (start_id) start_id, start_geom, current_geom,codigo, path, depth
FROM connected_lines cl
ORDER BY start_id, codigo,depth DESC




/*
---------------------------Teste Numeração  com generate_series que percore cada metro do logradouro
with logradouro as (
select l.codigo ,st_linemerge(st_union(l.geom)) as geom ,st_length(st_union(l.geom),true) as tamanho
from cadastro.logradouro l  
--where l.codigo ='203443'
group by l.codigo
having GeometryType(st_linemerge(st_union(l.geom)) )='MULTILINESTRING'),
nr_porta as (
select *
, st_distance(testada_end,point.polate,true) as distancia
, st_length(st_makeline(st_startpoint(geom),point.polate),true)::numeric as nr_porta
, point as point_logradouro
, st_makeline(testada_end,point.polate)as  linha_testada_logradouro
from logradouro l
join(select l.id,log.codigo,i.id_logradouro ,  (tl.geom) as testada_end ,l.geom as lote_geom
		from cadastro.imobiliario i 
		join cadastro.lote l on st_contains(l.geom,i.geom)
		join cadastro.testada_lote tl on tl.id_lote=l.id
		join cadastro.logradouro log on log.id=i.id_logradouro 
		--where l.id = 156733
		) tb on tb.codigo=l.codigo
cross join lateral generate_series(0::numeric,1::numeric,1.0/tamanho::numeric) as serie
cross join lateral (select ST_LineInterpolatePoint(l.geom,serie) as polate ) as point )
select id
,(array_agg(distancia order by distancia))[1] as distancia
,(array_agg(nr_porta::int order by distancia))[1] as nr_porta
,(array_agg(linha_testada_logradouro order by distancia))[1] as linha_testada_logradouro
,(array_agg(testada_end order by distancia))[1] as testada_end
,(array_agg(geom order by distancia))[1] as logradouro_geom
,(array_agg(lote_geom order by distancia))[1] as lote_geom
group by id
 
 CREATE OR REPLACE VIEW stage.nr_porta_seguimento
AS SELECT DISTINCT lt.id AS id_lote,
    l.id AS id_logradouro,
    l.codigo AS codigo_logradouro,
        CASE
            WHEN (nr.nr_porta % 2::numeric) = 0::numeric AND tl.lado = 'D'::text THEN nr.nr_porta
            WHEN (nr.nr_porta % 2::numeric) <> 0::numeric AND tl.lado = 'D'::text THEN nr.nr_porta + 1::numeric
            WHEN (nr.nr_porta % 2::numeric) = 0::numeric AND tl.lado = 'E'::text THEN nr.nr_porta - 1::numeric
            WHEN (nr.nr_porta % 2::numeric) <> 0::numeric AND tl.lado = 'E'::text THEN nr.nr_porta
            ELSE NULL::numeric
        END AS nr_porta,
    st_makeline(st_closestpoint(tb.geom, st_endpoint(tl.geom)), st_endpoint(tl.geom)) AS geom
   FROM cadastro.imobiliario i
     JOIN cadastro.lote lt ON st_contains(lt.geom, i.geom)
     JOIN stage.logradouro_nr_porta_teste l ON i.id_logradouro = l.id
     JOIN cadastro.testada_lote tl ON tl.id_lote = lt.id AND tl.principal IS TRUE
     LEFT JOIN LATERAL ( SELECT log.id,
            log.codigo,
            log.secao,
            log.geom,
            sum(st_length(log.geom::geography, true)) OVER (PARTITION BY log.codigo ORDER BY log.secao ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) AS tamanho
           FROM stage.logradouro_nr_porta_teste log
          WHERE log.codigo::text = l.codigo::text AND log.secao > 0) tb ON tb.id = i.id_logradouro
     CROSS JOIN LATERAL ( SELECT COALESCE(round((tb.tamanho + st_length(st_makeline(st_closestpoint(tb.geom, st_endpoint(tl.geom)), st_startpoint(l.geom))::geography, true))::numeric), 2::numeric) AS nr_porta) nr
  WHERE l.codigo::text = '9789'::text AND i.id_logradouro IS NOT NULL AND l.secao > 0;



create or replace view stage.nr_porta_definitivo as
select  distinct on (lt.id) lt.id
, ST_MakeLine(ST_ClosestPoint(l.geom ,st_endpoint(tl.geom)),st_endpoint(tl.geom))
, tl.lado
, tb.codigo
,case 
	when row_number () over(partition by l.codigo,df.nr_porta)=2 then df.nr_porta+2 
	else tb3.nr_porta --para quando o numero de porta e repitido ele vai adicionar mais 2 
end
from cadastro.imobiliario i 
join cadastro.lote lt on st_contains(lt.geom,i.geom)
join cadastro.logradouro l on i.id_logradouro = l.id 
join cadastro.testada_lote tl on tl.id_lote =lt.id and tl.principal is true
join (select log.codigo,st_linemerge(st_union(log.geom)) geom_logradouro from cadastro.logradouro log group by log.codigo) tb on tb.codigo=l.codigo 
cross join lateral (select round(st_length(ST_MakeLine(st_startpoint(tb.geom_logradouro),ST_ClosestPoint(geom_logradouro ,st_endpoint(tl.geom))),true)::numeric) as nr_porta) nr
cross join lateral (select CASE 
								WHEN nr.nr_porta % 2 = 0 and tl.lado ='D' THEN  tb2.nr_porta
								WHEN nr.nr_porta % 2 <> 0 and tl.lado ='D' THEN  tb2.nr_porta+1
								WHEN nr.nr_porta % 2 = 0 and tl.lado ='E' THEN  tb2.nr_porta-1
								WHEN nr.nr_porta % 2 <> 0 and tl.lado ='E' THEN  tb2.nr_porta
								end as nr_porta) df
where l.codigo ='203443' and tl.lado is not null

*/




-----------------------------------------------------------------------------------------------------------------------------

