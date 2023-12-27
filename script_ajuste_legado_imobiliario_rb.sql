--criacao tabela
/*-- Table: stage.legado_imobiliario

-- DROP TABLE IF EXISTS stage.legado_imobiliario;

CREATE TABLE IF NOT EXISTS stage.legado_imobiliario
(
    id bigint NOT NULL,
    geom geometry(Point,4326),
    numero_cadastro bigint,
    inscricao_cartografica text COLLATE pg_catalog."default",
    id_lote integer,
    nr_unidade character varying COLLATE pg_catalog."default",
    logradouro text COLLATE pg_catalog."default",
    complemento text COLLATE pg_catalog."default",
    nr_porta text COLLATE pg_catalog."default",
    utilizacao text COLLATE pg_catalog."default",
    estrutura text COLLATE pg_catalog."default",
    padrao_construtivo text COLLATE pg_catalog."default",
    tipo_edificacao text COLLATE pg_catalog."default",
    conservacao text COLLATE pg_catalog."default",
    idade_edificacao character varying COLLATE pg_catalog."default",
    area_terreno_fracao numeric,
    area_construida_calculada numeric,
    area_construida_comum numeric,
    area_construida_equivalente numeric,
    area_construida_privativa double precision,
    agua boolean,
    esgoto boolean,
	coleta_lixo boolean,
    energia_eletrica boolean,
    iluminacao_publica boolean,
    limpeza_publica boolean,
    transporte_publico boolean,
    calcada boolean,
    sarjeta boolean,
    arborizacao boolean,
    pavimentacao integer,
    galeria_pluvial boolean,
    CONSTRAINT pk_imo_legado PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS stage.legado_imobiliario
    OWNER to anapaula;

REVOKE ALL ON TABLE stage.legado_imobiliario FROM r_dml_rio_branco;

GRANT ALL ON TABLE stage.legado_imobiliario TO anapaula;

GRANT DELETE, INSERT, SELECT, UPDATE ON TABLE stage.legado_imobiliario TO r_dml_rio_branco;
*/


--drop view legado.vw_legado_imobiliario
--truncate table stage.legado_imobiliario
create view legado.vw_legado_imobiliario as 
insert into stage.legado_imobiliario
insert into stage.legado_imobiliario
SELECT  imo.id,
    imo.geom,
    imo.numero_cadastro,
    imo.inscricao_cartografica,
    imo.id_lote,
    imo.nr_unidade,
    rb_imo.logradouro,
    rb_imo.complemento,
    imo.nr_porta,
    coalesce(utilizacao.descricao,rb_imo.utilizacao_imovel) utilizacao,
    coalesce(estrutura.descricao,rb_imo.estrutura) estrutura,
  ---  alinhamento.descricao AS alinhamento,
   -- imo.area_construida_manual,
    coalesce(padrao_construtivo.descricao,rb_imo.padrao_residencial) AS padrao_construtivo,
    coalesce(tipo_edificacao.descricao,rb_imo.tipo_imovel) AS tipo_edificacao,
  --  rb_cons.revestimento_fachada_principal,
  -- rb_cons.cobertura,
 --  rb_cons.parede,
