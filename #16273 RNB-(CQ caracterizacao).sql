-------------------------//INCONSISTÊNCIAS - LOTE\\------------------------------
--Lote com 2 ou mais imobiliários com Cobertura igual a “LAJE”
select l.id as id1 , l.geom 
from cadastro.lote l 
join cadastro.imobiliario i on st_contains(l.geom,i.geom)
group by l.id
having count(1)>1
and (count(i.cobertura) filter(where i.cobertura=2))>1



-------------------------//INCONSISTÊNCIAS - IMOBILIÁRIO\\------------------------------
--Quatidade de Preenchiento De Conservação
select coalesce(c.descricao::text,'Nulo') as descricao 
,round((count(1)::numeric/tb.total::numeric)*100::numeric,2)::text||'%'as concluido
from cadastro.imobiliario i 
join ${tabela_filtro} ac on st_contains(ac.geom,i.geom)
left join dominio.conservacao c on c.id=i.conservacao 
cross join lateral (select count(1) as total from cadastro.imobiliario i2 where st_contains(ac.geom,i2.geom)) tb
where ac.id =${id}
group by c.id,tb.total,ac.id
order by count(1) desc

--Quatidade de Preenchiento De Revestimento Interno
select coalesce(ri.descricao::text,'Nulo') as descricao 
,round((count(1)::numeric/tb.total::numeric)*100::numeric,2)::text||'%'as concluido
from cadastro.imobiliario i 
join ${tabela_filtro} ac on st_contains(ac.geom,i.geom)
left join dominio.revestimento_interno ri on ri.id=i.revestimento_interno 
cross join lateral (select count(1) as total from cadastro.imobiliario i2 where st_contains(ac.geom,i2.geom)) tb
where ac.id =${id}
group by ri.id,tb.total,ac.id
order by count(1) desc

--Quatidade de Preenchiento De Piso',
select coalesce(p.descricao::text,'Nulo') as descricao 
,round((count(1)::numeric/tb.total::numeric)*100::numeric,2)::text||'%'as concluido
from cadastro.imobiliario i 
join ${tabela_filtro} ac on st_contains(ac.geom,i.geom)
left join dominio.piso p on p.id=i.piso 
cross join lateral (select count(1) as total from cadastro.imobiliario i2 where st_contains(ac.geom,i2.geom)) tb
where ac.id =${id}
group by p.id,tb.total,ac.id
order by count(1) desc

--Quatidade de Preenchiento Instalação Sanitária',
select coalesce(s.descricao::text,'Nulo') as descricao 
,round((count(1)::numeric/tb.total::numeric)*100::numeric,2)::text||'%'as concluido
from cadastro.imobiliario i 
join ${tabela_filtro} ac on st_contains(ac.geom,i.geom)
left join dominio.instalacao_sanitaria s on s.id=i.instalacao_sanitaria 
cross join lateral (select count(1) as total from cadastro.imobiliario i2 where st_contains(ac.geom,i2.geom)) tb
where ac.id =${id}
group by s.id,tb.total,ac.id
order by count(1) desc

--Quatidade de Preenchiento Instalação Elétrica',
select coalesce(ie.descricao::text,'Nulo') as descricao 
,round((count(1)::numeric/tb.total::numeric)*100::numeric,2)::text||'%'as concluido
from cadastro.imobiliario i 
join ${tabela_filtro} ac on st_contains(ac.geom,i.geom)
left join dominio.instalacao_eletrica ie on ie.id=i.instalacao_eletrica 
cross join lateral (select count(1) as total from cadastro.imobiliario i2 where st_contains(ac.geom,i2.geom)) tb
where ac.id =${id}
group by ie.id,tb.total,ac.id
order by count(1) desc

-- Localização||Posicionamento “FRENTE ALINHADA” com limitacao “NENHUM”
select i.id as id1 ,i.geom
from cadastro.imobiliario i 
join cadastro.lote l on st_contains(l.geom,i.geom)
where i.posicionamento =3 and l.limitacao = 1

-- Localização||Posicionamento “FRENTE” com Tipo dificacao de “APARTAMENTO” 
select i.id as id1,i.geom
from cadastro.imobiliario i 
where i.posicionamento =1 
and i.tipo_edificacao =6

--Estrutura “METÁLICA” com cobertura||Teto diferente de “ZINCO” e “AMIANTO”
select i.id as id1 ,i.geom 
from cadastro.imobiliario i 
where i.estrutura =1 and i.cobertura not in (5,3)

--Estrutura “ADOBE” com Fachada||revestimento_externo diferente de “SEM REVESTIMENTO”
select i.estrutura ,revestimento_externo 
from cadastro.imobiliario i 
where i.estrutura = 4 and revestimento_externo <>4

