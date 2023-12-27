CREATE TABLE controle_interno.pendencia_rest (
	id serial4 NOT NULL,
	geom public.geometry(point, 4326) NULL,
	obs varchar(250) NULL,
	resolvido bool NULL DEFAULT false,
	operador text NULL,
	"data" timestamp NULL,
	tecnico_restituicao text NULL,
	resposta text NULL,
	finalizado bool NULL DEFAULT false,
	CONSTRAINT pendencia_rest_pkey PRIMARY KEY (id)
);
CREATE INDEX sidx_pendencia_rest_geom ON controle_interno.pendencia_rest USING gist (geom);


ALTER TABLE controle_interno.pendencia_rest OWNER TO postgres;
GRANT ALL ON TABLE controle_interno.pendencia_rest TO postgres;
GRANT UPDATE, DELETE, SELECT, INSERT ON TABLE controle_interno.pendencia_rest TO r_dml_ribeirao_neves;
GRANT SELECT ON TABLE controle_interno.pendencia_rest TO r_sel_ribeirao_neves;



CREATE OR REPLACE FUNCTION controle_interno.at_usuario_omsrest_area()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO '"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""'
AS $function$
BEGIN
   IF (session_user::text = 'postgres') then
     return NEW;
   END IF;
   	UPDATE controle_interno.pendencia_rest o 
	SET operador= session_user::TEXT
	WHERE o.id = new.id and o.operador is null;
RETURN NEW;
END;
$function$
;

-- Permissions


CREATE OR REPLACE FUNCTION controle_interno.at_usuario_rarea()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO '"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""'
AS $function$
BEGIN
   IF (session_user::text = 'postgres') then
     return NEW;
   END IF;
   UPDATE controle_interno.pendencia_rest o SET  tecnico_restituicao= session_user::TEXT, data = now() WHERE o.id = new.id and o.resolvido = true and o.tecnico_restituicao is null;
RETURN NEW;
END;
$function$
;

-- Permissions

create trigger at_oms_rest after
insert
    or
update
    of resolvido on
    controle_interno.pendencia_rest for each row execute function controle_interno.at_usuario_rarea();
   
   
   
   
create trigger at_usuario_omsrest_area after
insert
    on
    controle_interno.pendencia_rest for each row execute function controle_interno.at_usuario_omsrest_area();


