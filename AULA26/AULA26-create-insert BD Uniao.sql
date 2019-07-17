CREATE TABLE LOCALIDADE (
CODIGO_LOCAL INTEGER NOT NULL PRIMARY KEY, 
NOME_LOCAL VARCHAR(50)
);

INSERT INTO LOCALIDADE VALUES (1, 'Floripa'),
(2, 'Curitiba'),
(3, 'Manaus'),
(4, 'Rio de Janeiro'),
(5, 'Porto Alegre'),
(6, 'São Paulo'),
(7, 'Belo Horizonte'),
(8, 'Bela Vista'),
(9, 'Bela Vista'),
(10, 'Guanxuma');


CREATE TABLE PESSOA (
COD_PESSOA integer not null primary key, 
SEXO char(2), 
NOME varchar(50), 
SOBRENOME varchar(50), 
DATA_DE_NASCIMENTO date, 
CODIGO_LOCAL_NASC integer, 
DATA_DE_FALECIMENTO date, 
CODIGO_LOCAL_FALEC integer,
CODIGO_UNIAO_PAIS integer,
FOREIGN KEY (CODIGO_LOCAL_NASC) REFERENCES LOCALIDADE (CODIGO_LOCAL),
FOREIGN KEY (CODIGO_LOCAL_FALEC) REFERENCES LOCALIDADE (CODIGO_LOCAL)
);
INSERT INTO PESSOA VALUES (1, 'F', 'Ana', 'Morais', '12/12/1900', 1, '01/01/1980', 1, 1), 
(2, 'F', 'Ana', 'Lucas Souza', '12/12/1902', 8, '01/01/1990', 9, 1),
(3, 'F', 'Luiza', 'Silva', '12/12/1830', 1, '01/01/1980', 1, 1),
(4, 'M', 'Lucas', 'Morais', '12/12/1905', 1, '01/01/1980', 1, 1),
(5, 'M', 'Mario', 'Souza', '12/12/1905', 1, '01/01/1980', 1, 1),
(6, 'M', 'Silvio', 'Levis', '12/12/1820', 5, '01/01/1980', 5, 1),
(7, 'M', 'Leandro', 'Lima', '12/12/1900', 10, '01/01/1980', 1, 1),
(8, 'F', 'Suzana', 'Presteses', '12/12/1900', 10, '01/01/1980', 1, 6),
(9, 'F', 'Eliana', 'Goncalvez', '12/12/1900', 7, '01/01/1980', 1, 6),
(10, 'F', 'Jucileia', 'Goncalvez', '12/12/1900', 10, '01/01/1980', 1, 1),
(11, 'F', 'Analise', 'Goncalvez', '12/12/1900', 10, '01/01/1980', 1, 1),
(12, 'F', 'Lana', 'Goncalvez', '12/12/1730', 10, '01/01/1810', 1, 11),
(13, 'M', 'Luan', 'Goncalvez', '12/12/1930', 10, '01/01/1805', 1, 11);



CREATE TABLE UNIAO 
(
CODIGO_UNIAO INTEGER NOT NULL PRIMARY KEY, 
CODIGO_LOCAL INTEGER, 
COD_PESSOA_ESPOSA INTEGER, 
COD_PESSOA_MARIDO INTEGER, 
DATA_UNIAO date, 
FOREIGN KEY (COD_PESSOA_ESPOSA) REFERENCES PESSOA (COD_PESSOA),
FOREIGN KEY (CODIGO_LOCAL) REFERENCES LOCALIDADE (CODIGO_LOCAL),
FOREIGN KEY (COD_PESSOA_MARIDO) REFERENCES PESSOA (COD_PESSOA)
);

INSERT INTO UNIAO VALUES (1, 10, 8, 7, '01/01/1920'),
(2, 10, 8, 7, '01/02/1920'),
(3, 10, 9, 7, '01/03/1920'),
(4, 10, 10, 7, '01/04/1920'),
(5, 10, 11, 7, '01/05/1920'),

(6, 3, 3, 6, '01/01/1900'),

(7, 3, 8, 7, '01/01/1900'),
(8, 3, 8, 7, '01/01/1900'),
(9, 3, 8, 7, '01/01/1900'),
(10, 3, 8, 7, '01/01/1900'),

(11, 3, 8, 7, '01/07/1750');

alter table pessoa 
add FOREIGN KEY (CODIGO_UNIAO_PAIS) REFERENCES UNIAO (CODIGO_UNIAO);

