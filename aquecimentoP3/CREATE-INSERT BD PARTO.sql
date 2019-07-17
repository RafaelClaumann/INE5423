CREATE TABLE Paciente (
CodPac INTEGER NOT NULL PRIMARY KEY, 
NomePac VARCHAR(40), 
DataNascPaC DATE
);


CREATE TABLE Internacao (
CodPac integer not null, 
NumeroIntern integer not null, 
DataHoraBaixa timestamp, 
DataHoraAlta timestamp,
primary key(codpac, numerointern),
FOREIGN KEY(CodPac) REFERENCES Paciente(codpac)
);

CREATE TABLE Leito (
NoLeito INTEGER NOT NULL PRIMARY KEY, 
CodigoQuarto integer, 
TipoLeito varchar (40), 
andar integer);

CREATE TABLE OcupaLeito (
CodPac integer not null, 
NumeroIntern integer not null, 
NoLeito integer not null, 
DataHoraInic timestamp not null, 
DataHoraFim timestamp,
primary key(CodPac, NumeroIntern, NoLeito, DataHoraInic),
FOREIGN KEY(CodPac,NumeroIntern) REFERENCES Internacao(codpac, numerointern),
FOREIGN KEY(NoLeito) REFERENCES Leito (noleito)
);
   
CREATE TABLE Parto (
CodPacBebe integer not null, 
NumeroInternBebe integer not null, 
HoraNasc time, 
TipoParto varchar(40), 
CodPacMae integer, 
NumeroInternMae integer,
primary key(CodPacBebe, NumeroInternBebe),
FOREIGN KEY(CodPacBebe,NumeroInternBebe) REFERENCES Internacao(codpac, numerointern),
FOREIGN KEY(CodPacMae,NumeroInternMae) REFERENCES Internacao(codpac, numerointern)
);


Insert into paciente values (1, 'Luan', '2000-01-01'),
(2, 'Pedro', '2000-01-01'),
(3, 'Lucas', '2000-01-01'),
(4, 'Vera', '1970-01-01'),
(5, 'Ana', '1968-01-01'),
(6, 'Marina', '1973-01-01');

insert into internacao values (4, 1, '1999-12-12', '2000-01-02'),
(5, 2, '1999-12-12', '2000-01-02'),
(6, 3, '1999-12-12', '2000-01-02'),

(1, 2, '1999-12-12', '2000-01-02'),
(2, 3, '1999-12-12', '2000-01-02'),
(3, 2, '1999-12-12', '2000-01-02');


insert into leito values (1, 20, 'SUS', 2),
(2, 22, 'SUS', 2), (3, 30, 'Privado', 3), (4, 33, 'Privado', 3), (5, 24, 'SUS', 2);

insert into ocupaleito values (4, 1, 3, '1999-12-12 8:00:00' , NULL),
(5, 2, 4, '1999-12-12 8:00:00' , NULL),
(6, 3, 5, '1999-12-12 8:00:00' , NULL);

insert into parto values (1, 2, '8:00:00','Natural', 4, 1), 
(2, 3, '8:00:00','Natural', 5, 2), 
(3, 2, '8:00:00','Natural', 6, 3);

