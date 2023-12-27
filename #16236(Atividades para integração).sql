
--1)Verificar se temos numero cadastro vazio ainda;
select *
from cadastro.imobiliario i 
where i.numero_cadastro is null

--
select i.id,i.inscricao_cartografica ,inscricao_cartografica_update
from cadastro.imobiliario i 
join cadastro.lote l on st_contains(l.geom,i.geom)
join cadastro.bairro b on st_contains(b.geom,i.geom)
join cadastro.setor s on st_contains(s.geom,i.geom)
join cadastro.distrito d on st_contains(d.geom,i.geom) 
join cadastro.quadra q on st_contains(q.geom,i.geom)
cross join lateral (select lpad(d.distrito::text,'2','0')||lpad(s.setor ::text,'2','0')||lpad(q.quadra::text,3,'0')||lpad(l.nr_lote::text,'4','0')|| lpad(i.nr_unidade ::text,'3','0') as inscricao_cartografica_update) tb  
where i.inscricao_cartografica is null and inscricao_cartografica_update is not null
and i.ct_cancelamento is not true

--Inscrição Cartografica Diferentes
select i.id,i.inscricao_cartografica ,inscricao_cartografica_update
from cadastro.imobiliario i 
join cadastro.lote l on st_contains(l.geom,i.geom)
join cadastro.bairro b on st_contains(b.geom,i.geom)
join cadastro.setor s on st_contains(s.geom,i.geom)
join cadastro.distrito d on st_contains(d.geom,i.geom) 
join cadastro.quadra q on st_contains(q.geom,i.geom)
cross join lateral (select lpad(d.distrito::text,'2','0')||lpad(s.setor ::text,'2','0')||lpad(q.quadra::text,3,'0')||lpad(l.nr_lote::text,'4','0')|| lpad(i.nr_unidade ::text,'3','0') as inscricao_cartografica_update) tb  
where i.inscricao_cartografica <> inscricao_cartografica_update
and i.ct_cancelamento is not true




--2)Criar imobiliario  e colocar como ficticio quando não existir imobiliario no lote e verificar se area_construida no lote tem valor diferente de zero;
-->insert into cadastro.imobiliario (geom,ficticio,id_lote)
select st_centroid(geom),true as ficticio ,l.id
from cadastro.lote l 
where not exists (select 1 from cadastro.imobiliario i where st_intersects(l.geom,i.geom))

--3) Verificar se todos os imobiliarios do banco topocart  existem dentro do legado e se todos tem codigo propreitario  vinculado;
--4) Caso todos existam no legado e tenham vinculo, apagar todos os vinculos e pessoas existes na tabela de pessoa
--Analize Para o vinculo de pessoas 
--Numero Cadastro e Inscrição Cartografica Igual
--No banco topocart e fazer nova carga apartir do legado.pessoa e  preencher o imobiliario_pessoa;
--delete from cadastro.imobiliario_pessoa i where i.id_imobiliario in ( ) 

select i.id,i.numero_cadastro ,i.inscricao_cartografica ,cadastro.*,legado.*
from cadastro.imobiliario i 
join legado.vw_imovel vi on vi.numero_cadastro =i.numero_cadastro and vi.inscricao_cartografica =i.inscricao_cartografica 
cross join lateral (select array_remove(array_agg(distinct p.codigo::int),null) as codigos_legado
					from cadastro.imobiliario_pessoa ip
					join cadastro.pessoa p on ip.id_pessoa =p.id 
					where i.id =ip.id_imobiliario 
					group by ip.id_imobiliario) legado
cross join lateral (select array_remove(array[vi.cd_pessoa::int,vi.cd_morador::int],null) as codigos_cadastro ) cadastro
where cadastro.codigos_cadastro<>legado.codigos_legado



--5)Verificar  a partir da geometria todos os id de fk se tem divergencia ou estão nulos;

select *,'id_quadra'
from cadastro.lote l
join cadastro.quadra q 
on st_contains(q.geom,st_pointonsurface(l.geom))
where l.id_quadra <>q.id or l.id_quadra is null

