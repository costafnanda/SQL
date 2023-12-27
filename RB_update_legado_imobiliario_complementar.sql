begin transaction;
update stage.legado_imobiliario legi
set conservacao = b.descricao
from
(select legi.id,legi.numero_cadastro,legi.conservacao, i.conservacao, die.descricao
from stage.legado_imobiliario legi
left join cadastro.imobiliario i on legi.inscricao_cartografica = i.inscricao_cartografica
left join dominio.conservacao die on die.codigo::int = i.conservacao
where legi.conservacao <> die.descricao)b
where legi.id = b.id
returning*

begin transaction;
update stage.legado_imobiliario legi
set idade_edificacao = b.descricao
from
(select legi.id,legi.numero_cadastro,legi.idade_edificacao, i.idade_edificacao, die.descricao
from stage.legado_imobiliario legi
left join cadastro.imobiliario i on legi.inscricao_cartografica = i.inscricao_cartografica
left join dominio.idade_edificacao die on die.codigo::int = i.idade_edificacao
where legi.idade_edificacao <> die.descricao)b
where legi.id = b.id
returning*

begin transaction;
update stage.legado_imobiliario legi
set utilizacao = b.descricao
from
(select legi.id,legi.numero_cadastro,legi.utilizacao, i.utilizacao, die.descricao
from stage.legado_imobiliario legi
left join cadastro.imobiliario i on legi.inscricao_cartografica = i.inscricao_cartografica
left join dominio.utilizacao die on die.codigo::int = i.utilizacao
where legi.utilizacao <> die.descricao)b
where legi.id = b.id
returning*

begin transaction;
update stage.legado_imobiliario legi
set tipo_edificacao = b.descricao
from
(select legi.id,legi.numero_cadastro,legi.tipo_edificacao, i.tipo_edificacao, die.descricao
from stage.legado_imobiliario legi
left join cadastro.imobiliario i on legi.inscricao_cartografica = i.inscricao_cartografica
left join dominio.tipo_edificacao die on die.codigo::int = i.tipo_edificacao
where legi.tipo_edificacao <> die.descricao)b
where legi.id = b.id
returning*

begin transaction;
update stage.legado_imobiliario legi
set padrao_construtivo = b.descricao
from
(select legi.id,legi.numero_cadastro,legi.padrao_construtivo, i.padrao_construtivo, die.descricao
from stage.legado_imobiliario legi
left join cadastro.imobiliario i on legi.inscricao_cartografica = i.inscricao_cartografica
left join dominio.padrao_construtivo die on die.codigo::int = i.padrao_construtivo
where legi.padrao_construtivo <> die.descricao)b
where legi.id = b.id
returning*

begin transaction;
update stage.legado_imobiliario legi
set area_construida_privativa = b.area_construida_privativa_imo
from
(select legi.id,legi.numero_cadastro,legi.area_construida_privativa, i.area_construida_privativa as area_construida_privativa_imo
from stage.legado_imobiliario legi
left join cadastro.imobiliario i on legi.inscricao_cartografica = i.inscricao_cartografica
where legi.area_construida_privativa <> i.area_construida_privativa)b
where legi.id = b.id
returning*
