CREATE EVENT TRIGGER audit.ddl_audit ON DDL_COMMAND_END
    EXECUTE PROCEDURE  audit.log_action_ddl();

CREATE or replace FUNCTION audit.log_action_ddl()
 RETURNS event_trigger
 LANGUAGE plpgsql 
 SECURITY definer AS
$$
begin
if	(tg_tag not in ('GRANT','REFRESH MATERIALIZED VIEW') and current_query() not ilike '%OWNER TO%' )
	then 
		insert into audit.audit_ddl(operacao ,query,data,usuario,banco) 
		values(tg_tag,current_query(),now(),session_user,current_database()::text);
	    RAISE NOTICE '(Operação: %, Data: %, Usuario : %, Banco : %)', tg_tag,now()::timestamp,session_user,current_database()::text;
end if;
END;
$$;

ALTER FUNCTION audit.log_action_ddl() OWNER TO postgres;

CREATE TABLE audit.audit_ddl (
	id bigserial NOT NULL,
	operacao text NULL,
	"data" timestamptz NULL,
	usuario text NULL,
	banco text NULL,
	query text NULL,
	tabela text NULL,
	CONSTRAINT audit_ddl_pkey PRIMARY KEY (id)
);

ALTER TABLE audit.audit_ddl OWNER TO postgres;
GRANT ALL ON TABLE audit.audit_ddl TO postgres;