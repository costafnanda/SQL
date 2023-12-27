CREATE OR REPLACE FUNCTION preencher_array_sequencial(arr INT[])
returns int AS $$
DECLARE
  min_val INT;
  max_val INT;
  novo_array_temp INT[] := '{}'; -- Inicialize uma matriz vazia
  proximo_numero INT := 1; -- Inicialize o próximo número a ser adicionado
  seq_num INT; -- Variável para controlar o número na série
BEGIN
  -- Encontre o valor mínimo e máximo do array original
  SELECT min(val), max(val) INTO min_val, max_val
  FROM unnest(arr) AS val;

  -- Verifique se o array original está sequencialmente ordenado
  IF (SELECT array_agg(val ORDER BY val) FROM unnest(arr) AS val) = (SELECT array_agg(num ORDER BY num) FROM generate_series(min_val, max_val) num) THEN
    -- Se for sequencial, preencha com o próximo número
    proximo_numero := max_val + 1;
  ELSE
    -- Caso contrário, preencha de forma sequencial a partir do número 1
    FOR seq_num IN SELECT generate_series(1, max_val) AS num
    LOOP
      -- Adicione apenas os números que não estão no array original
      IF seq_num NOT IN (SELECT unnest(arr)) THEN
        novo_array_temp := array_append(novo_array_temp, seq_num);
        proximo_numero := seq_num + 1; -- Atualize o próximo número
      END IF;
    END LOOP;
  END IF;

  -- Se o array original estiver vazio, defina o próximo número como 1
  IF array_length(arr, 1) IS NULL THEN
    proximo_numero := 1;
  END IF;

  -- Retorne o array original, o novo array e os números adicionados
  RETURN CASE WHEN array_length(novo_array_temp, 1) > 0 THEN novo_array_temp[1] ELSE proximo_numero END AS primeiro_numero_novo_array;
END;
$$ LANGUAGE plpgsql;


/*
 * Função: cadastro.atualizar_testada_lote()
 *
 * Descrição:
 * Esta função PL/pgSQL é acionada em resposta a uma operação de inserção ou atualização na tabela que a utiliza como gatilho (TRIGGER).
 * Ela tem a finalidade de atualizar automaticamente campos específicos de um registro (NEW) com base em consultas a outras tabelas e
 * cálculos geoespaciais. Os campos atualizados incluem id_lote, numeracao_testada, id_logradouro, id_bairro e id_quadra.
 *
 * Parâmetros:
 * - NEW: É um registro que representa a linha sendo inserida ou atualizada na tabela de destino do gatilho.
 *
 * Retorna:
 * A função retorna o registro NEW modificado, que pode então ser inserido ou atualizado na tabela de destino do gatilho.
 *
 * Funcionamento:
 * - Se o campo id_lote de NEW estiver vazio (NULL), ele é preenchido com o ID do lote mais próximo que atende a critérios de interseção
 *   e buffer geoespacial.
 * - Se o campo numeracao_testada de NEW estiver vazio (NULL), ele é preenchido com um array sequencial de valores de numeracao_testada
 *   obtidos a partir dos lotes relacionados.
 * - Se os campos id_logradouro, id_bairro, id_quadra ou vl_testada de NEW estiverem vazios (NULL), eles são preenchidos com valores
 *   obtidos a partir de consultas que identificam os objetos geográficos mais próximos à geometria de NEW.
 *
 * Observações:
 * Certifique-se de que as tabelas referenciadas (cadastro.lote, cadastro.testada_lote, cadastro.logradouro, cadastro.bairro e cadastro.quadra)
 * estejam corretamente populadas e que as colunas usadas nas consultas tenham índices para otimizar o desempenho.
 *
 * Uso:
 * Essa função é utilizada como gatilho (TRIGGER) para automatizar a atualização de campos geoespaciais em registros na tabela de destino.
 * Certifique-se de configurar adequadamente a TRIGGER que dispara esta função na tabela desejada.
 */

CREATE OR REPLACE FUNCTION cadastro.atualizar_testada_lote()
RETURNS TRIGGER AS $$
DECLARE
    rowss record;
    cd_setor text;
    cd_quadra text;