--Estrutura “MADEIRA” com Fachada||revestimento_externo diferente de “PINTURA COMUM”
select *
from cadastro.imobiliario i 
where i.estrutura = 4 and i.revestimento_externo<>1

--Estrutura “ALVENARIA” com Fachada||revestimento_externo igual a “SEM REVESTIMENTO” ou “CAIACAO/REBOCO”
select i.id as id1 ,i.geom
from cadastro.imobiliario i 
where i.estrutura = 6 
and revestimento_externo in (3,4)

--Fachada||Revestimento Externo “REVESTIMENTO ESPECIAL” com Conservação diferente de “ÓTIMO” ou “BOM”
select * 
from cadastro.imobiliario i 
where revestimento_externo = 2 
and i.conservacao not in (3,4)

--Fachada||Revestimento Externo “SEM REVESTIMENTO” com Conservação diferente de “RUIM”
select i.id as id1 ,i.geom
from cadastro.imobiliario i 
where i.revestimento_externo =4 
and i.conservacao <>2

--Fachada||Revestimento Externo “CAIACAO/REBOCO” com Conservação diferente de “RUIM” ou “REGULAR”
select i.id as id1 ,i.geom
from cadastro.imobiliario i 
where i.revestimento_externo =3 
and conservacao not in(1,2)

--Fachada||Revestimento Externo “PINTURA COMUM” com Conservação igual a “RUIM”
select i.id as id1 ,i.geom
from cadastro.imobiliario i 
where i.revestimento_externo =1 
and i.conservacao =2

--Espécie||Tipo Edificação “BARRACO” com Fachada||Revestimento Externo diferente de “SEM REVESTIMENTO”
select i.id as id1 ,i.geom
from cadastro.imobiliario i 
where i.tipo_edificacao =1 and i.revestimento_externo <> 4

--Espécie||Tipo Edificação “BARRACO” associado a polígono de Edificação com área maior que 50m² (CQ ESPACIAL)
select i.id as id1 ,i.geom
from cadastro.imobiliario i 
where i.tipo_edificacao = 1 
and exists (select 1 
			 from cadastro.imobiliario_edificacao ie 
			 join cadastro.edificacao e on ie.id_edificacao =e.id 
			 where ie.id_imobiliario =i.id and st_area(e.geom,true)>=50)

--Espécie||Tipo Edificação “APARTAMENTO” com Lote contendo menos de 5 imobiliários
select string_agg(i.id::text,', ') filter(where i.tipo_edificacao=6)  as id1
from cadastro.lote l 
join cadastro.imobiliario i on st_contains(l.geom,i.geom)
group by l.id
having  6 = any(array_agg(i.tipo_edificacao))  
and  (count(i.tipo_edificacao) filter(where i.tipo_edificacao=6))<5

--Espécie||Tipo Edificação “APARTAMENTO” com Localização diferente de “FRENTE” e “FUNDO”
select i.id as id1 ,i.geom
from cadastro.imobiliario i 
where i.tipo_edificacao =6 
and i.posicionamento not in (1,2)

--Espécie||Tipo Edificação “GALPÃO” com Teto||cobertura diferente de “ZINCO”
select *
from cadastro.imobiliario i 
where i.tipo_edificacao =8 
and i.cobertura <> 5


--Espécie||Tipo Edificação “GALPÃO” com Estrutura diferente de “METÁLICA”
select i.tipo_edificacao ,i.estrutura 
from cadastro.imobiliario i 
where i.tipo_edificacao =8 
and i.estrutura <> 1

--Espécie||Tipo Edificação “GALPAO” com Utilização “RESIDENCIAL”
select i.utilizacao 
from cadastro.imobiliario i 
where i.tipo_edificacao =8
and i.utilizacao =9


--Espécie||Tipo Edificação “SALA” com Utilização “COMERCIAL”
select *
from cadastro.imobiliario i 
where i.tipo_edificacao = 9 and i.utilizacao = 5

--Espécie||Tipo Edificação “SALA” com Utilização “RESIDENCIAL”
select *
from cadastro.imobiliario i 
where i.tipo_edificacao = 9 
and i.utilizacao = 9

--Espécie||Tipo Edificação “LOJA” com Utilização “RESIDENCIAL”
select *
from cadastro.imobiliario i 
where i.tipo_edificacao = 2 
and i.utilizacao =9

--Espécie||Tipo Edificação “TELHEIRO” com Utilização “RESIDENCIAL”
select i.tipo_edificacao ,i.utilizacao 
from cadastro.imobiliario i 
where i.tipo_edificacao =11 and utilizacao = 9

