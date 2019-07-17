-- 1) Obter os nomes das pessoas que compraram ao menos um imóvel do corretor denominado "Antenor Antunes".
SELECT * FROM buyfromantenor;

CREATE VIEW BuyFromAntenor AS
SELECT p.nomePess
from pessoa p
	JOIN venda v
	ON v.cic = p.cic
		JOIN corretor c
		ON c.codcorretor = v.codcorretor
		AND c.nomeCorretor = 'Antenor Antunes';

-- 2) Obter o nome dos corretores que mais venderam imóveis construídos em 1999.
-- Retorna as informações do corretor com codCorretor = 1.
SELECT * 
FROM corretor c
WHERE c.codcorretor = 1;

-- Esta consulta retorna a quantidade de vezes em que cada corretor realizou uma venda através da 
-- coluna quantVendas.
SELECT c.nomeCorretor, c.codCorretor, COUNT(c.codCorretor) AS quantVendas
FROM venda v
	JOIN corretor c
	ON v.codcorretor = c.codcorretor
	GROUP BY c.nomecorretor, c.codCorretor;

-- Esta consulta retorna o codCorretor do corretor que possui a maior quantidade de vendas de imoveis construídos em
-- 1999.
(SELECT MAX(vendas1999.quant)
						 FROM(
						 	SELECT COUNT(c.codcorretor) AS quant
						 	FROM venda v 
								JOIN corretor c
								ON v.codcorretor = c.codcorretor
									JOIN imovel i 
									ON v.codimovel = i.codimovel WHERE anoimovel = '1999'
									GROUP BY c.nomecorretor) vendas1999);

-- Esta consulta irá pegar os corretores com o maior numero de vendas de imoveis em 1999. Então usando a consulta
-- anterior que retornará o id do corretor com maior numero de vendar em 1999 será possivel retornar o nome do corretor
-- que vendeu mais imoveis em 1999.
SELECT c.nomecorretor
FROM venda v 
	JOIN corretor c 
	ON v.codcorretor = c.codcorretor
		JOIN imovel i
		ON v.codimovel = i.codimovel WHERE i.anoimovel= '1999'
		GROUP BY c.nomecorretor
		HAVING COUNT(c.codcorretor) = (SELECT MAX(vendas1999.quant)
						 			   FROM(
						 					SELECT COUNT(c.codcorretor) AS quant
						 					FROM venda v 
												JOIN corretor c
												ON v.codcorretor = c.codcorretor
													JOIN imovel i 
													ON v.codimovel = i.codimovel WHERE anoimovel = '1999'
													GROUP BY c.nomecorretor) vendas1999);


-- 3) Obter os nomes dos corretores que, em 2006, não venderam imóveis para compradores de sexo feminino (Sexo="F").
SELECT * FROM vis3;

CREATE VIEW vis3 AS 
SELECT c.nomecorretor
FROM corretor c
	JOIN venda v
	ON v.codcorretor = c.codcorretor
	AND v.dataVenda BETWEEN '2006/01/01' AND '2006/12/31'
		JOIN pessoa p
		ON p.cic = v.cic AND p.sexo <> 'F';


-- Query Gabarito
CREATE VIEW vis3 AS 
SELECT c.nomecorretor
FROM corretor c
	NATURAL JOIN venda v
		NATURAL JOIN pessoa p
		WHERE datavenda BETWEEN '01/01/2006' AND '12/31/2006' AND p.sexo <> 'F';

-- 4) Usar NATURAL JOIN. 
-- Obter os nomes das pessoas que compraram algum imóvel, construído em 1999, através do corretor denominado ‘Antenor Antunes’.
-- a) Fazer a consulta usando JOIN.
SELECT p.nomePess
FROM corretor c
	JOIN venda v
	ON v.codcorretor = c.codcorretor
	AND c.nomeCorretor = 'Antenor Antunes'
		JOIN imovel i
		ON i.codImovel = v.codImovel
		AND i.anoImovel = '1999'
			JOIN pessoa p
			ON p.cic = v.cic;

