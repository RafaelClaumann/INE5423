 
-- 1) Obter o nome das pacientes que foram mães de um bebê nascido por parto de tipo "Natural" na data de "12/05/1999"
-- (a data de nascimento dos bebês está no registro do bebê como paciente).
SELECT mae.nomePac
FROM paciente mae JOIN parto pt ON mae.codpac = pt.codpacmae
		JOIN paciente bebe ON bebe.codpac = pt.codpacbebe
				AND pt.tipoparto = 'Natural' AND bebe.datanascpac = '12/05/1999';

-- Query Gabarito
SELECT mae.nomePac
FROM paciente mae JOIN parto p ON p.codPacMae = mae.CodPac
		       JOIN paciente bebe ON p.codPacBebe = bebe.CodPac
WHERE bebe.DataNascPac= '12/05/1999' AND p.TipoParto = 'Natural';


-- 2) Obter os nomes dos pacientes nascidos depois do ano 2000, para os quais não há internação.
SELECT p.nomepac
FROM paciente p
WHERE p.datanascpac >=  '2000/01/01'
EXCEPT 
SELECT p.nomepac
FROM paciente p
	JOIN internacao i ON i.codpac = p.codpac;
	
-- Query Gabarito
SELECT p.nomePac
FROM paciente p
WHERE p.datanascpac >= '2000/01/01'
AND p.codpac NOT IN (SELECT codpac FROM internacao);

SELECT p.nomePac
FROM paciente p
WHERE p.datanascpac >= '200/01/01'
AND NOT EXISTS ( SELECT * FROM internacao i WHERE i.codpac = p.codpac);

-- 3) Obter uma tabela com duas colunas: nome do paciente e data/hora de internação (data/hora de baixa).
-- A tabela deve conter, para cada paciente, seu nome seguido da data de cada uma de suas internações.
-- Pacientes sem internação devem constar na resposta, com data/hora de internação inexistente.  
SELECT p.nomepac, i.datahorabaixa
FROM paciente p LEFT JOIN internacao i ON i.codpac = p.codpac;

-- 4) Obter nome do paciente e data/hora de internação (data/hora de baixa), desde que tenham sido internações feitas
-- após o ano 2000. A tabela deve conter, para cada paciente, seu nome seguido da data de cada uma de suas internações.
-- Pacientes sem internação devem constar na resposta, com data/hora de internação inexistente.

SELECT p.nomepac, i.datahorabaixa
FROM paciente p LEFT JOIN internacao i 
ON i.codpac = p.codpac AND i.datahorabaixa >= '2000/01/01';

-- 5) Obter os nomes dos pacientes que já ocuparam leitos do hospital.
SELECT p.nomepac
FROM paciente p
WHERE EXISTS ( SELECT *
				 	FROM leito l 
				  		JOIN ocupaleito ol ON ol.noleito = l.noleito
				  			AND ol.codpac = p.codpac
				  );

SELECT p.nomePac
FROM leito l
	JOIN ocupaleito ol ON ol.noleito = l.noleito
		JOIN paciente p ON p.codpac = ol.codpac;	

-- Query Gabarito		  
SELECT p.nomePac
FROM paciente p
	JOIN ocupaleito o
		ON o.codpac = p.codpac;

-- 6) Recuperar o nome do paciente e o tipo de leito de sua internação, daqueles pacientes que foram mãe.
SELECT mae.nomepac, l.tipoleito
FROM paciente mae
	JOIN parto p ON p.codpacmae = mae.codpac
		JOIN ocupaleito ol ON ol.codpac = mae.codpac
			JOIN leito l ON l.noleito = ol.noleito;
			
-- Query gabarito
SELECT p.nomePac, l.tipoleito
FROM paciente p
	JOIN parto p ON p.codPacMae = mae.CodPac
		JOIN ocupaLeito ol ON p.codPac= ol.CodPac
			JOIN leito l ON l.NoLeito= ol.NoLeito;


--7) Retornar uma lista de pacientes com nome, data de nascimento e tipo.
-- O tipo vai ser ‘Mãe’ quando o paciente for mãe e “Bebe” quando o paciente for bebe.

SELECT mae.nomepac, mae.datanascpac, 'Mãe' AS tipo
FROM paciente mae
	JOIN parto p ON p.codpacmae = mae.codpac
UNION

SELECT bebe.nomepac, bebe.datanascpac, 'Bebe' AS tipo
FROM paciente bebe
	JOIN parto p ON p.codpacbebe = bebe.codpac
ORDER BY tipo;