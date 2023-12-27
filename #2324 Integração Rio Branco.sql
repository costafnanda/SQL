
CREATE OR REPLACE VIEW integracao.construcoes
AS SELECT i.id,
    i.inscricao_cartografica,
    round(tb.area, 2) AS area,
    tb.codigo AS tipo_imovel,
        CASE
            WHEN tb.codigo = ANY (ARRAY[14, 9, 8, 5]) THEN NULL::integer
            ELSE i.padrao_construtivo
        END AS qualidade_construcao,
        CASE
            WHEN tb.codigo = ANY (ARRAY[10, 3, 9]) THEN NULL::integer
            ELSE i.idade_edificacao
        END AS idade,
    i.conservacao,
    i.utilizacao AS utilizacao_imovel,
    i.estrutura,
    l.ocupacao,
    conversao_bool(l.piscina) AS piscina
   FROM cadastro.imobiliario i
     JOIN controle_interno.area_cadastro ac ON st_contains(ac.geom, i.geom)
     LEFT JOIN cadastro.imobiliario_area area ON area.id_imobiliario = i.id
     LEFT JOIN cadastro.lote l ON st_contains(l.geom, i.geom)
     LEFT JOIN dominio.tipo_edificacao te ON te.id = i.tipo_edificacao
     CROSS JOIN LATERAL ( VALUES (te.id,area.area_casa + area.area_apartamento + area.area_galpao + area.area_industria + area.area_loja + area.area_pavilhao_comercial + area.area_barracao_madeira + area.area_sala_comercial + area.area_banca_quiosque + area.area_terraco_coberto + area.area_especial + area.area_posto_combustivel + area.area_reservatorio_armazenamento + area.area_garagem,te.descricao), (20,area.area_piscina,'Piscina'::character varying), (14,area.area_telheiro,'Telheiro'::character varying)) tb(codigo, area, descricao)
  WHERE ac.entregue IS TRUE AND i.numero_cadastro IS NOT NULL AND tb.area <> 0::numeric;


-- integracao.construcoes_novos_imobiliarios source

CREATE OR REPLACE VIEW integracao.construcoes_novos_imobiliarios
AS SELECT i.id,
    i.inscricao_cartografica,
    round(tb.area, 2) AS area,
    tb.codigo AS tipo_imovel,
        CASE
            WHEN tb.codigo = ANY (ARRAY[14, 9, 8, 5]) THEN NULL::integer
            ELSE i.padrao_construtivo
        END AS qualidade_construcao,
        CASE
            WHEN tb.codigo = ANY (ARRAY[10, 3, 9]) THEN NULL::integer
            ELSE i.idade_edificacao
        END AS idade,
    i.conservacao,
    i.utilizacao AS utilizacao_imovel,
    i.estrutura,
    l.ocupacao,
    conversao_bool(l.piscina) AS piscina
   FROM cadastro.imobiliario i
     JOIN controle_interno.area_cadastro ac ON st_contains(ac.geom, i.geom)
     LEFT JOIN cadastro.imobiliario_area area ON area.id_imobiliario = i.id
     LEFT JOIN cadastro.lote l ON st_contains(l.geom, i.geom)
     LEFT JOIN dominio.tipo_edificacao te ON te.id = i.tipo_edificacao
     CROSS JOIN LATERAL ( VALUES (te.id,area.area_casa + area.area_apartamento + area.area_galpao + area.area_industria + area.area_loja + area.area_pavilhao_comercial + area.area_barracao_madeira + area.area_sala_comercial + area.area_banca_quiosque + area.area_terraco_coberto + area.area_especial + area.area_posto_combustivel + area.area_reservatorio_armazenamento + area.area_garagem,te.descricao), (20,area.area_piscina,'Piscina'::character varying), (14,area.area_telheiro,'Telheiro'::character varying)) tb(codigo, area, descricao)
  WHERE ac.entregue IS TRUE AND i.numero_cadastro IS NULL AND tb.area <> 0::numeric;

COMMENT ON COLUMN integracao.construcoes_novos_imobiliarios.qualidade_construcao IS 'Anula Quando o tipo_imovel e Escola/Universidade,Sala Comercial,Hospital';
COMMENT ON COLUMN integracao.construcoes_novos_imobiliarios.idade IS 'Anula Quando Escola/Universidade , Sala Comercial , Hospital';


