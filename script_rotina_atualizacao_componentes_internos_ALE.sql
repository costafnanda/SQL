DO $$
DECLARE
x record;
t record;
p_concat_reg text;
BEGIN
for X in (SELECT distinct imo.id id_imo,
vw.ocupacao_207,
oc.descricao AS ocupacao,
te.descricao AS tipo_edificacao,
pc.descricao AS padrao_construtivo,
vw.area_externa_329,
coalesce(ae.id,1) AS id_area_externa_329,
'padrao_luxo' regra
FROM cadastro.imobiliario imo
    LEFT JOIN legado.imovel_geo vw on vw.numero_cadastro = imo.numero_cadastro
LEFT JOIN cadastro.lote lt ON lt.id = imo.id_lote
LEFT JOIN dominio.ocupacao oc ON oc.id = lt.ocupacao
LEFT JOIN dominio.tipo_edificacao te ON te.id = imo.tipo_edificacao
LEFT JOIN dominio.padrao_construtivo pc ON pc.id = imo.padrao_construtivo
LEFT JOIN dominio.area_externa ae ON  trim(unaccent(lower(ae.descricao))) =  trim(unaccent(lower(vw.area_externa_329)))
where lt.ocupacao = '2'and vw.ocupacao_207 = 'VAGO'
and tipo_edificacao in ('1','2') and padrao_construtivo ='1' --and imo.id='7812'
union
SELECT distinct imo.id id_imo,
vw.ocupacao_207,
oc.descricao AS ocupacao,
te.descricao AS tipo_edificacao,
pc.descricao AS padrao_construtivo,
vw.area_externa_329,
coalesce(ae.id,1) AS id_area_externa_329,
'padrao_alto' regra
FROM cadastro.imobiliario imo
    LEFT JOIN legado.imovel_geo vw on vw.numero_cadastro = imo.numero_cadastro
LEFT JOIN cadastro.lote lt ON lt.id = imo.id_lote
LEFT JOIN dominio.ocupacao oc ON oc.id = lt.ocupacao
LEFT JOIN dominio.tipo_edificacao te ON te.id = imo.tipo_edificacao
LEFT JOIN dominio.padrao_construtivo pc ON pc.id = imo.padrao_construtivo
LEFT JOIN dominio.area_externa ae ON  trim(unaccent(lower(ae.descricao))) =  trim(unaccent(lower(vw.area_externa_329)))
where lt.ocupacao = '2'and vw.ocupacao_207 = 'VAGO'
and tipo_edificacao in ('1','2') and padrao_construtivo ='2' --and imo.id='7798'
union
SELECT distinct imo.id  id_imo,
vw.ocupacao_207,
oc.descricao AS ocupacao,
te.descricao AS tipo_edificacao,
pc.descricao AS padrao_construtivo,
vw.area_externa_329,
coalesce(ae.id,1) AS id_area_externa_329,
'padrao_medio' regra
FROM cadastro.imobiliario imo
    LEFT JOIN legado.imovel_geo vw on vw.numero_cadastro = imo.numero_cadastro
LEFT JOIN cadastro.lote lt ON lt.id = imo.id_lote
LEFT JOIN dominio.ocupacao oc ON oc.id = lt.ocupacao
LEFT JOIN dominio.tipo_edificacao te ON te.id = imo.tipo_edificacao
LEFT JOIN dominio.padrao_construtivo pc ON pc.id = imo.padrao_construtivo
LEFT JOIN dominio.area_externa ae ON  trim(unaccent(lower(ae.descricao))) =  trim(unaccent(lower(vw.area_externa_329)))
where lt.ocupacao = '2'and vw.ocupacao_207 = 'VAGO'
and tipo_edificacao in ('1','2') and padrao_construtivo ='3' --and imo.id='7797'
union
SELECT distinct imo.id  id_imo,
vw.ocupacao_207,
oc.descricao AS ocupacao,
te.descricao AS tipo_edificacao,
pc.descricao AS padrao_construtivo,
vw.area_externa_329,
coalesce(ae.id,1) AS id_area_externa_329,
'padrao_baixo' regra
FROM cadastro.imobiliario imo
    LEFT JOIN legado.imovel_geo vw on vw.numero_cadastro = imo.numero_cadastro
LEFT JOIN cadastro.lote lt ON lt.id = imo.id_lote
LEFT JOIN dominio.ocupacao oc ON oc.id = lt.ocupacao
LEFT JOIN dominio.tipo_edificacao te ON te.id = imo.tipo_edificacao
LEFT JOIN dominio.padrao_construtivo pc ON pc.id = imo.padrao_construtivo
LEFT JOIN dominio.area_externa ae ON  trim(unaccent(lower(ae.descricao))) =  trim(unaccent(lower(vw.area_externa_329)))
where lt.ocupacao = '2'and vw.ocupacao_207 = 'VAGO'
and tipo_edificacao in ('1','2') and padrao_construtivo ='4' --and imo.id='7802'
union
SELECT distinct imo.id  id_imo,
vw.ocupacao_207,
oc.descricao AS ocupacao,
te.descricao AS tipo_edificacao,
pc.descricao AS padrao_construtivo,
vw.area_externa_329,
coalesce(ae.id,1) AS id_area_externa_329,
'padrao_proletario' regra
FROM cadastro.imobiliario imo
    LEFT JOIN legado.imovel_geo vw on vw.numero_cadastro = imo.numero_cadastro
LEFT JOIN cadastro.lote lt ON lt.id = imo.id_lote
LEFT JOIN dominio.ocupacao oc ON oc.id = lt.ocupacao
LEFT JOIN dominio.tipo_edificacao te ON te.id = imo.tipo_edificacao
LEFT JOIN dominio.padrao_construtivo pc ON pc.id = imo.padrao_construtivo
LEFT JOIN dominio.area_externa ae ON  trim(unaccent(lower(ae.descricao))) =  trim(unaccent(lower(vw.area_externa_329)))
where lt.ocupacao = '2'and vw.ocupacao_207 = 'VAGO'
and tipo_edificacao in ('1','2') and padrao_construtivo ='5' --and imo.id='8023'
union
SELECT distinct imo.id  id_imo,
vw.ocupacao_207,
oc.descricao AS ocupacao,
te.descricao AS tipo_edificacao,
pc.descricao AS padrao_construtivo,
vw.area_externa_329,
coalesce(ae.id,1) AS id_area_externa_329,
'tipologia_diferente' regra
FROM cadastro.imobiliario imo
    LEFT JOIN legado.imovel_geo vw on vw.numero_cadastro = imo.numero_cadastro
LEFT JOIN cadastro.lote lt ON lt.id = imo.id_lote
LEFT JOIN dominio.ocupacao oc ON oc.id = lt.ocupacao
LEFT JOIN dominio.tipo_edificacao te ON te.id = imo.tipo_edificacao
LEFT JOIN dominio.padrao_construtivo pc ON pc.id = imo.padrao_construtivo
LEFT JOIN dominio.area_externa ae ON  trim(unaccent(lower(ae.descricao))) =  trim(unaccent(lower(vw.area_externa_329)))
where lt.ocupacao = '2'and vw.ocupacao_207 = 'VAGO'
and tipo_edificacao not in ('1','2') --and imo.id='10675'
) loop