--Espécie||Tipo Edificação “TELHEIRO” com Teto “ZINCO”
select i.tipo_edificacao ,cobertura 
from cadastro.imobiliario i 
where i.tipo_edificacao =11
and i.cobertura = 5

--Espécie||Tipo Edificação “TELHEIRO” com Estrutura diferente de “MADEIRA” ou “METALICA”
select * 
from cadastro.imobiliario i 
where i.tipo_edificacao =11 and estrutura not in (5,1)

--Espécie||Tipo Edificação “TELHEIRO” com Esquadria diferente de “NULL”
select *
from cadastro.imobiliario i 
where i.tipo_edificacao = 11 
and esquadrias is not null

--Espécie||Tipo Edificação “PAVILHÃO” associado a Edificação com área menor que 250m² (CQ ESPACIAL)
select i.tipo_edificacao 
from cadastro.imobiliario i
where i.tipo_edificacao =13
and exists (select 1 
			from cadastro.imobiliario_edificacao ie 
			join cadastro.edificacao e on ie.id_edificacao = e.id
			where i.id=ie.id_imobiliario  and st_area(e.geom,true)>=250)
			
--Espécie||Tipo Edificação “PAVILHÃO” com Teto diferente de “ZINCO”
select i.tipo_edificacao 
from cadastro.imobiliario i
where i.tipo_edificacao =13
and i.cobertura = 5

--Espécie||Tipo Edificação “PAVILHÃO” com Utilização diferente de “COMERCIAL” ou “PRESÍDIO”
select *
from cadastro.imobiliario i 
where i.tipo_edificacao =13 
and i.utilizacao not in (5,6)

--Espécie||Tipo Edificação “POSTO DE COMBUSTÍVEL” com Utilização diferente de “COMERCIAL”
select i.tipo_edificacao ,i.utilizacao 
from cadastro.imobiliario i 
where i.tipo_edificacao  = 12 
and i.utilizacao <> 5

--Espécie||Tipo Edificação “POSTO DE COMBUSTÍVEL” com Estrutura diferente de “METALICA”
select *
from cadastro.imobiliario i 
where i.tipo_edificacao  = 12 
and i.estrutura <> 1


--Espécie||Tipo Edificação “POSTO DE COMBUSTÍVEL” com Teto diferente de “ZINCO” ?
select *
from cadastro.imobiliario i 
where i.tipo_edificacao  = 12 
and i.cobertura = 5

--Espécie||Tipo Edificação “POSTO DE COMBUSTÍVEL” com Esquadria diferente de “NULL”
select * 
from cadastro.imobiliario i 
where i.tipo_edificacao  = 12 
and esquadrias is not null

--Espécie||Tipo Edificação “SALA” ou “LOJA” ou “GALPAO” e Utilização “CULTO” com Nome Fantasia que não contenha(igreja,assembleia,universal,mundial,graca,maconica,deus,amor,pentencostal,sao,paroquia,adventista,batista,jeova,santo,santa,capela,padroeiro,presbiteriana,evangelica,crista,uniao,congregacao,cristo,pentecostal,maranata,apostolica,oracao,ministerio,terra)
select *
from cadastro.imobiliario i 
where 
i.tipo_edificacao in (2,8,9) and i.utilizacao =3
and (unaccent(i.nome_fantasia) not ilike'%igreja%'
or unaccent(i.nome_fantasia) not ilike '%assembleia%'
or unaccent(i.nome_fantasia) not ilike '%universal%'
or unaccent(i.nome_fantasia) not ilike '%mundial%'
or unaccent(i.nome_fantasia) not ilike '%graca%'
or unaccent(i.nome_fantasia) not ilike '%maconica%'
or unaccent(i.nome_fantasia) not ilike '%deus%'
or unaccent(i.nome_fantasia) not ilike '%amor%'
or unaccent(i.nome_fantasia) not ilike '%pentencostal%'
or unaccent(i.nome_fantasia) not ilike '%sao%'
or unaccent(i.nome_fantasia) not ilike '%paroquia%'
or unaccent(i.nome_fantasia) not ilike '%adventista%'
or unaccent(i.nome_fantasia) not ilike '%batista%'
or unaccent(i.nome_fantasia) not ilike '%jeova%'
or unaccent(i.nome_fantasia) not ilike '%santo%'
or unaccent(i.nome_fantasia) not ilike '%santa%'
or unaccent(i.nome_fantasia) not ilike '%capela%'
or unaccent(i.nome_fantasia) not ilike '%padroeiro%'
or unaccent(i.nome_fantasia) not ilike '%presbiteriana%'
or unaccent(i.nome_fantasia) not ilike '%evangelica%'
or unaccent(i.nome_fantasia) not ilike '%crista%'
or unaccent(i.nome_fantasia) not ilike '%uniao%'
or unaccent(i.nome_fantasia) not ilike '%congregacao%'
or unaccent(i.nome_fantasia) not ilike '%cristo%'
or unaccent(i.nome_fantasia) not ilike '%pentecostal%'
or unaccent(i.nome_fantasia) not ilike '%maranata%'
or unaccent(i.nome_fantasia) not ilike '%apostolica%'
or unaccent(i.nome_fantasia) not ilike '%oracao%'
or unaccent(i.nome_fantasia) not ilike '%ministerio%'
or unaccent(i.nome_fantasia) not ilike '%terra%')

