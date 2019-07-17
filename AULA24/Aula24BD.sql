/*
profissao (codigo(pk), area, nome)

cidade (codigo(pk), nome, UF)

paciente (codigo(pk), nome, email, idade, fone, codProf(fk), codCid(fk))
	codProf REFERENCIA profissao (codigo)
	codCid REFERENCIA cidade (codigo)

medico (codigo(pk), nome, email, CRM, codCid(fk))
	codCid REFERENCIA cidade (codigo)

especializacao (codigo(pk), nome, area)

convenio (codigo(pk), nome)

medEsp (codEsp(pk/fk), codMed(pk/fk))
	codEsp REFERENCIA especializacao (codigo)
	codMed REFERENCIA medico (codigo)

consulta (data(pk), hora(pk), codPac(pk/fk), codMed(fk), valor, codconv(fk))
	codPac REFERENCIA paciente (codigo)
	codMed REFERENCIA medico (codigo)
	codConv REFERENCIA convenio (codigo)

medicamento (codigo(pk), descricao)

cons_medicame (data(pk/fk), hora(pk/fk), codPac(pk/fk), codMedica(fk))
	codMedica REFERENCIA medicamento(codigo)
	(data, hora, codPac) REFERENCIA consulta (data,hora, codPac)
*/



-- 1) O nome do paciente mais novo da clínica.
SELECT nome
FROM paciente
WHERE idade = (SELECT min(idade)FROM paciente);

-- 2) Obter a data e o horário das consultas da consulta mais cara 
SELECT  c.data, c.hora
FROM consulta c
WHERE c.valor = (SELECT max(c.valor) FROM consulta c);

-- 3) Data e hora das consultas, e nome dos convênios usados.
-- Recupere todas as consultas, mesmo quando não foi usado nenhum convenio.
SELECT c.data, c.hora, cv.nome
FROM consulta c LEFT JOIN convenio cv
ON c.codconv = cv.codigo;

-- 4) No Banco de Dados acima, existe alguma consulta usando NATURAL JOIN que faria sentido? Qual?
-- Mostre o código SQL desta consulta com um filtro na cláusula WHERE.
/*
	Sim, juncao de consulta com cons_medicame:
	A seguinte consulta traz a data, hora e valor das consultas de 2005 e os códigos dos medicamentos usados
*/
SELECT c.data, c.hora, c.valor, cm.codmedica
FROM consulta c NATURAL JOIN cons_medicame cm
WHERE c.data BETWEEN '2005-01-01' AND '2005-12-31';

-- 5) Data das consultas e descrição dos medicamentos usados.
-- Recupere todas as consultas, mesmo aquelas emque não houve prescrição de nenhum medicamento.
-- Ordene a resposta por ordem crescente de descrição.
SELECT c.data, m.descricao
FROM consulta c LEFT JOIN cons_medicame cm 
ON	c.data = cm.data AND
	c.hora = cm.hora AND
	c.codPac = cm.codPac
LEFT JOIN medicamento m ON cm.codMedica = m.codigo;

-- 6) Selecionar o nome do paciente que seja mais velho do que todos os pacientes da cidade de “Cruz Alta”
SELECT p.codigo, p.nome, p.idade
FROM paciente p
WHERE p.idade > ALL ( SELECT p.idade FROM paciente p JOIN cidade c
					 	ON p.codCid = c.codigo WHERE c.nome = 'Cruz Alta');

-- 7) Uma consulta com NATURAL JOIN entre paciente e medico, qual seria o resultado? Mostre o SQL.
/*
	O resultado seria composto por todo médico que também fosse paciente; porque a consulta selecionaria
 	todos os médicos que tivessem os mesmos código, nome, email e código da cidade do paciente
*/
SELECT * FROM paciente NATURAL JOIN medico;

-- 8) Nome dos médicos e áreas de suas especializações. Recupere médicos que não tem especialização
-- e especializações que não foram associadas a nenhum médico.
SELECT m.nome, e.area
FROM medico m FULL JOIN medEsp me ON me.codMed = m.codigo
FULL JOIN especializacao e ON me.codEsp = e.codigo;

-- 9) Nomes dos pacientes e datas de suas consultas anteriores a 2007.
-- Mesmo os pacientes que não tiveram consulta nesta época devem aparecer no resultado.
SELECT p.nome, c.data
FROM paciente p LEFT JOIN consulta c ON c.codPac = p.codigo AND c.data < '2007-01-01';

-- 10) Nome, email e idade dos pacientes e quantidade de consultas já realizadas na clínica.
-- Mesmo os pacientes que não tiveram consulta devem aparecer no resultado.
-- Ordenar o resultado pela quantidade.
SELECT p.nome, p.email, p.idade, COUNT(c.codPac) as qt
FROM paciente p LEFT JOIN consulta c ON c.codPac = p.codigo
GROUP BY p.nome, p.email, p.idade
ORDER BY qt;

-- 11) Nome e fone dos pacientes e valor total já gasto com consultas.
-- Mesmo os pacientes que não tiveram consulta devem aparecer no resultado.
-- Ordenar o resultado pelo somatório.
SELECT p.nome, p.fone, SUM(c.valor) as soma 
FROM paciente p LEFT JOIN consulta c ON c.codPac = p.codigo
GROUP BY p.nome, p.fone
ORDER BY soma;





