
    ALTER TABLE IF EXISTS mapeamento_urbano.vala_a
    ADD COLUMN geom_2 geometry(multipolygonz, 4326) ;
   
   
   
update mapeamento_urbano.vala_a x
set geom_2 = tb.geom
from(select st_multi((ST_Dump(ST_Polygonize(geom))).geom) as geom,id
FROM mapeamento_urbano.vala_a x
group by id) tb
where x.id=tb.id


update mapeamento_urbano.vala_a x
set geom = null


ALTER TABLE mapeamento_urbano.vala_a 
ALTER COLUMN geom 
TYPE geometry(multipolygonz, 4326) 
USING geom::geometry;



update mapeamento_urbano.vala_a x
set geom = geom_2



ALTER TABLE IF EXISTS mapeamento_urbano.vala_a
DROP COLUMN IF EXISTS geom_2;