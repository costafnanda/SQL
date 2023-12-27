--create table stage.teste_analise_logradouro_testestada as
select i.id as imobiliario,lt.id as lote ,i.id_logradouro id_logradouro_atual 
,(array_agg(log.id order by st_distance(point.polate,ST_LineInterpolatePoint(tl.geom,0.5),true)))[1]
from cadastro.imobiliario i 
join cadastro.lote lt on st_contains(lt.geom,i.geom)
join cadastro.testada_lote tl on tl.id_lote =lt.id and tl.principal is true
join cadastro.logradouro log on st_intersects(tl.geom,st_buffer(log.geom::geography,15,'endcap=flat join=round')::geometry) and st_length(log.geom,true)>0 
cross join lateral generate_series(0::numeric,1::numeric,1.0/st_length(log.geom,true)::numeric) serie
CROSS JOIN LATERAL (SELECT st_lineinterpolatepoint(log.geom, serie.serie::double precision) AS polate) point
group by i.id ,lt.id
having (array_agg(log.id order by st_distance(point.polate,ST_LineInterpolatePoint(tl.geom,0.5),true)))[1]<> i.id_logradouro 

