--drop view cadastro.vw_extrato_bci;
create view cadastro.vw_extrato_bci as
--select * from 
--(
	SELECT
  --imobiliario
  imo.id,
  imo.numero_cadastro,
  imo.inscricao_cartografica,
  setor.setor cd_setor,
  setor.nome nome_setor,
  coalesce(logra.codigo::int,pref.cd_logradouro) cd_logradouro,
  coalesce(logra.nome,pref.nome_logradouro) nome_logradouro,
  qd.quadra,
  lote.nr_lote lote,
  coalesce(imo.nr_unidade::text,pref.unidade) nr_unidade,
  imo.complemento,
  coalesce(imo.nr_porta,pref.nr_porta) nr_porta,
 
  
  --lote caracterizacao
     coalesce(dpt.descricao,pref.propriedade_202) patrimonio,
	 ped.descricao pedologia,
     coalesce(dsj.descricao,pref.situacao_juridica_203) situacao_juridica,
     dsl.descricao situacao_lote,
     dtp.descricao topografia,
     dft.descricao nr_frente,
     doc.descricao ocupacao,
	 pas.descricao passeio_208,
	 mur.descricao murado_209,
	 cer.descricao cercado,
	 esc.descricao escola,
	 pos.descricao posto_de_saude,
	 pis.descricao piscina,
	 
  --imobiliario caracterizacao
     coalesce(dul.descricao,pref.utilizacao_313) utilizacao,
	 dte.descricao tipo_edificacao,
     dus.descricao uso,
	 par.descricao paredes, 
	 pin.descricao pintura ,
	 pava.descricao pav_area_coberta, 
	 inf.descricao infraestrutura, 
	 det.descricao estrutura, 
     dri.descricao revestimento_interno, 
     dre.descricao revestimento_externo,
     dfo.descricao forro,
     die.descricao instalacao_eletrica, 
     dis.descricao instalacao_sanitaria, 
     dcb.descricao cobertura ,
	 aex.descricao area_externa, 
	 aco.descricao area_coberta,
	 pad.descricao padrao_construtivo,
     con.descricao conservacao,
  
  --logra caracterizacao
    coalesce(dag.descricao,pref.rede_de_agua_338) rede_agua,
    coalesce(des.descricao,pref.rede_de_esgoto_342) rede_esgoto,
	coalesce(del.descricao,pref.rede_eletrica_337) rede_eletrica,
	coalesce(arb.descricao,pref.arborizacao_333) arborizacao,
	coalesce(mei.descricao,pref.meio_fio_336) meio_fio,
	coalesce(pav.descricao,pref.pavimentacao_332) pavimentacao,
	coalesce(ret.descricao,pref.rede_telefonica_334) rede_telefonica,
	coalesce(col.descricao,pref.coleta_de_lixo_335) coleta_de_lixo,
	coalesce(var.descricao,pref.varricao_339) varricao,
	coalesce(gal.descricao,pref.galeria_fluvial_340) galeria_pluvial,
	coalesce(ilu.descricao,pref.iluminacao_publica_341) iluminacao_publica,
	
  --areas
    coalesce(lote.area_terreno_legado,pref.area_terreno) area_terreno,
	imo.area_construida_privativa area_construida_unidade,
	lote.area_construida_privativa area_total_construida,
	pref.fracao_ideal,
	
  --Proprietario
     pessoa.codigo cd_prop,
     pessoa.nome   nome_prop,
     pessoa.cpf_cnpj cpf_cnpj_prop,
     pessoa.tipo tipo_pessoa_prop,
	 pessoa.rg  rg_prop,		
	 pessoa.telefone tel_prop,
	 pessoa.sexo   sexo_prop,
	 pessoa.Logradouro logra_prop,
	 pessoa.complemento complemento_pessoa,
	 pessoa.numero     numero_prop,
	 pessoa.bairro    bairro_prop,
	 pessoa.cep  cep_prop,
	 
	 --midia
	 midia.link,
	 st_astext(lote.geom) as geom_lote
  
    FROM cadastro.imobiliario imo
     LEFT JOIN cadastro.logradouro logra ON imo.id_logradouro = logra.id
     LEFT JOIN cadastro.lote lote ON imo.id_lote = lote.id
	 LEFT JOIN cadastro.quadra qd ON qd.geom&&imo.geom and st_contains (qd.geom,imo.geom)
     LEFT JOIN cadastro.bairro bairro  ON bairro.geom&&imo.geom and st_contains (bairro.geom,imo.geom)
	 LEFT JOIN cadastro.setor setor  ON setor.geom&&imo.geom and st_contains (setor.geom,imo.geom)
     LEFT JOIN cadastro.imobiliario_pessoa imo_pessoa ON imo_pessoa.id_imobiliario = imo.id and imo_pessoa.tipo=1
     LEFT JOIN cadastro.pessoa pessoa ON pessoa.id = imo_pessoa.id_pessoa
     LEFT JOIN dominio.tipo_pessoa tipo_pessoa ON tipo_pessoa.id = pessoa.tipo
	 --lote
     LEFT JOIN dominio.patrimonio dpt ON dpt.id = lote.patrimonio
	 LEFT JOIN dominio.pedologia ped ON ped.id = lote.pedologia
     LEFT JOIN dominio.situacao_juridica dsj ON dsj.id = lote.situacao_juridica
     LEFT JOIN dominio.situacao_lote dsl ON dsl.id = lote.situacao_lote
     LEFT JOIN dominio.topografia dtp ON dtp.id = lote.topografia
     LEFT JOIN dominio.nr_frente dft ON dft.id = lote.nr_frente
     LEFT JOIN dominio.ocupacao doc ON doc.id = lote.ocupacao
	 LEFT JOIN dominio.passeio_208 pas ON pas.id = lote.passeio_208
	 LEFT JOIN dominio.murado_209 mur ON mur.id = lote.murado_209
	 LEFT JOIN dominio.cercado cer ON cer.id = lote.cercado
	 LEFT JOIN dominio.escola esc ON esc.id = lote.escola
	 LEFT JOIN dominio.posto_de_saude pos ON pos.id = lote.posto_de_saude
	 LEFT JOIN dominio.piscina pis ON pis.id = lote.piscina
	 	 
    --imobiliario
	 LEFT JOIN dominio.utilizacao dul ON dul.id = imo.utilizacao
     LEFT JOIN dominio.tipo_edificacao dte ON dte.id = imo.tipo_edificacao
     LEFT JOIN dominio.uso dus ON dus.id = imo.uso
	 LEFT JOIN dominio.paredes par ON par.id = imo.paredes
	 LEFT JOIN dominio.pintura pin ON pin.id = imo.pintura
	 LEFT JOIN dominio.pav_area_coberta pava ON pava.id = imo.pav_area_coberta
	 LEFT JOIN dominio.infraestrutura inf ON inf.id = imo.infraestrutura
	 LEFT JOIN dominio.estrutura det ON det.id = imo.estrutura
     LEFT JOIN dominio.revestimento_interno dri ON dri.id = imo.revestimento_interno
     LEFT JOIN dominio.revestimento_externo dre ON dre.id = imo.revestimento_externo
     LEFT JOIN dominio.forro dfo ON dfo.id = imo.forro
     LEFT JOIN dominio.instalacao_eletrica die ON die.id = imo.instalacao_eletrica
     LEFT JOIN dominio.instalacao_sanitaria dis ON dis.id = imo.instalacao_sanitaria
     LEFT JOIN dominio.cobertura dcb ON dcb.id = imo.cobertura
	 LEFT JOIN dominio.area_externa aex ON aex.id = imo.cobertura
	 LEFT JOIN dominio.area_coberta aco ON aco.id = imo.cobertura
	 LEFT JOIN dominio.padrao_construtivo pad ON pad.id = imo.padrao_construtivo
     LEFT JOIN dominio.conservacao con ON con.id = imo.conservacao
	 
	 --logradouro
     LEFT JOIN dominio.rede_agua dag ON dag.id = logra.rede_agua
     LEFT JOIN dominio.rede_esgoto des ON des.id = logra.rede_esgoto
	 LEFT JOIN dominio.rede_eletrica del ON des.id = logra.rede_eletrica
	 LEFT JOIN dominio.arborizacao arb ON arb.id = logra.arborizacao
	 LEFT JOIN dominio.meio_fio mei ON mei.id = logra.meio_fio
	 LEFT JOIN dominio.pavimentacao pav ON pav.id = logra.pavimentacao
	 LEFT JOIN dominio.rede_telefonica ret ON ret.id = logra.rede_telefonica
	 LEFT JOIN dominio.coleta_de_lixo col ON col.id = logra.coleta_de_lixo
	 LEFT JOIN dominio.varricao var ON var.id = logra.varricao
	 LEFT JOIN dominio.galeria_pluvial gal ON gal.id = logra.galeria_pluvial
	 LEFT JOIN dominio.iluminacao_publica ilu ON ilu.id = logra.iluminacao_publica
     LEFT JOIN legado.imovel_geo pref ON pref.numero_cadastro = imo.numero_cadastro
     LEFT JOIN cadastro.midia midia ON midia.id_origem = lote.id 
    LEFT JOIN controle_interno.area_cadastro ac ON ac.id_setor = lote.id_setor;
	--) tb
	-- where imo.numero_cadastro=7722;
	
	GRANT SELECT ON CADASTRO.VW_EXTRATO_BCI TO R_SEL_ALEXANIA;