BEGIN
		if NEW.id_lote is null then 
			NEW.id_lote := (SELECT lt.id 
		 				  FROM cadastro.lote lt 
		 				  WHERE st_buffer(NEW.geom::geography,5)::geometry&&lt.geom 
		 				  and st_intersects(st_buffer(ST_LineInterpolatePoint(NEW.geom,0.5)::geography,1)::geometry,lt.geom)
		 				  limit 1);
	   end if;

	   if NEW.numeracao_testada is null
		   then NEW.numeracao_testada := (
						select preencher_array_sequencial(array_agg(tl.numeracao_testada order by tl.numeracao_testada))
						from cadastro.lote ltw
						left join cadastro.testada_lote tl on tl.id_lote =lt.id 
						where lt.id =new.id_lote
						group by lt.id
						order by lt.id);
	   end if;

	   if new.id_logradouro is null then
	   	    new.id_logradouro := (select id from cadastro.logradouro log 
								  where st_intersects(st_buffer(st_centroid(new.geom)::geography,50),log.geom) 
								  and st_buffer(new.geom::geography,50)::geometry&&log.geom 
								  order by st_distance(log.geom,st_centroid(new.geom) )limit 1);
	   end if;
	  
	   if new.id_bairro is null then
		   new.id_bairro:=(select id from cadastro.bairro b 
						   where st_intersects(b.geom,st_centroid(new.geom)) 
						   order by st_distance(b.geom,st_centroid(new.geom)));
	   end if;
	  
	   if new.id_quadra is null then
		   new.id_quadra:=(select id from cadastro.quadra q 
						   where st_intersects(q.geom,st_centroid(new.geom)) 
						   order by st_distance(q.geom,st_centroid(new.geom))limit 1);
	   end if;
	  
	   if new.vl_testada is null then
   		   new.vl_testada:=round(st_length(new.geom,true)::numeric,2);
	   end if;
	  
	  if new.lado is null and new.id_logradouro is not null then
   		   new.lado:=(cadastro.determinar_lado_testada(new.id,new.geom,new.id_logradouro));
	   end if;
	  
	  if new.lado is not null and new.nome_secao is null then
		  select lpad(s.setor,'2','0') into cd_setor 
		  from cadastro.setor s 
		  where st_contains(s.geom,st_centroid(new.geom));
	 
		  select q.quadra::text into cd_quadra 
		  from cadastro.quadra q 
		  where st_intersects(q.geom,new.geom);
	  
   		   new.nome_secao:=(format('setor:%ssecao: %s%s',cd_setor,cd_quadra,new.lado));
	   end if;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER atualizar_testada_lote
before INSERT ON cadastro.testada_lote
FOR EACH ROW
EXECUTE FUNCTION cadastro.atualizar_testada_lote();



 --Função para derterminar lado esquerdo e direito com base no id_logradouro na testada   
CREATE OR REPLACE FUNCTION cadastro.determinar_lado_testada(id_testada_lote INT
                                          ,geometry_testada geometry
                                          ,id_logradouro_testada INT) 
RETURNS TEXT as
$$
DECLARE
    resultado TEXT;
BEGIN


    WITH ClosestPoints AS (
    SELECT
        l.id AS logradouro_id,
        id_testada_lote as  id_testada, --t.id AS lote_id,
        l.geom AS logradouro_geom,
        geometry_testada as lote_geom, --t.geom AS lote_geom,
        ST_StartPoint(l.geom) AS start_pt,
        ST_EndPoint(l.geom) AS end_pt,
        ST_ClosestPoint(l.geom, geometry_testada) as p --ST_ClosestPoint(l.geom, t.geom) AS p
    from cadastro.logradouro l
    where  id_logradouro_testada=l.id 
        
),

-- 1. Método Produto Vetorial
ProdutoVetorial AS (
    SELECT
        logradouro_id,
        id_testada,
        CASE 
            WHEN 
                (ST_X(end_pt) - ST_X(start_pt)) * (ST_Y(p) - ST_Y(start_pt)) -
                (ST_Y(end_pt) - ST_Y(start_pt)) * (ST_X(p) - ST_X(start_pt)) > 0 
            THEN 'E'
            ELSE 'D'
        END AS lado_prod_vet
    FROM
        ClosestPoints
),

-- 2. Método Comparação de Azimutes
ComparacaoAzimutes AS (
    SELECT
        logradouro_id,
        id_testada,
        CASE 
            WHEN ST_Azimuth(start_pt, end_pt) - ST_Azimuth(start_pt, p) BETWEEN 0 AND pi() THEN 'D'
            ELSE 'E'
        END AS lado_comparacao_azimute
    FROM
        ClosestPoints
),

-- 3. Método Buffer e ST_Distance
BufferDistance AS (
    SELECT
        logradouro_id,
        id_testada,
        CASE 
            WHEN 
                ST_Distance(
                    ST_Buffer(logradouro_geom, 10), 
                    ST_Translate(lote_geom, -0.01, 0)
                ) < 
                ST_Distance(
                    ST_Buffer(logradouro_geom, 10),
                    ST_Translate(lote_geom, 0.01, 0)
                ) THEN 'E'
            ELSE 'D'
        END AS lado_buffer_distance
    FROM
        ClosestPoints
)

select resultado_final into resultado
FROM ProdutoVetorial a
JOIN ComparacaoAzimutes b ON a.logradouro_id = b.logradouro_id AND a.id_testada = b.id_testada
JOIN BufferDistance c ON a.logradouro_id = c.logradouro_id AND a.id_testada = c.id_testada
cross join lateral(select CASE
            WHEN 
                ARRAY[a.lado_prod_vet, b.lado_comparacao_azimute, c.lado_buffer_distance]
                @> ARRAY['Esquerdo', 'Esquerdo']::text[] 
            THEN 'E'
            ELSE 'D'
        END AS resultado_final) tb;