--   rb_cons.forro,
  -- rb_cons.tipo_construcao,
  --  rb_cons.instalacao_eletrica,
   -- rb_cons.instalacao_sanitaria,
  --  rb_cons.piso,
    conservacao.descricao AS conservacao,
    idade_edificacao.descricao AS idade_edificacao,
    rb_imo.area_terreno AS area_terreno_fracao,
    imo.area_construida_calculada,
    imo.area_construida_comum,
    imo.area_construida_equivalente,
   -- rb_imo.valor_venal_excedente,
  --  rb_imo.ufmrb,
    --rb_imo.valor_venal_terreno_bci,
   -- rb_imo.area_excedente,
   -- rb_imo.fator_correcao,
   -- rb_imo.valor_venal_total_construcao,
    --rb_imo.valor_m2_terreno,
   --rb_imo.valor_venal_imovel_bci,
   -- rb_imo.aliquota,
   --rb_imo.fracao_ideal_excedente,
    --rb_imo.iptu_2023 AS iptu,
   --rb_imo.iptu_taxa,
    coalesce(rb_imo.area_construida,imo.area_construida_privativa) area_construida_privativa,
    logradouro.agua,
    logradouro.esgoto,
	rb_imo.coletores_lixo coleta_lixo,
    logradouro.energia_eletrica,
    logradouro.iluminacao_publica,
    logradouro.limpeza_publica,
    logradouro.transporte_publico,
    logradouro.calcada,
    logradouro.sarjeta  AS sarjeta,
    logradouro.arborizacao  AS arborizacao,
    logradouro.pavimentacao,
    logradouro.galeria_pluvial
   FROM cadastro.imobiliario imo
     LEFT JOIN legado.vw_imovel_principal rb_imo ON rb_imo.numero_cadastro = imo.numero_cadastro
   --  LEFT JOIN legado.api_rbweb_imobiliario rb_imo ON rb_imo.id_imobiliario_rbweb = imo.numero_cadastro
   --  LEFT JOIN legado.api_rbweb_construcoes rb_cons ON rb_cons.id_imobiliario_rbweb = rb_imo.id_imobiliario_rbweb
   -- LEFT JOIN dominio.alinhamento alinhamento ON alinhamento.id = imo.alinhamento
     LEFT JOIN dominio.idade_edificacao idade_edificacao ON imo.idade_edificacao = idade_edificacao.id
     LEFT JOIN dominio.conservacao conservacao ON conservacao.id = imo.conservacao
     LEFT JOIN cadastro.logradouro logradouro ON imo.id_logradouro = logradouro.id
	 LEFT JOIN dominio.tipo_edificacao tipo_edificacao ON tipo_edificacao.id = imo.tipo_edificacao
	 LEFT JOIN dominio.utilizacao utilizacao ON utilizacao.id = imo.utilizacao
	 LEFT JOIN dominio.estrutura estrutura ON estrutura.id = imo.estrutura
	 LEFT JOIN dominio.padrao_construtivo padrao_construtivo ON padrao_construtivo.id = imo.padrao_construtivo
	 where imo.numero_cadastro is not null
union
 SELECT imo.id,
    imo.geom,
    imo.numero_cadastro,
    imo.inscricao_cartografica,
    imo.id_lote,
    imo.nr_unidade,
    rb_imo.logradouro,
    rb_imo.complemento,
    imo.nr_porta,
    utilizacao.descricao utilizacao,
    estrutura.descricao estrutura,
   -- alinhamento.descricao AS alinhamento,
  --  imo.area_construida_manual,
    padrao_construtivo.descricao padrao_construtivo,
    tipo_edificacao.descricao tipo_edificacao,
  --  rb_cons.revestimento_fachada_principal,
  --  rb_cons.cobertura,
 --   rb_cons.parede,
 --   rb_cons.forro,
 --   rb_cons.tipo_construcao,
   -- rb_cons.instalacao_eletrica,
  --  rb_cons.instalacao_sanitaria,
    --rb_cons.piso,
    conservacao.descricao AS conservacao,
    idade_edificacao.descricao AS idade_edificacao,
    imo.area_terreno_fracao,
    imo.area_construida_calculada,
    imo.area_construida_comum,
    imo.area_construida_equivalente,
  --  rb_imo.valor_venal_excedente,
   -- rb_imo.ufmrb,
   -- rb_imo.valor_venal_terreno_bci,
    --rb_imo.area_excedente,
  --  rb_imo.fator_correcao,
   -- rb_imo.valor_venal_total_construcao,
  --  rb_imo.valor_m2_terreno,
  --  rb_imo.valor_venal_imovel_bci,
   -- imo.aliquota,
   -- imo.fracao_ideal_excedente,
   -- imo.iptu_2023 AS iptu,
  --  imo.iptu,
    coalesce(imo.area_construida_privativa,0) area_construida_privativa,
    logradouro.agua,
    logradouro.esgoto,
	rb_imo.coletores_lixo coleta_lixo,
    logradouro.energia_eletrica,
    logradouro.iluminacao_publica,
    logradouro.limpeza_publica,
    logradouro.transporte_publico,
    logradouro.calcada,
    logradouro.sarjeta  AS sarjeta,
    logradouro.arborizacao  AS arborizacao,
    logradouro.pavimentacao,
    logradouro.galeria_pluvial
   FROM cadastro.imobiliario imo
     LEFT JOIN legado.vw_imovel_principal rb_imo ON rb_imo.numero_cadastro = imo.numero_cadastro
   --  LEFT JOIN legado.api_rbweb_imobiliario rb_imo ON rb_imo.id_imobiliario_rbweb = imo.numero_cadastro
   --  LEFT JOIN legado.api_rbweb_construcoes rb_cons ON rb_cons.id_imobiliario_rbweb = rb_imo.id_imobiliario_rbweb
   --  LEFT JOIN dominio.alinhamento alinhamento ON alinhamento.id = imo.alinhamento
     LEFT JOIN dominio.idade_edificacao idade_edificacao ON imo.idade_edificacao = idade_edificacao.id
     LEFT JOIN dominio.conservacao conservacao ON conservacao.id = imo.conservacao
     LEFT JOIN cadastro.logradouro logradouro ON imo.id_logradouro = logradouro.id
	 LEFT JOIN dominio.tipo_edificacao tipo_edificacao ON tipo_edificacao.id = imo.tipo_edificacao
	 LEFT JOIN dominio.utilizacao utilizacao ON utilizacao.id = imo.utilizacao
	 LEFT JOIN dominio.estrutura estrutura ON estrutura.id = imo.estrutura
	 LEFT JOIN dominio.padrao_construtivo padrao_construtivo ON padrao_construtivo.id = imo.padrao_construtivo
	 where imo.numero_cadastro is null;
	 
