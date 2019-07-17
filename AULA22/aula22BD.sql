-- 1) Quantidade de médicos com consultas anteriores a '2005/09/01'
	SELECT count(DISTINCT c.codMed)
	FROM consulta c
	WHERE c.data < '2005-09-01';

-- 2) Valor total das consultas já feitas.
	SELECT sum(c.valor) FROM consulta c;

-- 3) O código, nome e CRM dos médicos, e a quantidade de consultas realizadas por cada um em ‘2006’.
--		O resultado deve ser ordenado por nome do médico.
	SELECT m.codigo, m.nome, m.crm , count(c.codMed)
	FROM medico m
	JOIN CONSULTA c ON c.codMed = m.codigo
	WHERE c.data BETWEEN '2006-01-01' AND '2006-12-31'
	GROUP BY codigo, nome, crm
	ORDER BY nome;

-- 4) Data e hora da consulta, nome do médico e nome do paciente.
--		Pacientes devem ter idade inferior a 18 anos, e a especialização do médico deve ser ‘Pediatria’.
--		Ordenar por data e hora da consulta.
	SELECT c.data, c.hora, m.nome, p.nome
	FROM MEDICO m
	JOIN CONSULTA c ON c.codMed = m.codigo
	JOIN PACIENTE p ON c.codPac = p.codigo
	JOIN MEDESP me ON me.codMed = m.codigo
	JOIN ESPECIALIZACAO e ON me.codEsp = e.codigo
	WHERE p.idade < 18 AND e.nome = 'Pediatria'
	ORDER BY data, hora;

-- 5) Data das consultas, e para cada data o somatório total dos valores, desde que este total seja maior do que 100.00.
	SELECT c.data, SUM(c.valor)
	FROM consulta c GROUP BY(c.data) HAVING sum(c.valor) > '100.00';

-- 6) Nome das cidades, e a quantidade de pacientes moradores em cada uma delas.
--		Ordenar o resultado por ordem decrescente de nome de cidade.
	SELECT c.nome, count(p.codcid) FROM cidade c JOIN paciente p ON c.codigo = p.codcid
	GROUP BY c.nome ORDER BY c.nome DESC;

-- 7) Descrição do medicamento e para cada um deles a quantidade de vezes em que ele aparece nas consultas.
--		Ordenar o resultado pela descrição do medicamento, e colocar na resposta apenas
--		aqueles cuja quantidade é maior do que 1.
	SELECT m.descricao, count(m.codigo)
	FROM medicamento m JOIN cons_medicame c ON m.codigo = c.codmedica
	GROUP BY m.codigo HAVING count(m.codigo) > '1' ORDER BY m.descricao ASC;
	
-- 8) Nome da especialização e nome do médico que possui CRM = 23453.
--		Ordenar o resultado por ordem decrescente do nome da especialização.
SELECT e.nome, m.nome
FROM especializacao e JOIN medEsp me ON e.codigo = me.codesp
JOIN medico m ON m.codigo = me.codmed AND m.crm = '23453' order by e.nome desc;

-- 9) Código, nome e CRM dos médicos que possuem consulta. Ordenar o resultado por CRM do médico, por ordem decrescente.
SELECT DISTINCT m.codigo, m.nome, m.crm
FROM medico m JOIN consulta c ON m.codigo = c.codmed
ORDER BY m.crm desc;

-- 10) Nome do médico e para cada um deles a quantidade de consultas efetuadas.
--		Devem aparecer no resultado apenas médicos com mais de uma consulta efetuada.
SELECT m.nome, COUNT(c.codmed)
FROM medico m JOIN consulta c ON m.codigo = c.codmed
GROUP BY m.nome HAVING COUNT(c.codmed) > '1';

-- 11) Descrição dos medicamentos prescritos, e para cada um deles a quantidade total prescrita.
--		Ordenar pela descrição.
SELECT m.descricao, COUNT(me.codmedica)
FROM medicamento m JOIN cons_medicame me ON m.codigo = me.codmedica
GROUP BY m.descricao ORDER BY m.descricao;

-- 12) Data da consulta, e a quantidade de pacientes com idade menor que 25.
SELECT c.data, COUNT(c.codPac)
FROM consulta c JOIN paciente p ON
c.codpac = p.codigo WHERE p.idade < '25'
GROUP BY c.data;

-- 13) Nome das cidades, e a quantidade de pacientes moradores em cada uma delas, desde que o número
--	de pacientes moradores seja mais do que 1 (>=2). Ordenar o resultado por ordem decrescente de nome de cidade.
	-- "Cruz Alta"; 2
	-- "Carazinho"; 5
SELECT c.nome, COUNT(p.codigo)
FROM cidade c JOIN paciente p ON
c.codigo = p.codcid GROUP BY c.nome HAVING COUNT(p.codigo) >= 2;

-- 14) Nome das cidades, e a quantidade de pacientes moradores em cada uma delas, cujo nome da cidade comece com ‘C’.
-- Ordenar o resultado por ordem decrescente de nome de cidade.
SELECT c.nome, COUNT(p.codigo)
FROM cidade c JOIN paciente p ON
c.codigo = p.codcid WHERE c.nome LIKE 'C%'
GROUP BY c.nome
ORDER BY c.nome DESC;

-- 15) Nome do médico, e para cada um deles a quantidade de consultas efetuadas,
--		o nome do médico deve começar com ‘P’ ou com ‘C’.
SELECT m.nome, COUNT(m.codigo) FROM medico m JOIN consulta c ON
m.codigo = c.codmed WHERE m.nome LIKE 'P%' OR m.nome LIKE 'C%'
GROUP BY m.nome
