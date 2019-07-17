-- 1) Obter os nomes das localidades, onde nasceram pessoas em 12/12/1900 geradas por união ocorrida em 01/01/1900.
-- a. Resolver usando produto cartesiano.
SELECT l.nome_local
FROM pessoa p, localidade l, uniao u
	WHERE p.codigo_local_nasc = l.codigo_local
	AND p.data_de_nascimento = '1900-12-12'
	AND p.codigo_uniao_pais = u.codigo_uniao
	AND u.data_uniao = '1900-01-01';

-- b. Resolver usando junções. Se possível, usar junção natural.
-- Minha Query
SELECT l.nome_local
FROM pessoa p
JOIN uniao u
	ON u.codigo_uniao = p.codigo_uniao_pais
	AND u.data_uniao = '1900-01-01'
	AND p.data_de_nascimento = '1900-12-12'
		JOIN localidade l
			ON p.codigo_local_nasc = l.codigo_local;

-- Query gabarito.
SELECT l.nome_local
FROM localidade l
	JOIN pessoa p
	ON l.codigo_local = p.codigo_local_nasc
		JOIN uniao u
		ON p.codigo_uniao_pais = u.codigo_uniao
		WHERE p.data_de_nascimento = '1900-12-12'
		AND u.data_uniao = '1900-01-01';


-- 2) Obter os codigos e nomes dos locais nos quais não houveram uniões.
SELECT l.nome_local, l.codigo_local
FROM localidade l
	WHERE NOT EXISTS (
						SELECT *
						FROM uniao u 
						WHERE u.codigo_local = l.codigo_local
);

SELECT codigo_local, nome_local
FROM localidade
EXCEPT
SELECT l.codigo_local, l.nome_local
FROM localidade l
	JOIN uniao u 
	ON l.codigo_local = u.codigo_local;

--3) Obter uma única tabela contendo as seguintes colunas:
-- a. Código e nome de cada localidade;
-- b. Código e nome de cada mulher (PESSOA.SEXO = ’F’) nascida na localidade
--		(se na localidade não houver nascimentos de mulheres, estas colunas devem aparecer em branco);
-- c. Código de cada marido desta mulher (se apessoa não tiver maridos, esta coluna deve aparecer vazia).

-- TANTO A MINHA QUERY QUANTO O GABARITO ESTÃO DANDO RESULTADOS ERRADOS.
-- Minha Query
SELECT l.codigo_local, l.nome_local, mul.cod_pessoa, mul.nome, mar.cod_pessoa
FROM localidade l
	LEFT JOIN pessoa mul
	ON mul.codigo_local_nasc = l.codigo_local AND  mul.sexo = 'F'
		LEFT JOIN uniao u
		ON u.cod_pessoa_esposa = mul.cod_pessoa
			LEFT JOIN pessoa mar
			ON u.cod_pessoa_marido = mar.cod_pessoa AND u.cod_pessoa_esposa = mul.cod_pessoa;
	
-- Query gabarito
SELECT l.codigo_local, l.nome_local, e.cod_pessoa, e.nome, m.cod_pessoa
FROM localidade l
	LEFT JOIN pessoa e
	ON l.codigo_local = e.codigo_local_nasc AND e.sexo = 'F'
		LEFT JOIN uniao u
		ON e.cod_pessoa = u.cod_pessoa_esposa
			LEFT JOIN pessoa m
			ON m.cod_pessoa = u.cod_pessoa_marido;


-- 4) Obter o nome de cada pessoa que nasceu e faleceu em duas localidades diferentes,mas cujos nomes destas localidades são iguais.
-- Minha Query
SELECT p1.nome
FROM pessoa p1
	JOIN localidade l1
	ON l1.codigo_local = p1.codigo_local_nasc
		JOIN pessoa p2
		ON p2.cod_pessoa = p1.cod_pessoa
			JOIN localidade l2
			ON l2.codigo_local = p2.codigo_local_falec
			AND l2.nome_local = l1.nome_local
			AND l2.codigo_local <> l1.codigo_local

-- Query Gabarito
SELECT p.nome
FROM pessoa p
	JOIN localidade ln 
	ON p.cod_local_nasc = ln.codigo_local
		JOIN localidade lf 
		ON p.cod_local_falec = lf.codigo_local
		WHERE ln.nome_local = lf.nome_local AND ln.codigo_local <> lf.codigo_local

-- 5) Por um erro de software, um grande de número de uniões incorretas foi cadastrado na base de dados.
-- Estas uniões têm a característica de ligar  uma  pessoa como marido de todas pessoas da localidade denominada "Guanxuma".
-- Obter os códigos das pessoas que são marido de todas pessoas da localidade "Guanxuma".
-- Minha Query
SELECT cod_pessoa
FROM pessoa
WHERE cod_pessoa IN (
					SELECT u.cod_pessoa_marido
					FROM pessoa p
						JOIN uniao u
						ON u.cod_pessoa_marido = p.cod_pessoa
							JOIN localidade l
							ON l.codigo_local = p.codigo_local_nasc
							AND l.nome_local = 'Guanxuma'
);


-- Considere a seguinte expressão algébrica:
-- (projeção) NOME_LOCALIDADE
--		(seleção) PESSOA.COD_UNIAO_PAIS = UNIAO.COD_UNIAO
--				AND LOCALIDADE.COD_LOCAL = UNIAO.COD_LOCAL_UNIAO 
--				AND PESSOA.SEXO = 'M' 
--				AND UNIAO.DATA_UNIAO = '01/07/1750'
--				(PESSOA X (UNIAO X LOCALIDADE))
--
--	a. Expresse a consulta em SQL
-- Minha Query
SELECT l.nome_local
FROM uniao u, localidade l, pessoa p
	WHERE u.data_uniao = '1750-07-01'
	AND p.sexo = 'M'
	AND l.codigo_local = u.codigo_local
	AND p.codigo_uniao_pais = u.codigo_uniao

-- Minha Query 2
SELECT l.nome_local
FROM pessoa p
	JOIN uniao u
	ON u.data_uniao = '1750-07-01'
	AND p.sexo = 'M'
	AND p.codigo_uniao_pais = u.codigo_uniao
		JOIN localidade l
		ON l.codigo_local = u.codigo_local

-- Query gabarito
SELECT l.nome_local
FROM uniao u 
	NATURAL JOIN localidade l
		JOIN pessoa p
		ON p.sexo= ‘M’
		AND p.cod_uniao_pais = u.codigo_uniao
		WHERE u.data_uniao = ‘1750-07-01’