-- integracao.imobiliario source

CREATE OR REPLACE VIEW integracao.imobiliario
AS SELECT imobiliario.id,
    imobiliario.inscricao_cartografica,
    imobiliario.area_construida_privativa AS area_contruida,
    imobiliario.area_terreno_fracao AS area_terreno,
    bairro.codigo AS bairro,
    logradouro.codigo AS logradouro,
    logradouro.metrica,
    logradouro.pavimentacao,
    logradouro.log_trecho,
    lote.nr_lote AS lote,
    quadra.quadra,
    setor.codigo AS setor,
    imobiliario.nr_porta AS numero,
    imobiliario.complemento,
    logradouro.log_trecho AS trecho_logradouro,
    imobiliario.inscricao_cartografica AS codigo,
    logradouro.cep,
    imobiliario.tipo_edificacao AS tipo_imovel,
    lote.situacao_lote AS situacao,
    lote.topografia,
    lote.pedologia,
    logradouro.agua,
    logradouro.energia_eletrica,
    logradouro.esgoto,
    logradouro.iluminacao_publica,
    logradouro.galeria_pluvial,
    logradouro.limpeza_publica,
    logradouro.transporte_publico,
    logradouro.calcada,
    logradouro.sarjeta,
    logradouro.arborizacao,
    logradouro.rede_telefonica,
    logradouro.emplacamento,
    logradouro.coleta_de_lixo,
    (SELECT count(1) AS count
           FROM integracao.construcoes_novos_imobiliarios c
          WHERE c.id = imobiliario.id
          GROUP BY c.id
         LIMIT 1) AS qntconstrucoes
   FROM cadastro.imobiliario imobiliario
     LEFT JOIN cadastro.lote lote ON st_contains(imobiliario.geom, lote.geom)
     LEFT JOIN cadastro.logradouro logradouro ON imobiliario.id_logradouro = logradouro.id
     LEFT JOIN controle_interno.area_cadastro ac ON st_contains(ac.geom, imobiliario.geom)
     LEFT JOIN cadastro.quadra quadra ON quadra.id = lote.id_quadra
     LEFT JOIN cadastro.setor setor ON st_contains(setor.geom, imobiliario.geom)
     LEFT JOIN cadastro.bairro bairro ON bairro.id = lote.id_bairro
  WHERE ac.entregue IS TRUE AND imobiliario.numero_cadastro IS NOT NULL;

-- integracao.imobiliario_novos_imobiliario source

CREATE OR REPLACE VIEW integracao.imobiliario_novos_imobiliario
as SELECT imobiliario.id,
    imobiliario.inscricao_cartografica,
    imobiliario.area_construida_privativa AS area_contruida,
    imobiliario.area_terreno_fracao AS area_terreno,
    bairro.codigo AS bairro,
    logradouro.codigo AS logradouro,
    logradouro.metrica,
    logradouro.pavimentacao,
    logradouro.log_trecho,
    lote.nr_lote AS lote,
    quadra.quadra,
    setor.codigo AS setor,
    imobiliario.nr_porta AS numero,
    imobiliario.complemento,
    logradouro.log_trecho AS trecho_logradouro,
    imobiliario.inscricao_cartografica AS codigo,
    logradouro.cep,
    imobiliario.tipo_edificacao AS tipo_imovel,
    lote.situacao_lote AS situacao,
    lote.topografia,
    lote.pedologia,
    logradouro.agua,
    logradouro.energia_eletrica,
    logradouro.esgoto,
    logradouro.iluminacao_publica,
    logradouro.galeria_pluvial,
    logradouro.limpeza_publica,
    logradouro.transporte_publico,
    logradouro.calcada,
    logradouro.sarjeta,
    logradouro.arborizacao,
    logradouro.rede_telefonica,
    logradouro.emplacamento,
    logradouro.coleta_de_lixo
    (SELECT count(1) AS count
           FROM integracao.construcoes_novos_imobiliarios c
          WHERE c.id = imobiliario.id
          GROUP BY c.id
         LIMIT 1) AS qntconstrucoes
   FROM cadastro.imobiliario imobiliario
     LEFT JOIN cadastro.lote lote ON st_contains(imobiliario.geom, lote.geom)
     LEFT JOIN cadastro.logradouro logradouro ON imobiliario.id_logradouro = logradouro.id
     LEFT JOIN controle_interno.area_cadastro ac ON st_contains(ac.geom, imobiliario.geom)
     LEFT JOIN cadastro.quadra quadra ON quadra.id = lote.id_quadra
     LEFT JOIN cadastro.setor setor ON st_contains(setor.geom, imobiliario.geom)
     LEFT JOIN cadastro.bairro bairro ON bairro.id = lote.id_bairro
  WHERE ac.entregue IS TRUE AND imobiliario.numero_cadastro IS NULL;


