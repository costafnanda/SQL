select i.id as imobiliario 
,l.id as lote
,i.geom
,tl.id_logradouro as id_logradouro_testada
,i.id_logradouro as id_logradouro_imobiliario
from cadastro.imobiliario i 
join cadastro.lote l on st_contains(l.geom,i.geom)
join cadastro.testada_lote tl on tl.id_lote=l.id and tl.principal is true
join controle_interno.area_cadastro ac on st_contains(ac.geom,i.geom)
where tl.id_logradouro <>i.id_logradouro and ac.id=56