--Utilização “COMERCIAL” com Nome Fantasia (barbearia,cabelereiro,hair,marcenaria,serralheria,studio)
select *
from cadastro.imobiliario i 
where i.utilizacao =5 
and (unaccent(i.nome_fantasia) not ilike'%barbearia%'
or unaccent(i.nome_fantasia) not ilike'%cabelereiro%'
or unaccent(i.nome_fantasia) not ilike'%hair%'
or unaccent(i.nome_fantasia) not ilike'%marcenaria%'
or unaccent(i.nome_fantasia) not ilike'%serralheria%'
or unaccent(i.nome_fantasia) not ilike '%studio%')
 
--Utilização: “INDUSTRIAL” com Espécie||Tipo Edificação diferente de “GALPAO”, “PAVILHAO”
select *
from cadastro.imobiliario i 
where i.utilizacao  = 1
and i.tipo_edificacao not in (8,13)

--Utilização: “SERV. PUBLICO” com Espécie||Tipo Edificação diferente de “CASA” “SALA”,”LOJA”,”GALPÃO
select *
from cadastro.imobiliario i 
where utilizacao  = 7
and i.tipo_edificacao not in (2,5,8,9)

--Utilização: “MISTO” com mais de um imobiliario no lote (CQ ESPACIAL)
select unnest(array_agg(i.*) filter(where i.utilizacao=2)) as id1
,unnest(array_agg(i.geom) filter(where i.utilizacao=2)) as geom
from cadastro.lote l 
join cadastro.imobiliario i on st_contains(l.geom,i.geom)
group by l.id 
having count(i.id)>1 and 2=any(array_agg(distinct i.utilizacao)) 

--Utilização: “RESIDENCIAL” com Nome fantasia
select *
from cadastro.imobiliario i 
where nullif(i.nome_fantasia,'') is not null
and i.utilizacao =9

--Nome Fantasia clinica,exame,laboratorio,odonto,visao com Utilização diferente de “SERVIÇO” ou ESPÉCIE||tipo_edificacao diferente de “SALA”
select *
from cadastro.imobiliario i 
where (unaccent(i.nome_fantasia) ilike'%clinica%'
and unaccent(i.nome_fantasia) ilike'%exame%'
and unaccent(i.nome_fantasia) ilike'%laboratorio%'
and unaccent(i.nome_fantasia) ilike'%odonto%'
and unaccent(i.nome_fantasia) ilike'%visao%') 
and (i.utilizacao <>8 or i.tipo_edificacao <>9) 

--Teto||cobertura igual a “LAJE
select *
from cadastro.imobiliario i 
where i.cobertura =2








-------------------------//CAMPOS NULOS - LOTE\\------------------------------
--Campos nulos em Lote(limitacao,patrimonio,calcada)
select l.id as id1 ,l.geom
from cadastro.lote l 
where l.limitacao is null 
or l.patrimonio is null 
or l.calcada is null



-------------------------//CAMPOS NULOS - IMOBILIARIO\\------------------------------
--Campos nulos em imobiliários que não são de condomínio(condicoes,posicionamento,tipo_edificacao,utilizacao,estrutura,revestimento_externo,esquadrias,revestimento_interno,piso,cobertura,instalacao_sanitaria,instalacao_eletrica,conservacao)
select i.id as id1 , i.geom
from cadastro.imobiliario i 
where i.condicoes is null 
or i.posicionamento is null
or i.tipo_edificacao is null
or i.utilizacao is null
or i.estrutura is null
or i.revestimento_externo is null
or i.esquadrias is null
or i.revestimento_interno is null
or i.piso is null
or i.cobertura  is null
or i.instalacao_sanitaria is null
or i.instalacao_eletrica is null
or i.conservacao is null
