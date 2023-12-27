--Deleção dos vinculos para nova insercao
delete from cadastro.imobiliario_pessoa;
commit;
delete from cadastro.pessoa;
commit;
--restartar as sequences
SELECT setval('cadastro.pessoa_id_seq', coalesce((select max(id)+1 from cadastro.pessoa), 1)); 
SELECT setval('cadastro.imobiliario_pessoa_id_seq', coalesce((select max(id)+1 from cadastro.imobiliario_pessoa), 1)); 

--insercao de proprietarios na tabela pessoa
insert into cadastro.pessoa
	select
   nextval ('cadastro.pessoa_id_seq'),
 codigo,
nome,
 cpf_cnpj,
 dt_criacao,
 tipo,
	cpf_cnpj_valido,
	 rg,		
	 telefone,
    email,
	 sexo,
	 Logradouro,
	 numero,
	 complemento,
	 bairro,
	 cep
    from 
    (
    select
	"codCnt" codigo,
    "nomeCnt" AS nome,
	Case
	when "fisicaCnt"='F' then 1
	when "fisicaCnt"='J' then 2
	else null
	end tipo,
	"cnpjCnt" cpf_cnpj,
	now() as dt_criacao,
	cpf_cnpj_valido,
	"rgCnt" rg,		
	"emailCnt" telefone,
    "foneCnt" email,
	"sexoCnt" sexo,
	"nomLogCnt" Logradouro,
	"numeroCnt" numero,
	"compleCnt" complemento,
	"nomBaiCnt" bairro,
	"cepCnt" cep,
	 "dtnascCnt" data_nascimento
	from legado.contribuintes prop
	where  NOT EXISTS( select 1 from cadastro.pessoa a where 
					a.codigo::int=prop."codCnt")) tb;
/*
-- adicionar colunas
	alter table cadastro.pessoa add rg character varying;
	alter table cadastro.pessoa add telefone character varying;
	alter table cadastro.pessoa add email character varying;
	alter table cadastro.pessoa add sexo character varying;
	alter table cadastro.pessoa add logradouro character varying;
	alter table cadastro.pessoa add numero character varying;
	alter table cadastro.pessoa add complemento character varying;
	alter table cadastro.pessoa add bairro character varying;
	alter table cadastro.pessoa add cep character varying;
*/
--insercao de vinculo
--propretario
insert into cadastro.imobiliario_pessoa
                select 
                nextval('cadastro.imobiliario_pessoa_id_seq'),
                id_pessoa,
                id_imobiliario,
                1 tipo_proprietario,
                now()
                from (
             select i.id id_imobiliario,pp.id id_pessoa,vi.cd_proprietario,pp.cpf_cnpj,status_proprietario,i.inscricao_cartografica
                                    from cadastro.imobiliario i 
                                    join legado.vw_imovel vi on i.inscricao_cartografica =vi.inscricao_cartografica
                                    left join cadastro.pessoa pp on pp.codigo::bigint =vi.cd_proprietario::bigint 
                                    where (i.status_proprietario <> 1 or i.status_proprietario is null)
                                    and not exists (select 1 from cadastro.imobiliario_pessoa where id_imobiliario=i.id 
                                                    and tipo='1'
                                                     )
                                    order by id_imobiliario) tb
                where id_pessoa is  not null;

--compromissario
	insert into cadastro.imobiliario_pessoa
                select 
                nextval('cadastro.imobiliario_pessoa_id_seq'),
                id_pessoa,
                id_imobiliario,
                2 tipo_proprietario,
                now()
                from (
             select i.id id_imobiliario,pp.id id_pessoa,vi.cd_compromissario,pp.cpf_cnpj,status_proprietario,i.inscricao_cartografica
                                    from cadastro.imobiliario i 
                                    join legado.vw_imovel vi on i.inscricao_cartografica =vi.inscricao_cartografica
                                    left join cadastro.pessoa pp on pp.codigo::bigint =vi.cd_compromissario::bigint 
                                    where (i.status_proprietario <> 1 or i.status_proprietario is null)
                                    and not exists (select 1 from cadastro.imobiliario_pessoa where id_imobiliario=i.id 
                                                    and tipo='2'
                                                     )
                                    order by id_imobiliario) tb
                where id_pessoa is  not null;

--posseiro
	insert into cadastro.imobiliario_pessoa
                select 
                nextval('cadastro.imobiliario_pessoa_id_seq'),
                id_pessoa,
                id_imobiliario,
                3 tipo_proprietario,
                now()
                from (
             select i.id id_imobiliario,pp.id id_pessoa,vi.cd_posseiro,pp.cpf_cnpj,status_proprietario,i.inscricao_cartografica
                                    from cadastro.imobiliario i 
                                    join legado.vw_imovel vi on i.inscricao_cartografica =vi.inscricao_cartografica
                                    left join cadastro.pessoa pp on pp.codigo::bigint =vi.cd_posseiro::bigint 
                                    where (i.status_proprietario <> 1 or i.status_proprietario is null)
                                    and not exists (select 1 from cadastro.imobiliario_pessoa where id_imobiliario=i.id 
                                                    and tipo='3'
                                                     )
                                    order by id_imobiliario) tb
                where id_pessoa is  not null;
