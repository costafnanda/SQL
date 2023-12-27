update mapeamento_urbano.edf_edificacao_a ed
set numeropavimentos=tb.count
from(
select ed.id,ed.geom,ed.pavimento::int+sum(coalesce(ep.pavimento,0)) as count
from mapeamento_urbano.edf_edificacao_a ed 
left join mapeamento_urbano.df_edf_projecao_a ep 
on st_contains(ed.geom,st_pointonsurface(ep.geom))
where  ed.numeropavimentos is not null 
and exists( select 1 from ${tabela} ac where st_contains(ac.geom,st_centroid(ed.geom) and ac.id =${id})
group by ed.id 
--having ed.pavimento::int+sum(coalesce(ep.pavimento,0))<>ed.numeropavimentos 
) tb
where tb.id=ed.ide



update mapeamento_urbano.edf_edificacao_a e set alturaaproximada=b.max_altura
from (SELECT distinct e.id,max(a.altura) over (partition by e.id) max_altura,--a.altura,
   nome, geometriaaproximada, operacional, situacaofisica, matconstr, alturaaproximada, turistica, cultura,e.geom, beiral, pavimento, numeropavimentos, id_lote, area, tipo_edificacao, beiral_tam, id_ponto_enderecamento
  FROM mapeamento_urbano.edf_edificacao_a e
  left join stage.altura_edificacao a on a.geom&&e.geom and st_contains(e.geom,a.geom)
  where exists( select 1 from ${tabela} ac where st_contains(ac.geom,st_centroid(e.geom) and ac.id =${id}))
  order by id ) b where b.id=e.id