--atualizacao--	 
update stage.legado_lote l set situacao_lote='Esquina ou + Frente' where situacao_lote='Gleba / Vila';
update stage.legado_lote l set situacao_lote='Esquina ou + Frente' where situacao_lote='Quadra';
update stage.legado_lote l set pedologia='Normal' where pedologia in ('Argiloso','Arenoso');
update stage.legado_imobiliario set	tipo_edificacao='Telheiro' where  tipo_edificacao='Garagem';
update stage.legado_imobiliario set	tipo_edificacao='Escola/Universidade' where  tipo_edificacao in ('Educação','Público');
update stage.legado_imobiliario set	tipo_edificacao='Hospital' where  tipo_edificacao in ('Instituição Financeira','Saúde');
update stage.legado_imobiliario set	tipo_edificacao='Sala Comercial' where  tipo_edificacao in ('Edícula','Sala ou Conjunto');
update stage.legado_imobiliario set	tipo_edificacao='Loja' where  tipo_edificacao in ('Comércio');
update stage.legado_imobiliario set	tipo_edificacao='Cinema/Teatro/Clube' where  tipo_edificacao in ('Cinema / Teatro / Clube');
update stage.legado_imobiliario set	tipo_edificacao='Pavilhão' where  tipo_edificacao in ('Edificação Especial');
update stage.legado_imobiliario set tipo_edificacao='Casa' where tipo_edificacao is null and area_construida_privativa is not null;
update stage.legado_imobiliario set	padrao_construtivo='Superior' where tipo_edificacao='Templo'and padrao_construtivo in ('Especial','Elevado');
update stage.legado_imobiliario set	padrao_construtivo='Superior' where tipo_edificacao='Hotel' and padrao_construtivo in ('Especial','Elevado');
update stage.legado_imobiliario set	padrao_construtivo='Superior' where tipo_edificacao='Escola/Universidade' and padrao_construtivo in ('Especial','Elevado');

--select * from cadastro.legado_imobiliario where tipo_edificacao='Escola/Universidade' --573
--select * from cadastro.legado_imobiliario where tipo_edificacao='Público' --406

--atualizacao apos tabela popular para atualizar valores, isso é aplicado pontualmente
/*
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
commit;

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
commit;
*/