-- integracao.imobiliario_pessoas source

CREATE OR REPLACE VIEW integracao.imobiliario_pessoas
AS SELECT imobiliario_pessoa.id AS id_imobiliario_pessoa,
    imobiliario.id AS id_imobiliario,
    pessoa.id AS id_pessoa,
    imobiliario.numero_cadastro,
    imobiliario.inscricao_cartografica,
    pessoa.codigo,
    pessoa.tipo,
    pessoa.cpf_cnpj,
    pessoa.nome
   FROM cadastro.imobiliario_pessoa imobiliario_pessoa
     LEFT JOIN cadastro.pessoa pessoa ON imobiliario_pessoa.id_pessoa = pessoa.id
     LEFT JOIN cadastro.imobiliario imobiliario ON imobiliario.id = imobiliario_pessoa.id_imobiliario
  WHERE imobiliario.numero_cadastro IS NOT NULL;


-- integracao.imobiliario_pessoas_novos_imobiliarios source

CREATE OR REPLACE VIEW integracao.imobiliario_pessoas_novos_imobiliarios
AS SELECT imobiliario_pessoa.id AS id_imobiliario_pessoa,
    imobiliario.id AS id_imobiliario,
    pessoa.id AS id_pessoa,
    imobiliario.numero_cadastro,
    imobiliario.inscricao_cartografica,
    pessoa.codigo,
    pessoa.tipo,
    pessoa.cpf_cnpj,
    pessoa.nome
   FROM cadastro.imobiliario_pessoa imobiliario_pessoa
     LEFT JOIN cadastro.pessoa pessoa ON imobiliario_pessoa.id_pessoa = pessoa.id
     LEFT JOIN cadastro.imobiliario imobiliario ON imobiliario.id = imobiliario_pessoa.id_imobiliario
  WHERE imobiliario.numero_cadastro IS NULL;


-- integracao.logradouro source

CREATE OR REPLACE VIEW integracao.logradouro
AS SELECT l.id AS id_logradoro,
    l.codigo,
    l.nome,
    l.cep,
    l.coleta_de_lixo,
    l.agua AS rede_de_agua,
    l.esgoto AS rede_de_esgoto,
    l.energia_eletrica AS rede_eletrica,
    l.iluminacao_publica,
    l.tipo_logradouro,
    l.pavimentacao AS pavimentecao_asfaltica,
    l.emplacamento,
    l.sarjeta AS sarjetas,
    l.calcada,
    l.limpeza_publica,
    l.rede_telefonica,
    l.galeria_pluvial,
    l.arborizacao,
    l.transporte_publico,
    l.logradouro_novo,
    l.log_trecho,
    l.vut_d,
    l.vut_e,
    l.metrica,
    l.sentido_crescente
   FROM cadastro.logradouro l;


-- integracao.pessoa source

CREATE OR REPLACE VIEW integracao.pessoa
AS SELECT p.id AS id_pessoa,
    p.codigo,
    p.cpf_cnpj,
    p.nome AS nome_razao_social,
    p.telefone,
    p.email
   FROM cadastro.pessoa p;


-- integracao.pessoa_novas source

CREATE OR REPLACE VIEW integracao.pessoa_novas
AS SELECT p.id AS id_pessoa,
    p.codigo,
    p.cpf_cnpj,
    p.nome AS nome_razao_social,
    p.telefone,
    p.email
   FROM cadastro.pessoa p
  WHERE p.codigo IS NOT NULL;