/*
DO $$
DECLARE
    registro RECORD;
BEGIN
    FOR registro IN (
        -- Consulta para identificar as sequências vinculadas às tabelas
        SELECT
            n.nspname AS schema_name,
            c.relname AS table_name,
            a.attname AS column_name,
            s.relname AS sequence_name
        FROM
            pg_class AS s
        JOIN
            pg_depend AS d ON d.objid = s.oid
        JOIN
            pg_class AS c ON d.refobjid = c.oid
        JOIN
            pg_namespace AS n ON c.relnamespace = n.oid
        JOIN
            pg_attribute AS a ON (d.refobjid, d.refobjsubid) = (a.attrelid, a.attnum)
        WHERE
            s.relkind = 'S 'and 
             n.nspname ='mapeamento_urbano'
    ) LOOP
        EXECUTE 'ALTER SEQUENCE ' ||registro.schema_name || '.'|| registro.sequence_name ||
                ' OWNED BY ' || registro.schema_name || '.' || registro.table_name ||
                '.' || registro.column_name;
    END LOOP;
END$$
*/


--Define um Tabela owner Para as sequences Esse Passo e importante para Definir Um valor para Sequence
CREATE or replace PROCEDURE mapeamento_urbano.func_redefinir_sequence()
LANGUAGE plpgsql
AS $procedure$

DECLARE
    registro RECORD;
BEGIN
    FOR registro IN (
        -- Consulta para identificar as sequências vinculadas às tabelas
        SELECT
            n.nspname AS schema_name,
            c.relname AS table_name,
            a.attname AS column_name,
            s.relname AS sequence_name
        FROM
            pg_class AS s
        JOIN
            pg_depend AS d ON d.objid = s.oid
        JOIN
            pg_class AS c ON d.refobjid = c.oid
        JOIN
            pg_namespace AS n ON c.relnamespace = n.oid
        JOIN
            pg_attribute AS a ON (d.refobjid, d.refobjsubid) = (a.attrelid, a.attnum)
        WHERE
            s.relkind = 'S 'and 
             n.nspname ='mapeamento_urbano'
    ) LOOP
        EXECUTE 'ALTER SEQUENCE ' ||registro.schema_name || '.'|| registro.sequence_name ||
                ' OWNED BY ' || registro.schema_name || '.' || registro.table_name ||
                '.' || registro.column_name;
    END LOOP;
END ;
$procedure$;

call mapeamento_urbano.func_redefinir_sequence()


CREATE OR REPLACE FUNCTION mapeamento_urbano.atualiza_sequence(schema_destino text, tabela_destino text) 
RETURNS Text 
VOLATILE SECURITY DEFINER PARALLEL UNSAFE
AS $$
DECLARE
    last_value bigint;
    tabela text; 
begin
	tabela := schema_destino||'.'||tabela_destino;
    EXECUTE format('SELECT max(id) FROM %s', tabela) INTO last_value; 
    IF last_value IS NOT null and schema_destino='mapeamento_urbano'  THEN
        EXECUTE format('SELECT setval(pg_get_serial_sequence(''%s'', ''id''), %s)', tabela, last_value);
       return format('A Tabela %I Teve Sua Sequence Redefinida',tabela);
    END IF;

   	
END;
$$ LANGUAGE plpgsql;

select mapeamento_urbano.atualiza_sequence('mapeamento_urbano','cbge_passeio_a')