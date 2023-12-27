-- controle_interno.apontamentos_caracterizacao definition

-- Drop table

-- DROP TABLE controle_interno.apontamentos_caracterizacao;

CREATE TABLE controle_interno.apontamentos_caracterizacao (
	id serial4 NOT NULL,
	geom public.geometry(point, 4326) NULL,
	validacao bool NULL DEFAULT false,
	observacao varchar(254) NULL,
	operador text NULL,
	"data" timestamp NULL,
	CONSTRAINT apontamentos_caracterizacao_pkey PRIMARY KEY (id)
);



-- controle_interno.verificar_lancamentos_area definition

-- Drop table

-- DROP TABLE controle_interno.verificar_lancamentos_area;

CREATE TABLE controle_interno.verificar_lancamentos_area (
	id serial4 NOT NULL,
	geom public.geometry(point, 4326) NULL,
	id_lote int4 NULL,
	tecnico text NULL,
	obs text NULL,
	validacao bool NULL,
	resposta text NULL,
	CONSTRAINT verificar_lancamentos_area_pkey PRIMARY KEY (id)
);
