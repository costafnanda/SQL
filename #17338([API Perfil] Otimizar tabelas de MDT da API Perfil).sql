ALTER TABLE public.rbn_mde ADD geom public.geometry(polygon, 4326) NULL;

update rbn_mde 
set geom = rast::geometry;

CREATE INDEX idx_rbn_mde_rast ON rbn_mde USING GIST (st_transform(rast, 4326));

select ST_AsGeoJSON(polatepoint) as point,rast.elevation
from (select ST_Transform(ST_SetSRID(ST_MakeLine(ST_MakePoint(-4905571.5, -2247940.4),ST_MakePoint(-4903924.9, -2246749.0)),3857),4326) as geom) as pl 
cross join lateral generate_series(0, ST_Length(pl.geom,true)::integer, 1::numeric) tb(serie)
cross join lateral ST_LineInterpolatePoint(pl.geom,tb.serie/ST_Length(pl.geom,true)) point(polatepoint)
cross join lateral(select round(st_value(rast,st_transform(point.polatepoint,31983))::numeric,2) as elevation ,rast.rast::geometry from rbn_mde rast where st_intersects(rast.geom,st_transform(point.polatepoint,31983))limit 1) as rast;




