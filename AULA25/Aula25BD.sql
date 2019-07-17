-- 1) Nomes dos produtos que não foram vendidos no período de: início de 2004 até final de 2007. Usando NOT EXISTS.
SELECT p.nome
FROM produto p
WHERE NOT EXISTS(
				SELECT *
					FROM venda v
					JOIN produtoVendido pv
						ON pv.numero = v.numero
						AND v.data BETWEEN '2004-01-01' AND '2007-12-31'
						AND p.codigo = pv.codprod
				);

-- 2) Data e hora das vendas, e nomes dos clientes. As vendas efetuadas para clientes sem cadastro também devem ser listadas.
SELECT v.data, v.hora, c.nome
FROM cliente c
	RIGHT JOIN venda v ON v.codclie = c.codigo
		ORDER BY c.nome;
		
SELECT v.data, v.hora, c.nome
FROM venda v
	LEFT JOIN cliente c ON c.codigo = v.codclie
		ORDER BY c.nome;

-- Um FULL JOIN retorna as duas tabelas e a intersecção entre elas.
-- A questao 2 solicita as vendas realizadas, inclusive as quais não haviam clientes cadastrados.
-- Neste banco, todos os clientes compraram algo.
-- Se eu fizesse um FULL JOIN e houvesse um cliente que não comprou algo mas está cadastrado no sistema
-- esse cliente apareceria no resultado?
-- O resultado nao seria o esperado? já que iriam aparecer clientes que nao realizaram compras.
SELECT v.data, v.hora, c.nome
FROM venda v
	FULL JOIN cliente c ON c.codigo = v.codclie
		ORDER BY c.nome;

-- As duas consultas seguintes são equivalentes. Elas retornam todas as vendas efetuadas.
-- a unica diferença seria no campo codClie, algumas vendas foram efetuadas para clientes
-- sem cadastro, logo o atributo codClie é null para determinadas rows.
SELECT v.numero, v.hora
FROM venda v
	WHERE v.codclie IS NOT NULL
		ORDER BY v.numero;

SELECT v.numero, v.hora
FROM venda v, cliente c
	WHERE c.codigo = v.codclie
	ORDER BY v.numero;

-- 3) Nomes dos produtos cujo preço de venda seja inferior ao seu preço de custo.
SELECT DISTINCT p.nome
FROM venda v
	JOIN produtovendido pv ON pv.numero = v.numero
		JOIN produto p ON p.codigo = pv.codprod AND p.preco > pv.valor;

SELECT p.nome
FROM venda v
	JOIN produtovendido pv ON pv.numero = v.numero
		JOIN produto p ON p.codigo = pv.codprod AND p.preco > pv.valor
			GROUP BY p.nome;

-- 4) Retornar o nome do funcionário que também já foi cliente.
-- Neste caso, uma mesma pessoa é identificada pelo nome + e-mail, ou seja,
-- cliente e funcionário que têm o mesmo nome e o mesmo e-mail são consideradas a mesma pessoa.

	-- a) Usando EXISTS
	SELECT f.nome, f.email
	FROM funcionario f
		WHERE EXISTS (
						SELECT *
						FROM cliente c
						WHERE c.nome = f.nome AND c.email = f.email
		);
		
	-- b) Usando JOINS
	SELECT 
	FROM funcionario f
		JOIN cliente c ON c.nome = f.nome AND c.email = f.email;

	-- Outra maneira de resolver com INTERSECT
	SELECT f.nome, f.email
	FROM funcionario f
	INTERSECT
	SELECT c.nome, c.email
	FROM cliente c

-- 5) Data de venda, nomes dos produtos e total vendido no período de:
-- início de 2003 até final de 2004, desde que este total seja superior a 100.
-- Ordene por data de venda.
-- Minha Query
SELECT v.data, p.nome, SUM(pv.valor)
FROM venda v
	JOIN produtoVendido pv ON pv.numero = v.numero AND v.data BETWEEN '2003-01-01' AND '2004-12-31'
		JOIN produto p ON p.codigo = pv.codprod
			GROUP BY (v.data, p.nome)
			HAVING SUM(pv.valor) > '100.00';

-- Query gabarito
SELECT v.data, p.nome, sum(pv.qtd * pv.valor)
FROM produto p 
	JOIN produtovendido pv ON p.codigo = pv.codprod
		JOIN venda v ON pv.numero = v.numero WHERE data between '01-01-2003' AND '12-31-2004'
		GROUP BY v.data, p.nome HAVING sum(pv.qtd * pv.valor) > 100

-- 6) Data da venda, nome do funcionário que efetuou a venda e total vendido para o cliente 'Monira Rosa'.
-- Ordene por data de venda.
-- Minha Query
SELECT v.data, f.nome, pv.valor
FROM venda v
	JOIN produtoVendido pv ON pv.numero = v.numero
		JOIN funcionario f ON f.codigo = v.codfun
			JOIN cliente c ON c.codigo = v.codclie AND c.nome = 'Monira Rosa';

-- Query gabarito
SELECT v.data, f.nome, sum(pv.qtd * pv.valor)
FROM funcionario f
	JOIN venda v ON v.codfun = f.codigo
		JOIN cliente c ON c.codigo = v.codclie
			JOIN produtovendido pv ON pv.numero = v.numero WHERE c.nome = 'Monira Rosa'
			GROUP BY v.data, f.nome

-- 7) Selecionar o nome do funcionário cujo salário é maior do que o funcionário mais velho da empresa.
-- Minha Query
SELECT f1.nome
FROM funcionario f1
WHERE f1.salario >(
					SELECT f2.salario
					FROM funcionario f2
						WHERE f2.dtanasc = (
											SELECT MIN(f3.dtanasc)
											FROM funcionario f3)
											);
-- Query gabarito
SELECT f.nome
FROM funcionario f
WHERE f.salario >(
					SELECT salario
					FROM funcionario 
						WHERE dtaNasc = (
										SELECT min(dtaNasc) FROM funcionario)
										);
	
-- 8) Nome do produto de maior preço de custo, desde que não tenha sido vendido ainda. Usando NOT EXISTS.

-- Minha query inicial, não estava retornando o nome.
SELECT MAX(preco)
FROM (
	SELECT *
	FROM produto p
		WHERE NOT EXISTS (
						SELECT *
						FROM produtoVendido pv
							WHERE pv.codprod = p.codigo )) as prods;

-- Query finalizada, baseada no gabarito, retornando nome e valor.
SELECT p.preco, nome
FROM produto p
WHERE p.preco =  (
					SELECT max(preco)
					FROM ( 
							SELECT p1.codigo, p1.preco
	  						FROM produto p1
	  							WHERE NOT EXISTS (
	  											SELECT pv.codProd
												FROM produtoVendido pv
													WHERE pv.codprod = p1.codigo )) as prods );
 
-- Relação de produtos que nunca foram vendidos.
SELECT *
FROM produto p
	WHERE NOT EXISTS (
				SELECT *
				FROM produtoVendido pv
					WHERE pv.codProd = p.codigo );