RETURN resultado;
END;
$$
LANGUAGE plpgsql;
        
        
        





-- Seu array original
 WITH min_max AS (
  SELECT min(val) AS min_val, max(val) AS max_val
  FROM unnest(ARRAY[1,2,3,4,7]) AS val
),
-- Crie uma série de números sequenciais incluindo o número 1
seq AS (
  SELECT generate_series(1, (SELECT max_val FROM min_max)) AS num
)
-- Selecione os números da série que não estão no array original
SELECT original_array,
       array_agg(num ORDER BY num) AS novo_array,
       array_agg(num ORDER BY num) FILTER (WHERE num NOT IN (SELECT unnest(original_array) AS val)) AS numeros_adicionados,
       (array_agg(num ORDER BY num) FILTER (WHERE num NOT IN (SELECT unnest(original_array) AS val)))[1] AS numeros_adicionados
FROM seq
CROSS JOIN (SELECT ARRAY[1,2,3,4,7] AS original_array) AS data
GROUP BY original_array;

--
WITH ClosestPoints AS (
    SELECT
        log.id AS logradouro_id,
        tl.id as  id_testada, --t.id AS lote_id,
        log.geom AS logradouro_geom,
        tl.geom as lote_geom, --t.geom AS lote_geom,
        ST_StartPoint(log.geom) AS start_pt,
        ST_EndPoint(log.geom) AS end_pt,
        ST_ClosestPoint(log.geom, tl.geom) as p --ST_ClosestPoint(l.geom, t.geom) AS p
    from cadastro.testada_lote tl
    join cadastro.logradouro log on tl.id_logradouro =log.id 
        
),

-- 1. Método Produto Vetorial
/*ste método calcula o produto vetorial de vetores para determinar de que lado um ponto pestá em relação 
a um segmento de linha de start_ptaté end_pt.
Se o resultado for positivo, atribui 'E' à lado_prod_vetcoluna, caso contrário, 'D'*/

ProdutoVetorial AS (
    SELECT
        logradouro_id,
        id_testada,
        CASE 
            WHEN 
                (ST_X(end_pt) - ST_X(start_pt)) * (ST_Y(p) - ST_Y(start_pt)) -
                (ST_Y(end_pt) - ST_Y(start_pt)) * (ST_X(p) - ST_X(start_pt)) > 0 
            THEN 'E'
            ELSE 'D'
        END AS lado_prod_vet
    FROM
        ClosestPoints
),

-- 2. Método Comparação de Azimutes
/*O azimute é o ângulo que uma linha faz com uma direção de referência (geralmente Norte). Aqui
, os azimutes de dois vetores são comparados: um entre start_pte end_pte outro entre start_pte p.
Se a diferença nos azimutes estiver entre 0 e pi (π é uma constante matemática que representa a razão 
entre a circunferência de um círculo e seu diâmetro), ele atribui 'D' à coluna, caso contrário, 'E' 
lado_comparacao_azimute.*/

ComparacaoAzimutes AS (
    SELECT
        logradouro_id,
        id_testada,
        CASE 
            WHEN ST_Azimuth(start_pt, end_pt) - ST_Azimuth(start_pt, p) BETWEEN 0 AND pi() THEN 'D'
            ELSE 'E'
        END AS lado_comparacao_azimute
    FROM
        ClosestPoints
),

-- 3. Método Buffer e ST_Distance
/*Este método cria buffers (zonas ao redor de uma geometria) de uma certa distância ao redor logradouro_geo 
em então verifica a distância das versões traduzidas lote_geomdo buffer. 
Os valores de tradução parecem ser pequenas mudanças na direção x.
Dependendo de qual ponto traduzido está mais próximo do buffer, 
ele atribui 'E' ou 'D' à lado_buffer_distancecoluna.*/

BufferDistance AS (
    SELECT
        logradouro_id,
        id_testada,
        CASE 
            WHEN 
                ST_Distance(
                    ST_Buffer(logradouro_geom, 10), 
                    ST_Translate(lote_geom, -0.01, 0)
                ) < 
                ST_Distance(
                    ST_Buffer(logradouro_geom, 10),
                    ST_Translate(lote_geom, 0.01, 0)
                ) THEN 'E'
            ELSE 'D'
        END AS lado_buffer_distance
    FROM
        ClosestPoints
)
select a.id_testada, a.logradouro_id,tb.*
FROM ProdutoVetorial a
JOIN ComparacaoAzimutes b ON a.logradouro_id = b.logradouro_id AND a.id_testada = b.id_testada
JOIN BufferDistance c ON a.logradouro_id = c.logradouro_id AND a.id_testada = c.id_testada
cross join lateral(select CASE
            WHEN 
                ARRAY[a.lado_prod_vet, b.lado_comparacao_azimute, c.lado_buffer_distance]
                @> ARRAY['Esquerdo', 'Esquerdo']::text[] 
            THEN 'E'
            ELSE 'D'
        END AS resultado_final) tb;