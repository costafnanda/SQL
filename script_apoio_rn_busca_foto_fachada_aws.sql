 --1)criar tabela foto_fachada_amostra Ribeirao (banco aws vm2) 
create table foto_fachada_amostra as select distinct p.id_projetos id_projeto_tenant,
pc.id_projetos_camadas,pc.nome as nome_camada,
pc.tbl_nome_db,pc.tipo_geometria,pcg.geom,pcga.*
from vm2.projetos_camadas pc 
left join vm2.projetos p on p.id_projetos = pc.id_projetos
--left join vm2.projetos_camadas_formularios pcf on pcf.id_projetos_camadas = pc.id_projetos_camadas
--left join vm2.projetos_camadas_formularios_campos pcfc on pcfc.id_projetos_camadas_formularios= pcf.id_projetos_camadas_formularios
left join vm2.projetos_camadas_geometrias pcg on pcg.id_projetos_camadas = pc.id_projetos_camadas
left join vm2.projetos_camadas_geometrias_arquivos pcga on pcga.id_projetos_camadas_geometrias=pcg.id_projetos_camadas_geometrias
where id_tenants = 985  and p.id_projetos in (2613)  and pc.id_projetos_camadas in (13394,13390)
order by 1

 --2)fazer backup foto_fachada_amostra Ribeirao  e remover tabela criada no public aws
 --3) Restaura tabela no banco de dados interno de Ribeirao das neves e ajustar view para relatório
 