if x.regra='padrao_luxo' then
update cadastro.imobiliario set
infraestrutura=1
,estrutura=1
,forro=6
,revestimento_interno=1
,pav_area_coberta=1
,instalacao_eletrica=1
,instalacao_sanitaria=1
,area_externa=x.id_area_externa_329
 where id=x.id_imo;
end if;

if x.regra='padrao_alto' then
update cadastro.imobiliario set
infraestrutura=1
,estrutura=1
,forro=5
,revestimento_interno=1
,pav_area_coberta=5
,instalacao_eletrica=1
,instalacao_sanitaria=1 
,area_externa=x.id_area_externa_329
where id=x.id_imo;
end if;

if x.regra='padrao_medio' then
update cadastro.imobiliario set
infraestrutura=1
,estrutura=2
,forro=4
,revestimento_interno=2
,pav_area_coberta=4
,instalacao_eletrica=2
,instalacao_sanitaria=1
,area_externa=x.id_area_externa_329
 where id=x.id_imo;
end if;

if x.regra='padrao_baixo' then
update cadastro.imobiliario set
infraestrutura=2
,estrutura=3
,forro=2
,revestimento_interno=3
,pav_area_coberta=3
,instalacao_eletrica=3
,instalacao_sanitaria=2
,area_externa=x.id_area_externa_329
 where id=x.id_imo;
