--Pegar os Logradouros em um Raio de 500m
--faz um centroid(cria um ponto no meio da linha) no logradouros e verifica a dististancia entre ele
--quando a distancia dos centroids dos Logradouros e menor que 1M ele retorna 
select pvg.id_log as id_log_pvg ,log.id as id_log
, pvg.codigo as codigo_pvg , log.codigo as codigo_log
, pvg.geom_1 as pvg_geom 
, log.geom as log_geom
, pvg.indice, pvg.valor_plan,pvg.vm2_cor,pvg.classific
from stage.pvg_vs1_trecho pvg
join cadastro.logradouro log on  
st_buffer(pvg.geom_1::geography,500)::geometry&&st_buffer(log.geom::geography,500)::geometry
and round(st_distance(st_Centroid(pvg.geom_1),st_Centroid(log.geom),true)::numeric)=0
--and pvg.id_log =1643
--limit 1






select  l.id,
    l.geom,
    l.codigo,
    l.nome,
    l.cep,
    l.ct_inicio_trecho,
    l.tipo_logradouro,
    l.ct_observacao,
    l.nome_antigo,
    l.vlr_m2,
    l.vut,
    l.vut_proposto,
    l.nome_sugerido_topo,
    l.codigo_novo_topo,
	pvt.id_log as id_log_pvt,
    pvt.indice AS indice_new,
    pvt.valor_plan AS valor_plan_new,
    pvt.vm2_cor AS vm2_cor_new,
    pvt.classific AS classific_new,
    pvt.geom_1 
from stage.pvg_vs1_trecho pvt
join cadastro.logradouro l on l.id =pvt.id_log 
where not exists(select 1
				   from stage.pvt_logradouros_iguas_ids_diferentes_definitivo l
				   where l.id_log_pvt=pvt.id_log)
and st_intersects(l.geom,pvt.geom_1) is true
union
 SELECT l.id,
    l.geom,
    l.codigo,
    l.nome,
    l.cep,
    l.ct_inicio_trecho,
    l.tipo_logradouro,
    l.ct_observacao,
    l.nome_antigo,
    l.vlr_m2,
    l.vut,
    l.vut_proposto,
    l.nome_sugerido_topo,
    l.codigo_novo_topo,
    pvt.id_log_pvt,
    pvt.indice AS indice_new,
    pvt.valor_plan AS valor_plan_new,
    pvt.vm2_cor AS vm2_cor_new,
    pvt.classific AS classific_new,
    pvt.pvt_geom
   FROM stage.pvt_logradouros_iguas_ids_diferentes_definitivo pvt
     JOIN cadastro.logradouro l ON l.id = pvt.id_log;

13.531

create view stage.pvg_vs1_trecho_logradouro_analise as 
select
l.* 
,pvt.id_log_pvt
,pvt.indice indice_new 
,pvt.valor_plan as valor_plan_new
,pvt.vm2_cor as vm2_cor_new	
,pvt.classific as classific_new
from stage.pvt_logradouros_iguas_ids_diferentes_definitivo pvt
join cadastro.logradouro l on l.id = pvt.id_log




