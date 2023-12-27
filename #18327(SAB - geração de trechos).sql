begin transaction
commit
rollback

with rows as (update cadastro.logradouro log
			  set nr_trecho =vw.secao 
			  from stage.vw_codificacao_secao_20232509 vw 
			  where vw.id_logradouro=log.id
			  and nr_trecho is null
			  returning 1)
select count(1)||' Dados Atualizados'
from rows

create or replace view stage.vw_codificacao_secao_20232509 as
select
	l.id as id_logradouro,
	l.nome as nome_logradouro,
	l.id_bairro,
	b.nome as nome_bairro,
	l.codigo,
	row_number() over (partition by l.codigo
order by
	l.codigo,
	(st_y(st_lineinterpolatepoint(st_transform(l.geom, 31983), 0::double precision))) desc,
	(st_x(st_lineinterpolatepoint(st_transform(l.geom, 31983), 0::double precision))) desc) as secao,
	(l.codigo::text || '-'::text) || row_number() over (partition by l.codigo
order by
	l.codigo,
	(st_y(st_lineinterpolatepoint(st_transform(l.geom, 31983), 0::double precision))) desc,
	(st_x(st_lineinterpolatepoint(st_transform(l.geom, 31983), 0::double precision))) desc)::text as codigo_secao,
	st_y(st_lineinterpolatepoint(st_transform(l.geom, 31983), 0::double precision)) as st_y,
	st_x(st_lineinterpolatepoint(st_transform(l.geom, 31983), 0::double precision)) as st_x,
	l.geom
from cadastro.logradouro l
left join cadastro.bairro b on l.id_bairro = b.id;
