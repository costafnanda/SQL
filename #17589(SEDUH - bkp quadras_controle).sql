--pg_restore --host 10.61.112.11 --port 5433 --username gabriel_oliveira -d seduh_teste -n controle_interno -t quadras_controle--verbose /bkpcomp/10_61_128_11/DIARIO/BKP_seduh_20230903.compressed

insert into controle_interno.quadras_controle
select *
from(
select *
from stage.bkp_quadras_controle_20230904
where id not in (31237,312 ) 
except
select *
from controle_interno.quadras_controle) tb
where not exists (select 1 from controle_interno.quadras_controle q where st_intersects(tb.geom, st_pointonsurface(q.geom))) 

