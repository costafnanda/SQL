beiral smallint NOT NULL,
projecoes smallint NOT NULL,
numeropavimentos integer,

--adicionar campos a tabela
select 	'alter table '||schemaname||'.'||tablename|| ' add beiral smallint NOT NULL; ' from pg_tables
where schemaname='mapeamento_urbano' and tablename like 'hid%';
select 	'alter table '||schemaname||'.'||tablename|| ' add projecoes smallint NOT NULL; ' from pg_tables
where schemaname='mapeamento_urbano' and tablename like 'edif%';
select 	'alter table '||schemaname||'.'||tablename|| ' add numeropavimentos integer; ' from pg_tables
where schemaname='mapeamento_urbano' and tablename like 'edif%';


--alterar para geom 3d
select tablename,	'alter table '||schemaname||'.'||tablename|| ' ALTER COLUMN geom type geometry(MultiPolygonZ,31983) USING geom::geometry(MultiPolygonZ,31983); ' from pg_tables
where schemaname='mapeamento_urbano' and tablename like 'hid%\_a'
union
select tablename,	'alter table '||schemaname||'.'||tablename|| ' ALTER COLUMN geom type geometry(MultiLineStringZ,31983) USING geom::geometry(MultiLineStringZ,31983); ' from pg_tables
where schemaname='mapeamento_urbano' and tablename like 'hid%\_l'
union
select tablename,'alter table '||schemaname||'.'||tablename|| ' ALTER COLUMN geom type geometry(MultiPointZ,31983) USING geom::geometry(MultiPointZ,31983); ' from pg_tables
where schemaname='mapeamento_urbano' and tablename like 'hid%\_p'
order by tablename

--altera todas as geometrias para geometrias simples
select tablename,	'alter table '||schemaname||'.'||tablename|| ' ALTER COLUMN geom type geometry(PolygonZ,31983) USING geom::geometry(PolygonZ,31983); ' 
from pg_tables t
join information_schema.columns c on t.tablename=c.table_name
where schemaname='mapeamento_urbano' and tablename like '%\_a' and column_name='geom'
union
select tablename,	'alter table '||schemaname||'.'||tablename|| ' ALTER COLUMN geom type geometry(LineStringZ,31983) USING geom::geometry(LineStringZ,31983); ' 
from pg_tables t
join information_schema.columns c on t.tablename=c.table_name
where schemaname='mapeamento_urbano' and tablename like '%\_l' and column_name='geom'
union
select tablename,'alter table '||schemaname||'.'||tablename|| ' ALTER COLUMN geom type geometry(PointZ,31983) USING geom::geometry(PointZ,31983); ' 
from pg_tables t
join information_schema.columns c on t.tablename=c.table_name
where schemaname='mapeamento_urbano' and tablename like '%\_p' and column_name='geom'
order by tablename

count em todas as tabelas
select 'select '''||tablename||'''tabela, count(1)  from '||schemaname||'.'||tablename||';' from 
(select schemaname,tablename,'alter table '||schemaname||'.'||tablename|| ' ALTER COLUMN geom type geometry(PolygonZ,31983) USING geom::geometry(PolygonZ,31983); ' 
from pg_tables t
join information_schema.columns c on t.tablename=c.table_name
where schemaname='mapeamento_urbano' and tablename like '%\_a' and column_name='geom'
union
select schemaname,tablename,'alter table '||schemaname||'.'||tablename|| ' ALTER COLUMN geom type geometry(LineStringZ,31983) USING geom::geometry(LineStringZ,31983); ' 
from pg_tables t
join information_schema.columns c on t.tablename=c.table_name
where schemaname='mapeamento_urbano' and tablename like '%\_l' and column_name='geom'
union
select schemaname,tablename,'alter table '||schemaname||'.'||tablename|| ' ALTER COLUMN geom type geometry(PointZ,31983) USING geom::geometry(PointZ,31983); ' 
from pg_tables t
join information_schema.columns c on t.tablename=c.table_name
where schemaname='mapeamento_urbano' and tablename like '%\_p' and column_name='geom'
order by tablename
) tb


 ALTER TABLE mapeamento_urbano.ver_arvore_isolada_p
    ADD COLUMN geom_new geometry(Point,31983);
	
update mapeamento_urbano.ver_arvore_isolada_p b 
set geom_new =a.geom
FROM (select id , (ST_DUMP(geom)).geom  as geom from mapeamento_urbano.ver_arvore_isolada_p ) a
where a.id = b.id;

 select count(1) from 
( SELECT id, geom,geom_new from mapeamento_urbano.ver_arvore_isolada_p
 where geom is not null and geom_new is null
) tb

ALTER TABLE mapeamento_urbano.ver_arvore_isolada_p
    drop COLUMN geom;

ALTER TABLE mapeamento_urbano.ver_arvore_isolada_p
    RENAME geom_new TO geom;

alter table dados.lote ALTER COLUMN geom_point type  geometry(Point,4326) USING St_transform(geom_point,4326);



select tablename,type,srid,	'alter table '||schemaname||'.'||tablename|| ' ALTER COLUMN geom type geometry(Polygon,4326) USING St_transform(geom,4326); ' 
from pg_tables t
join information_schema.columns c on t.tablename=c.table_name
left join geometry_columns g on g.f_table_name=t.tablename
where schemaname='mapeamento_urbano' and tablename like '%\_a' and column_name='geom'
and g.f_table_name like 'hid_%'
and srid=31983
union
select tablename,type,srid,	'alter table '||schemaname||'.'||tablename|| ' ALTER COLUMN geom type geometry(LineString,4326) USING  St_transform(geom,4326);'
from pg_tables t
join information_schema.columns c on t.tablename=c.table_name
left join geometry_columns g on g.f_table_name=t.tablename
where schemaname='mapeamento_urbano' and tablename like '%\_l' and column_name='geom'
and  g.f_table_name  like 'hid_%'
and srid=31983
union
select tablename,type,srid,'alter table '||schemaname||'.'||tablename|| ' ALTER COLUMN geom type geometry(Point,4326) USING  St_transform(geom,4326);  ' 
from pg_tables t
join information_schema.columns c on t.tablename=c.table_name
left join geometry_columns g on g.f_table_name=t.tablename
where schemaname='mapeamento_urbano' and tablename like '%\_p' and column_name='geom'
and g.f_table_name  like 'hid_%'
and srid=31983
order by tablename

select * from geometry_columns   where f_table_name='hid_banco_areia_a' 10 where  type ilike '%MULTI%' limit 10