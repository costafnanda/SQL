ALTER TABLE cadastro.lote DROP CONSTRAINT fk_lote_bairro;

ALTER TABLE cadastro.lote ADD CONSTRAINT fk_lote_bairro
FOREIGN KEY (id_bairro) REFERENCES cadastro.bairro(id) 
ON UPDATE RESTRICT ON DELETE restrict



TRUNCATE TABLE cadastro.bairro RESTART IDENTITY RESTRICT;





INSERT INTO cadastro.bairro (id,geom, codigo, nome, dt_criacao)
select id, st_transform((ST_Dump(wkb_geometry)).geom,4326), cod_bairro,bairro,CURRENT_TIMESTAMP
from stage.bairro_new




update cadastro.lote l
set id_bairro=b.id
from cadastro.bairro b
where st_contains(b.geom,st_centroid(l.geom))


update cadastro.testada_lote tl
set id_bairro =l.id_bairro
from cadastro.lote l
where l.id =tl.id_lote 


update cadastro.profundidade_lote tl
set id_bairro =l.id_bairro
from cadastro.lote l
where l.id =tl.id_lote 

update controle_interno.face_lote tl
set id_bairro =l.id_bairro
from cadastro.lote l
where l.id =tl.lote_id 


update cadastro.quadra q
set id_bairro=b.id
from cadastro.bairro b
where st_contains(b.geom,st_centroid(q.geom))



update cadastro.face_quadra fq 
set id_bairro =q.id_bairro
from cadastro.quadra q
where q.id =fq.id_quadra  