-- b) Fazer a consulta usando NATURAL JOIN.
SELECT p.nomePess
FROM pessoa p
	NATURAL JOIN venda v
		NATURAL JOIN corretor c
			NATURAL JOIN imovel i
				WHERE i.anoImovel = '1999'
				AND c.nomecorretor = 'Antenor Antunes';

-- 5) Obter uma tabela com duas colunas, compostas do nome de uma pessoa de sexo feminino (esposa), seguido do nome de
-- uma pessoa do sexo masculino (marido), desde que o marido tenha nascido em ‘1961-01-01’.
-- Caso a pessoa não tenha marido ou ele tenha nascido em outra data, a segunda coluna deve aparecer vazia.

-- Primeira tentativa, jeito dificil.
SELECT p.nomePess, ap.nomePess
FROM pessoa p
LEFT JOIN (
			SELECT e.cic, m.nomePess -- e.cic  = cic da esposa, m.nomePess nome do marido.
			FROM pessoa e
				JOIN pessoa m
				ON m.cic = e.conjugecic
				AND m.sexo = 'M'
			 	AND m.datanasc = '1961-01-01'
			) AS ap
	ON p.cic = ap.cic WHERE p.sexo = 'F';
	
-- Segunda tentativa, mais facíl.
SELECT e.nomePess, m.nomePess
FROM pessoa e
	LEFT JOIN pessoa m
	ON m.cic = e.conjugecic
		AND m.sexo = 'M'
		AND m.datanasc = '1961-01-01'
		WHERE e.sexo  = 'F';
	
-- Query gabarito
CREATE VIEW vis5 AS
SELECT f.nomepess, m.nomepess
FROM pessoa f
	LEFT JOIN pessoa m
	ON m.cic = f.ConjugeCIC
	AND m.DataNasc= '1961-01-01' WHERE f.sexo = 'F';

-- 6) Considere a situação a seguir e mostre a sequência de comandos GRANTs e REVOKEs para o caso abaixo:
-- As visões acima foram projetas pelo DBA da corretora CoorpAT. A empresa possui vários funcionários que têm diferentes permissões
-- de acesso aos dados. Defina as permissões de acesso, considerando que existem dois papéis na corretora: secretária e gerente.
-- A secretária não pode ter acesso à tabela de vendas nem às visões, com exceção à visão 5; em relação às demais tabelas do BD,
-- ela deve ter somente acesso de consulta. O gerente não é DBA, mas pode ter todo tipo de acesso aos dados do BD e consulta às visões.
-- Suponha ainda, que inicialmente existem dois usuários no BD: Ana e Paulo. A Ana assume o papel de secretária e o Paulo de gerente.
-- Em um certo momento, Ana sai da empresa e entra Maria no seu lugar. Dê a Maria os privilégios que eram de Ana. 

-- considerando que existem dois papéis na corretora: secretária e gerente.
CREATE ROLE gerente;
CREATE ROLE secretaria;

-- A secretária não pode ter acesso à tabela de vendas nem às visões, com exceção à visão 5.
-- Em relação às demais tabelas do BD, ela deve ter somente acesso de consulta.
GRANT SELECT ON corretor, pessoa, imóvel, vis5 TO secretaria;

-- O gerente não é DBA, mas pode ter todo tipo de acesso aos dados do BD.
GRANT ALL ON corretor, pessoa, imóvel TO gerente;

-- Gerente pode consultar às visões.
GRANT SELECT ON vis, vis2, vis3, vis4, vis5 TO gerente;

-- Existem dois usuários no BD: Paulo e Ana.
CREATE USER Paulo WITH PASSWORD '123';
CREATE USER Ana WITH PASSWORD '123';

-- A Ana assume o papel de secretária e o Paulo de gerente.
GRANT secretaria TO Ana;
GRANT gerente TO Paulo; 

-- Em um certo momento, Ana sai da empresa.
REVOKE secretaria FROM Ana;
DROP USER Ana;

-- Maria entra no seu lugar.
CREATE USER Maria WITH PASSWORD '123';

-- Dê a Maria os privilégios que eram de Ana.
GRANT secretaria TO Maria;