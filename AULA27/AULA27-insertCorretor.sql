INSERT INTO Corretor VALUES (1, 'Antenor Antunes');
INSERT INTO Corretor VALUES (2, 'Maria Mariana');
INSERT INTO Corretor VALUES (3, 'Juca Chico');
INSERT INTO Corretor VALUES (4, 'Chiara Lunes');


INSERT INTO Pessoa VALUES (11111, 'Julita Rodriguez', 'F', '10-10-1970', NULL);
INSERT INTO Pessoa VALUES (22222, 'João Carlos Antunez', 'M', '10-10-1967', 11111);
UPDATE pessoa set conjugeCIC = 22222 where cic = 11111;
INSERT INTO Pessoa VALUES (33333, 'Leônidas Camppos', 'M', '01-01-1961', NULL);
INSERT INTO Pessoa VALUES (44444, 'Julia Loppes', 'F', '23-07-1972', 33333);
UPDATE pessoa set conjugeCIC = 44444 where cic =33333; 
INSERT INTO Pessoa VALUES (55555, 'Clarita Clara', 'F', '12-12-1965', NULL);
INSERT INTO Pessoa VALUES (66666, 'Juca Holiz', 'M', '10-09-1966', 55555);
UPDATE pessoa set conjugeCIC = 66666 where cic =55555;
 

INSERT INTO Imovel values (1, '2 qrts com suite', 200000.00, '2005');
INSERT INTO Imovel values (2, '1 qrt com dependência emp.', 180000.00, '2006');
INSERT INTO Imovel values (3, '4 qrts com suite', 200000.00, '2001');
INSERT INTO Imovel values (4, '3 qrts, lavabo, com suite', 280000.00, '2008');
INSERT INTO Imovel values (5, '4 qrts com suite', 200000.00, '2001');
INSERT INTO Imovel values (6, '3 qrts com suite', 250000.00, '2001');
INSERT INTO Imovel values (7, '1 qrts, s/garagem', 105000.00, '1999');


INSERT INTO venda VALUES (1, 22222, '10-08-2006', 1);
INSERT INTO venda VALUES (6, 33333, '23-08-2006', 2);
INSERT INTO venda VALUES (7, 66666, '15-01-2007', 1);
INSERT INTO venda VALUES (2, 22222, '10-08-2007', 2);
INSERT INTO venda VALUES (3, 22222, '13-10-1005', 3);
INSERT INTO venda VALUES (4, 22222, '01-01-2009', 4);
