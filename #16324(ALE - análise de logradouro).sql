--create view stage_analise_logra_testada as
select i.id as imobiliario,lt.id as lote ,lt.geom 
,ig.cd_logradouro as cd_logradouro_legado,"cepLog" as ceplog_legado,	"nomeLog" as nomelog_legado 
,(array_agg(log1.id order by st_distance(point.polate,ST_LineInterpolatePoint(tl.geom,0.5),true)))[1] as possivel_id_logradouro
from cadastro.imobiliario i
join cadastro.lote lt on st_contains(lt.geom,i.geom)
join cadastro.testada_lote tl on tl.id_lote =lt.id
join legado.imovel_geo ig on ig.numero_cadastro =i.numero_cadastro 
join legado.logradouro log2 on log2."codLog"=ig.cd_logradouro 
join cadastro.logradouro log1 on st_intersects(tl.geom,st_buffer(log1.geom::geography, 15,'endcap=flat join=round')::geometry) and st_length(log1.geom,true)>0 
cross join lateral generate_series(0::numeric,1::numeric,1.0/st_length(log1.geom,true)::numeric) serie
CROSS JOIN LATERAL (SELECT st_lineinterpolatepoint(log1.geom, serie.serie::double precision) AS polate) point
group by  i.id ,lt.id  ,ig.cd_logradouro ,"cepLog",	"nomeLog"
having count(distinct tl.id)=1 and true=all(array_agg(tl.principal)) 







select *
from cadastro.lote l 
join controle_interno.area_cadastro ac on st_contains(ac.geom,st_centroid(l.geom))


select *
from cadastro.imobiliario i 
join cadastro.lote lt on st_contains(lt.geom,i.geom)
join cadastro.logradouro log1 on 
st_intersects(lt.geom,st_buffer(log1.geom::geography, 30,'endcap=flat join=round')::geometry) 
and st_length(log1.geom,true)>0 


