create or replace view insumos.vw_json_prefeitura_cad_20 as 
SELECT cad.inscricao ,(jsonb_build_object(
    'inscricao', cad.inscricao,
    'pessoa', cad.pessoa,
    'nome_proprietario', cad.nome_proprietario,
    'cpf_cnpj', unaccent(nullif(cad.cpf_cnpj::text,'')),
    'localizacao', cad.localizacao,
    'nome_logradouro', unaccent(nullif(cad.nome_logradouro::text,'')),
    'codigo_logradouro', cad.codigo_logradouro,
    'trecho', cad.trecho,
    'numero', cad.numero,
    'complemento', unaccent(nullif(cad.complemento::text,'')),
    'bairro', unaccent(nullif(cad.bairro::text,'')),
    'cep', cad.cep,
    'quadra_antiga', unaccent(nullif(cad.quadra_antiga::text,'')),
    'lote_antigo', unaccent(nullif(cad.lote_antigo::text,'')),
    'situacao_terreno', unaccent(nullif(cad.situacao_terreno::text,'')),
    'topografia_terreno', unaccent(nullif(cad.topografia_terreno::text,'')),
    'pedologia_terreno', unaccent(nullif(cad.pedologia_terreno::text,'')),
    'situacao_unidade', unaccent(nullif(cad.situacao_unidade::text,'')),
    'posicao_unidade', unaccent(nullif(cad.posicao_unidade::text,'')),
    'alinhamento', unaccent(nullif(cad.alinhamento::text,'')),
    'estrutura', unaccent(nullif(cad.estrutura::text,'')),
    'cobertura', unaccent(nullif(cad.cobertura::text,'')),
    'parede', unaccent(nullif(cad.parede::text,'')),
    'forro', unaccent(nullif(cad.forro::text,'')),
    'fachada', unaccent(nullif(cad.fachada::text,'')),
    'sanitarias', unaccent(nullif(cad.sanitarias::text,'')),
    'eletricas', unaccent(nullif(cad.eletricas::text,'')),
    'tipo_agua', unaccent(nullif(cad.tipo_agua::text,'')),
    'tipo_esgoto', unaccent(nullif(cad.tipo_esgoto::text,'')),
    'tipo_lixo', unaccent(nullif(cad.tipo_lixo::text,'')),
    'tipologia', unaccent(nullif(cad.tipologia::text,'')),
    'uso', unaccent(nullif(cad.uso::text,'')),
    'area_terreno', cad.area_terreno::float8,
    'area_construida', cad.area_construida::float8,
    'area_total', cad.area_total::float8,
    'qtde_unidades', cad.qtde_unidades,
    /*'distrito1', cad.distrito1,
    'setor1', cad.setor1,
    'quadra1', cad.quadra1,
    'face1', cad.face1,
    'testada1', cad.testada1,
    'distrito2', cad.distrito2,
    'setor2', cad.setor2,
    'quadra2', cad.quadra2,
    'face2', cad.face2,
    'testada2', cad.testada2,
    'distrito3', cad.distrito3,
    'setor3', cad.setor3,
    'quadra3', cad.quadra3,
    'face3', cad.face3,
    'testada3', cad.testada3,
    'distrito4', cad.distrito4,
    'setor4', cad.setor4,
    'quadra4', cad.quadra4,
    'face4', cad.face4,
    'testada4', cad.testada4,*/
    'status', cad.status,
    'alvara', unaccent(nullif(trim(cad.alvara),'')),
    'inscricao_antiga', unaccent(nullif(cad.inscricao_antiga::text,'')),
    'data_habitese', cad.data_habitese,
    --'data_cadastro', cad.data_cadastro::date,
    'lote1', cad.lote1,
    'unidade', cad.unidade,
    'lote_numerico', cad.lote_numerico,
    'inscricao_nova', unaccent(nullif(cad.inscricao_nova::text,'')),
    'area_total_terreno', cad.area_total_terreno::float8,
    'fracao_ideal', cad.fracao_ideal::float8,
    'exercicio', cad.exercicio::int,
    'venal_total', cad.venal_total::float8
    --'data_atualizacao', cad.data_atualizacao::timestamp 
))||(jsonb_build_object('distrito1', cad.distrito1,
    'setor1', cad.setor1,
    'quadra1', cad.quadra1,
    'face1', cad.face1,
    'testada1', cad.testada1,
    'distrito2', cad.distrito2,
    'setor2', cad.setor2,
    'quadra2', cad.quadra2,
    'face2', cad.face2,
    'testada2', cad.testada2,
    'distrito3', cad.distrito3,
    'setor3', cad.setor3,
    'quadra3', cad.quadra3,
    'face3', cad.face3,
    'testada3', cad.testada3,
    'distrito4', cad.distrito4,
    'setor4', cad.setor4,
    'quadra4', cad.quadra4,
    'face4', cad.face4,
    'testada4', cad.testada4)) AS json_data,'legado' as tabela
FROM insumos.prefeitura_cad_out_20 as cad;

drop view insumos.vw_json_imob_compare

create or replace view insumos.vw_json_imob_compare as 
select imo.inscricaoimobiliario 
,jsonb_build_object('alinhamento',leg.alinhamento,'area_contruida',leg.area_construida,'bairro',leg.bairro,'cobertura',leg.cobertura,'complemento',leg.complemento
      			    ,'estrutura',leg.estrutura,'fracao_ideal',leg.fracao_ideal,'inscricao_antiga ',leg.inscricao_antiga ,'numero',leg.numero::text,'parede',leg.parede
      			    ,'situacao_unidade',leg.situacao_unidade ,'tipo_lixo',leg.tipo_lixo ,'unidade',leg.unidade ,'area_total_construida',leg.area_total 
      				,'area_terreno',leg.area_terreno ,'codigo_logradouro',leg.codigo_logradouro ,'trecho,',leg.trecho 
      				) as json_data_leg

,jsonb_build_object('alinhamento',imo.alinhamento,'area_construida',imo.area_construida,'bairro',b.nome,'cobertura',imo.cobertura,'complemento',imo.complemento
	                ,'estrutura',imo.estrutura,'fracao_ideal',imo.fracao_ideal,'inscricao_antiga ',imo.inscricao_antiga , 'numero',imo.numero::text ,'parede',imo.paredes
	                ,'situacao_unidade' ,imo.situacao_unidade ,'tipo_lixo ',imo.tipo_lixo ,'unidade',imo.unidade,'area_total_construida',imo.area_construida 
	                ,'area_terreno',imo.area_terreno,'codigo_logradouro',imo.codigo_logradouro ,'trecho',imo.trecho 
	                ) as json_data_cad,'imobiliario_legado' as tabela
		    
from cadastro.imobiliario imo
join insumos.prefeitura_cad_set_23 leg on imo.inscricaoimobiliario =leg.inscricao 
left join cadastro.bairro b on st_contains(b.geom,imo.geom)
where imo.inscricaoimobiliario =426
	--join insumos.prefeitura_cad_set_23 leg on imo.inscricaoimobiliario =leg.inscricao 

