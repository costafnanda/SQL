begin transaction
rollback
commit
with rows as (update cadastro.lote lt
			  set id_face_quadra = tb.id_face_quadra
			  from(
			  select lt.id
				  ,lt.geom
				  ,(array_agg(fq.id order by st_distance(tl.geom,fq.geom)))[1] as id_face_quadra
				  --,q.id,q.geom,tl.geom,fq.geom
			  from cadastro.lote lt
			  join cadastro.testada_lote tl on lt.id =tl.id_lote  
			  join cadastro.quadra q on st_contains(q.geom,lt.geom)
			  join cadastro.face_quadra fq on fq.id_quadra =q.id
			  where lt.id_face_quadra is null
			  group by lt.id) tb
			  where tb.id=lt.id
			  and exists(select 1 
						 from ${tabela} ac 
						 where st_contains(ac.geom,st_centroid(lt.geom)) and ac.id=${id})
			  returning lt.id)
select count(distinct id)||' Dados Atualizado' as contagem
from rows




