-- cidade (codigo(pk), nome, uf, regiao)
CREATE TABLE cidade
(
	codigo INTEGER NOT NULL,  -- codigo integer NOT NULL PRIMARY KEY,
	nome VARCHAR(200),
	uf CHAR(2) DEFAULT 'SC',  -- fica definido 'SC' como UF padrão.
	regiao VARCHAR(200),
	CONSTRAINT pk_cidade PRIMARY KEY(codigo)  -- se fizer: PRIMARY KEY(codigo)  -- a PK ficará sem nome.
);

-- tipo (codigo(pk), nome)
CREATE TABLE tipo
(
	codigo INTEGER NOT NULL,
	nome VARCHAR(200),
	CONSTRAINT pk_tipo PRIMARY KEY (codigo)
);

-- professor (codigo(pk), nome, RG, sexo, codCid(fk))
   -- codcid referencia cidade (codigo)
CREATE TABLE professor
(
	codigo INTEGER NOT NULL,  -- codigo integer NOT NULL PRIMARY KEY,
	nome VARCHAR(40),
	RG INTEGER NOT NULL UNIQUE,  -- tem as mesmas restrições das PKs mas não é referenciado por outras tabelas.
	sexo CHAR(1) DEFAULT 'M' CHECK (sexo in ('M', 'F')),
	codCid INTEGER NOT NULL,
	-- PRIMARY KEY(codigo)  -- a PK ficará sem nome.
	CONSTRAINT pk_professor PRIMARY KEY(codigo),
	-- FOREIGN KEY (codCid) REFERENCES cidade(codigo)  -- seria uma FK sem nome.
	CONSTRAINT fk_professor_cidade FOREIGN KEY(codCid) REFERENCES cidade(codigo)
);


-- aluno (codigo(pk), nome, raca, dtaNasc, RG, sexo, codCid(fk))
--   codcid referencia cidade (codigo)
CREATE TABLE aluno
(
	codigo INTEGER NOT NULL,
	nome VARCHAR(200),
	raca VARCHAR(200),
	dtaNasc DATE,
	RG INTEGER NOT NULL UNIQUE,
	sexo CHAR(1) DEFAULT 'M' CHECK (sexo in ('M', 'F')),
	codCid INTEGER NOT NULL,
	CONSTRAINT pk_aluno PRIMARY KEY(codigo),
	CONSTRAINT fk_aluno_cidade FOREIGN KEY(codCid) REFERENCES cidade(codigo)
);

-- aula (codAlu(pk/fk), codTip(pk/fk), codProf(pk/fk), dtaInicio(pk), dtaFim) 
   -- codAlu referencia aluno (codigo) 
   -- codTip referencia tipo (codigo) 
   -- codProf referencia professor (codigo)
CREATE TABLE aula
(
	codAlu INTEGER NOT NULL,
	codTip INTEGER NOT NULL,
	codProf INTEGER NOT NULL,
	dtaInicio DATE NOT NULL,
	dtaFim DATE,
	CONSTRAINT pk_aula PRIMARY KEY (codAlu, codTip, codProf, dtaInicio),
	CONSTRAINT fk_aula_aluno FOREIGN KEY (codAlu) REFERENCES aluno(codigo),
	CONSTRAINT fk_aula_tipo FOREIGN KEY (codTip) REFERENCES tipo(codigo),
	CONSTRAINT fk_aula_professor FOREIGN KEY (codProf) REFERENCES professor(codigo)
);


-- rendimento (codAlu(pk/fk), codTip(pk/fk), codProf(pk/fk), dtaInicio(pk/fk), observacoes, aproveitamento) 
   -- (codAlu, codTip, codProf, dtaInicio) referencia aula (codAlu, codTip, codProf, dtaInicio) 
CREATE TABLE rendimento
(
	codAlu INTEGER NOT NULL,
	codTip INTEGER NOT NULL,
	codProf INTEGER NOT NULL,
	dtaInicio DATE NOT NULL,
	observacoes VARCHAR(200),
	aproveitamento VARCHAR(10) DEFAULT 'ruim' CHECK(aproveitamento in('excelente', 'ruim', 'bom')),
	CONSTRAINT pk_rendimento PRIMARY KEY (codAlu, codTip, codProf, dtaInicio),
	CONSTRAINT fk_aula_rendimento FOREIGN KEY (codAlu, codTip, CodProf, dtaInicio) REFERENCES aula (codAlu, codTip, codProf, dtaInicio)

);

/*

Alterar o UF default da tabela para 'RS':
	ALTER TABLE cidade ALTER UF SET DEFAULT ‘RS’

Remover a definição default de UF:
	ALTER TABLE cidade ALTER UF DROP DEFAULT
Atualizar o UF de uma ciade:
	UPDATE cidade SET uf ='RS' WHERE codigo = 3
*/
