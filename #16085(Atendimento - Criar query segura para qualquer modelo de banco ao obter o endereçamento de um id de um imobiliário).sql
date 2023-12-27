SELECT nullif(upper(concat_ws(' ,',tl.descricao||' '||l.nome,i.nr_porta,nullif(trim(i.complemento),'')::text,'Bairro',b.nome)),'')

FROM cadastro.imobiliario i

left join cadastro.bairro b on st_contains(b.geom,i.geom)

LEFT JOIN cadastro.logradouro l ON i.id_logradouro = l.id

LEFT JOIN dominio.tipo_logradouro tl ON tl.codigo = tipo_logradouro::text