select *,'id_bairro' 
from cadastro.lote l 
join cadastro.bairro b on st_contains(b.geom,st_pointonsurface(l.geom))
where b.id <>l.id_bairro or l.id_bairro is null

select *,'id_setor' 
from cadastro.lote l 
join cadastro.setor s on st_contains(s.geom,st_pointonsurface(l.geom))
where s.id <>l.id_setor or l.id_setor is null

select *,'id_distrito'
from cadastro.lote l 
join cadastro.distrito d on st_contains(d.geom,st_pointonsurface(l.geom))
where d.id <>l.id_distrito or l.id_distrito is null

select *,'id_lote'
from cadastro.imobiliario i 
join cadastro.lote l on st_contains(l.geom,i.geom)
where i.id_lote<>l.id or i.id_lote is null

select i.id,i.ct_cancelamento,'imobiliarios Sem Lotes'
from cadastro.imobiliario i
where not exists(select 1 from cadastro.lote l where st_intersects(l.geom,i.geom))
and i.ct_cancelamento is not true

--6) Atualizar a tabela de log_compare
--Atualizado





--7)Criar update para cada uma delas;
begin transaction;
------------------------------------------|ID Quadra|---------------------------------
--id_quadra
update cadastro.lote l
set id_quadr=q.id
from cadastro.quadra q
where st_contains(q.geom,st_centroid(l.geom)) 
and id_quadra is null;

--id_quadra
update cadastro.lote l
set id_quadra=tb.nova
from(select l.id,q1.id as nova , q2.id as atual 
	  from cadastro.lote l 
	  join cadastro.quadra q1 
	  on st_contains(q1.geom,st_pointonsurface(l.geom))
	  join cadastro.quadra q2 on q2.id=l.id_quadra  
	  where (l.id_quadra<>q1.id or l.id_quadra is null)
	  and round(st_area(st_intersection(l.geom,q2.geom),true)::numeric)=0) tb
where l.id=tb.id;

------------------------------------------|ID LOTE|---------------------------------

update cadastro.imobiliario i
set id_lote=l.id
from cadastro.lote l
where st_contains(l.geom,i.geom) 
and (i.id_lote<>l.id or i.id_lote is null);

------------------------------------------|ID Bairro|---------------------------------

update cadastro.lote l 
set id_bairro =b.id
from cadastro.bairro b 
where st_contains(b.geom,st_pointonsurface(l.geom))
and (b.id <>l.id_bairro or l.id_bairro is null);

------------------------------------------|ID Setor|---------------------------------

update cadastro.lote l 
set id_setor = s.id
from cadastro.setor s 
where st_contains(s.geom,st_pointonsurface(l.geom))
and (s.id <>l.id_setor or l.id_setor is null);

------------------------------------------|ID Distrito|---------------------------------

update cadastro.lote l 
set id_distrito = d.id
from cadastro.distrito d
where st_contains(d.geom,st_pointonsurface(l.geom))
and (d.id <>l.id_setor or l.id_setor is null);
------------------------------------------|            |---------------------------
commit;




--8) Criar planilha com todas aa atividades e scripts se necessário;





With inscricao_cartografica as(
				 select distinct
                       lpad(d.distrito::text,2,'0')||lpad(s.setor::text,2,'0')||lpad(q.quadra::text,3,'0')||lpad(l.nr_lote,'4','0')||lpad(i.nr_unidade::text,'3','0') inscricao_cartografica,
				       i.id as imobiliario,
				       i.inscricao_cartografica as inscricao_atual
				 from cadastro.imobiliario i 
                 left join cadastro.lote l on st_contains(l.geom,i.geom)
                 left join cadastro.distrito d on st_contains(d.geom,i.geom)
                 left join cadastro.quadra q on st_contains(q.geom ,i.geom)
                 left join cadastro.setor s on st_contains(s.geom ,i.geom)
                 left join cadastro.bairro b on st_contains(b.geom ,i.geom)
                 where i.nr_unidade is not null
                        and l.nr_lote is not null
						and i.ct_cancelamento is not true)
select *
from inscricao_cartografica i
where inscricao_atual<> i.inscricao_cartografica 