end if;

if x.regra='padrao_proletario' then
update cadastro.imobiliario set
infraestrutura=3
,estrutura=4
,forro=2
,revestimento_interno=4
,pav_area_coberta=2
,instalacao_eletrica=3
,instalacao_sanitaria=2
,area_externa=x.id_area_externa_329
 where id=x.id_imo;
end if;

if x.regra='tipologia_diferente' then
update cadastro.imobiliario set
infraestrutura=1
,estrutura=1
,forro=2
,revestimento_interno=1
,pav_area_coberta=5
,instalacao_eletrica=1
,instalacao_sanitaria=1
,area_externa=x.id_area_externa_329
 where id=x.id_imo;
end if;
end loop;

for T  in (SELECT distinct imo.id  id_imo,
vw.ocupacao_207,
oc.descricao AS ocupacao,
te.descricao AS tipo_edificacao,
pc.descricao AS padrao_construtivo,
i.id id_infraestrutura_317,
vw.infraestrutura_317,
e.id id_estrutura_319,
vw.estrutura_319,
f.id id_forro_323,
vw.forro_323,
r.id id_revest_interno_321,
vw.revest_interno_321,
p.id id_pav_area_cob_318,		   
vw.pav_area_cob_318,
ie.id id_inst_eletrica_324,
vw.inst_eletrica_324,
s.id id_inst_sanitaria_325,
vw.inst_sanitaria_325,
vw.area_externa_329 ,
coalesce(ae.id,1) AS id_area_externa_329,
'edificado_legado' regra
FROM cadastro.imobiliario imo
    LEFT JOIN legado.imovel_geo vw on vw.numero_cadastro = imo.numero_cadastro
LEFT JOIN cadastro.lote lt ON lt.id = imo.id_lote
LEFT JOIN dominio.ocupacao oc ON oc.id = lt.ocupacao
LEFT JOIN dominio.tipo_edificacao te ON te.id = imo.tipo_edificacao
LEFT JOIN dominio.padrao_construtivo pc ON pc.id = imo.padrao_construtivo
LEFT JOIN dominio.infraestrutura i ON  trim(unaccent(lower(i.descricao))) =  trim(unaccent(lower(vw.infraestrutura_317)))
LEFT JOIN dominio.forro f ON  trim(unaccent(lower(f.descricao))) = trim(unaccent(lower(vw.forro_323)))
LEFT JOIN dominio.estrutura e ON  trim(unaccent(lower(e.descricao))) =  trim(unaccent(lower(vw.estrutura_319)))
LEFT JOIN dominio.revestimento_interno r ON  trim(unaccent(lower(r.descricao))) =  trim(unaccent(lower(vw.revest_interno_321)))
LEFT JOIN dominio.pav_area_coberta p ON  trim(unaccent(lower(p.descricao))) =  trim(unaccent(lower(vw.pav_area_cob_318)))
LEFT JOIN dominio.instalacao_eletrica ie ON  trim(unaccent(lower(ie.descricao))) =  trim(unaccent(lower(vw.inst_eletrica_324)))
LEFT JOIN dominio.instalacao_sanitaria s ON  trim(unaccent(lower(s.descricao))) =  trim(unaccent(lower(vw.inst_sanitaria_325)))
LEFT JOIN dominio.area_externa ae ON  trim(unaccent(lower(ae.descricao))) =  trim(unaccent(lower(vw.area_externa_329)))
where lt.ocupacao = '2'and vw.ocupacao_207 = 'EDIFICADO'
and tipo_edificacao is not null --and imo.id='7805'
		  ) loop 

if t.regra='edificado_legado' then
update cadastro.imobiliario set
infraestrutura=t.id_infraestrutura_317
,estrutura=t.id_estrutura_319
,forro=t.id_forro_323
,revestimento_interno=t.id_revest_interno_321
,pav_area_coberta=t.id_pav_area_cob_318
,instalacao_eletrica=t.id_inst_eletrica_324
,instalacao_sanitaria=t.id_inst_sanitaria_325
,area_externa = t.id_area_externa_329 
where id=t.id_imo;
end if;
end loop; 

END;
$$;

