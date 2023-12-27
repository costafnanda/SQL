--gerar script de quantidade de feicoes por OS
ANALYZE VERBOSE;
select 'select '''||schema||'.'||tabela||''' as tabela  ,count(1) as total from '||schema||'.'||tabela|| ' tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome=''OS03'' union all' from 
--rodar o vacuun analyse antes de executar a consulta de relatorio
(select distinct
relnamespace::regnamespace schema,
relname as tabela,
reltuples qtd_linhas
--format_type(atttypid,atttypmod) as tipo
from pg_class c
inner join pg_attribute a
on (c.oid=a.attrelid)
where attnum>0
and relnamespace in ('mapeamento_urbano'::regnamespace) 
--  and relname in ('clientes','tributacao')
and relkind='r' and reltuples>=1 and relname   not like '%\_mu\_%'
--and format_type(atttypid,atttypmod) like 'geometry%'
order by 1,2) tb

--Exemplo OS03
/*
select * from
(select 'mapeamento_urbano.cbge_canteiro_central_a' as tabela  ,count(1) as total from mapeamento_urbano.cbge_canteiro_central_a tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.cbge_delimitacao_fisica_l' as tabela  ,count(1) as total from mapeamento_urbano.cbge_delimitacao_fisica_l tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.cbge_deposito_geral_a' as tabela  ,count(1) as total from mapeamento_urbano.cbge_deposito_geral_a tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.cbge_espelho_dagua_a' as tabela  ,count(1) as total from mapeamento_urbano.cbge_espelho_dagua_a tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.cbge_estacionamento_a' as tabela  ,count(1) as total from mapeamento_urbano.cbge_estacionamento_a tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.cbge_passeio_a' as tabela  ,count(1) as total from mapeamento_urbano.cbge_passeio_a tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.cbge_poste_p' as tabela  ,count(1) as total from mapeamento_urbano.cbge_poste_p tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.cbge_trecho_arruamento_a' as tabela  ,count(1) as total from mapeamento_urbano.cbge_trecho_arruamento_a tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.cbge_trecho_arruamento_l' as tabela  ,count(1) as total from mapeamento_urbano.cbge_trecho_arruamento_l tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.df_abrigo_onibus_a' as tabela  ,count(1) as total from mapeamento_urbano.df_abrigo_onibus_a tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.df_acesso_particular_a' as tabela  ,count(1) as total from mapeamento_urbano.df_acesso_particular_a tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.df_acesso_particular_l' as tabela  ,count(1) as total from mapeamento_urbano.df_acesso_particular_l tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.df_area_impermeavel_a' as tabela  ,count(1) as total from mapeamento_urbano.df_area_impermeavel_a tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.df_arvore_isolada_a' as tabela  ,count(1) as total from mapeamento_urbano.df_arvore_isolada_a tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.df_bacia_contencao_a' as tabela  ,count(1) as total from mapeamento_urbano.df_bacia_contencao_a tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.df_cb_area_lazer_a' as tabela  ,count(1) as total from mapeamento_urbano.df_cb_area_lazer_a tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.df_ciclovia_a' as tabela  ,count(1) as total from mapeamento_urbano.df_ciclovia_a tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.df_delimitacao_fisica_int_l' as tabela  ,count(1) as total from mapeamento_urbano.df_delimitacao_fisica_int_l tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.df_edf_cobertura_a' as tabela  ,count(1) as total from mapeamento_urbano.df_edf_cobertura_a tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.df_edf_marquise_a' as tabela  ,count(1) as total from mapeamento_urbano.df_edf_marquise_a tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.df_edf_projecao_a' as tabela  ,count(1) as total from mapeamento_urbano.df_edf_projecao_a tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.df_edf_telheiro_a' as tabela  ,count(1) as total from mapeamento_urbano.df_edf_telheiro_a tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.df_hid_ponto_inicio_drenagem_p' as tabela  ,count(1) as total from mapeamento_urbano.df_hid_ponto_inicio_drenagem_p tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.df_ligacao_hidrografia_l' as tabela  ,count(1) as total from mapeamento_urbano.df_ligacao_hidrografia_l tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.df_lote_a' as tabela  ,count(1) as total from mapeamento_urbano.df_lote_a tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.df_parque_infantil_a' as tabela  ,count(1) as total from mapeamento_urbano.df_parque_infantil_a tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.df_via_interna_a' as tabela  ,count(1) as total from mapeamento_urbano.df_via_interna_a tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.df_via_interna_l' as tabela  ,count(1) as total from mapeamento_urbano.df_via_interna_l tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.edf_edificacao_a' as tabela  ,count(1) as total from mapeamento_urbano.edf_edificacao_a tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.emu_acesso_a' as tabela  ,count(1) as total from mapeamento_urbano.emu_acesso_a tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.emu_escadaria_a' as tabela  ,count(1) as total from mapeamento_urbano.emu_escadaria_a tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.emu_poste_sinalizacao_p' as tabela  ,count(1) as total from mapeamento_urbano.emu_poste_sinalizacao_p tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.enc_antena_comunic_p' as tabela  ,count(1) as total from mapeamento_urbano.enc_antena_comunic_p tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.enc_torre_comunic_p' as tabela  ,count(1) as total from mapeamento_urbano.enc_torre_comunic_p tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.enc_torre_energia_p' as tabela  ,count(1) as total from mapeamento_urbano.enc_torre_energia_p tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.enc_trecho_energia_l' as tabela  ,count(1) as total from mapeamento_urbano.enc_trecho_energia_l tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.hid_area_umida_a' as tabela  ,count(1) as total from mapeamento_urbano.hid_area_umida_a tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.hid_barragem_a' as tabela  ,count(1) as total from mapeamento_urbano.hid_barragem_a tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.hid_barragem_l' as tabela  ,count(1) as total from mapeamento_urbano.hid_barragem_l tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.hid_canal_a' as tabela  ,count(1) as total from mapeamento_urbano.hid_canal_a tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.hid_canal_l' as tabela  ,count(1) as total from mapeamento_urbano.hid_canal_l tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.hid_ilha_a' as tabela  ,count(1) as total from mapeamento_urbano.hid_ilha_a tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.hid_massa_dagua_a' as tabela  ,count(1) as total from mapeamento_urbano.hid_massa_dagua_a tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.hid_sumidouro_vertedouro_p' as tabela  ,count(1) as total from mapeamento_urbano.hid_sumidouro_vertedouro_p tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.hid_trecho_drenagem_l' as tabela  ,count(1) as total from mapeamento_urbano.hid_trecho_drenagem_l tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.hid_vala_a' as tabela  ,count(1) as total from mapeamento_urbano.hid_vala_a tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.hid_vala_l' as tabela  ,count(1) as total from mapeamento_urbano.hid_vala_l tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.laz_arquibancada_a' as tabela  ,count(1) as total from mapeamento_urbano.laz_arquibancada_a tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.laz_campo_quadra_a' as tabela  ,count(1) as total from mapeamento_urbano.laz_campo_quadra_a tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.laz_piscina_a' as tabela  ,count(1) as total from mapeamento_urbano.laz_piscina_a tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.laz_pista_competicao_a' as tabela  ,count(1) as total from mapeamento_urbano.laz_pista_competicao_a tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.ponto_de_enderecamento_p' as tabela  ,count(1) as total from mapeamento_urbano.ponto_de_enderecamento_p tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.rel_curva_nivel_l' as tabela  ,count(1) as total from mapeamento_urbano.rel_curva_nivel_l tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.rel_ponto_cotado_altimetrico_p' as tabela  ,count(1) as total from mapeamento_urbano.rel_ponto_cotado_altimetrico_p tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.rel_terreno_exposto_a' as tabela  ,count(1) as total from mapeamento_urbano.rel_terreno_exposto_a tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.rod_trecho_rodoviario_a' as tabela  ,count(1) as total from mapeamento_urbano.rod_trecho_rodoviario_a tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.rod_trecho_rodoviario_l' as tabela  ,count(1) as total from mapeamento_urbano.rod_trecho_rodoviario_l tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.snb_dep_abast_agua_a' as tabela  ,count(1) as total from mapeamento_urbano.snb_dep_abast_agua_a tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.tra_caminho_carrocavel_l' as tabela  ,count(1) as total from mapeamento_urbano.tra_caminho_carrocavel_l tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.tra_passagem_elevada_viaduto_a' as tabela  ,count(1) as total from mapeamento_urbano.tra_passagem_elevada_viaduto_a tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.tra_patio_a' as tabela  ,count(1) as total from mapeamento_urbano.tra_patio_a tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.tra_ponte_a' as tabela  ,count(1) as total from mapeamento_urbano.tra_ponte_a tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.tra_travessia_pedestre_a' as tabela  ,count(1) as total from mapeamento_urbano.tra_travessia_pedestre_a tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.tra_travessia_pedestre_l' as tabela  ,count(1) as total from mapeamento_urbano.tra_travessia_pedestre_l tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.tra_trilha_picada_l' as tabela  ,count(1) as total from mapeamento_urbano.tra_trilha_picada_l tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.veg_cerrado_a' as tabela  ,count(1) as total from mapeamento_urbano.veg_cerrado_a tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.veg_veg_cultivada_a' as tabela  ,count(1) as total from mapeamento_urbano.veg_veg_cultivada_a tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.ver_arvore_isolada_p' as tabela  ,count(1) as total from mapeamento_urbano.ver_arvore_isolada_p tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03' union all
select 'mapeamento_urbano.ver_jardim_a' as tabela  ,count(1) as total from mapeamento_urbano.ver_jardim_a tb join controle_interno.area_cadastro a on a.geom&&tb.geom  and  ST_Intersects (a.geom,st_pointonsurface(tb.geom))
where a.nome='OS03') tb
where total>0
*/
