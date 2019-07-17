1) Recuperar todos os atributos dos livros:
	SELECT * FROM livro

2) Recuperar todos os atributos dos livros, cujo idioma é Português:
	SELECT * FROM livro WHERE idioma = 'Português'
	SELECT * FROM livro l WHERE l.idioma = 'Português'
	SELECT * FROM livro AS l WHERE l.idioma = 'Português'

3) Recuperar todos os dados de autores cujo nome comece com ‘C’:
	SELECT * FROM autor where nome LIKE 'C%'
	SELECT * FROM autor a where a.nome LIKE 'C%'
	SELECT * FROM autor AS a where a.nome LIKE 'C%'

4) Recuperar o nome das cidades, que comece com ‘S’ e que sejam do ‘RS’ ou de ‘SP’.
	SELECT nome FROM cidade WHERE nome LIKE 'S%' AND uf = 'RS' OR uf = 'SP'
	SELECT c.nome FROM cidade c  WHERE c.nome LIKE 'S%' AND c.uf = 'RS' OR c.uf = 'SP'
	SELECT c.nome FROM cidade AS c WHERE c.nome LIKE 'S%' AND c.uf = 'RS' OR c.uf = 'SP'

5) Recuperar titulo dos livros e preco sugerido. O preço deve ser maior do que 100 e o título deve iniciar com ‘H’:
	SELECT titulo, precoSugerido FROM livro WHERE titulo LIKE 'H%' AND precoSugerido > '100'
	SELECT l.titulo, l.precoSugerido FROM livro l WHERE l.titulo LIKE 'H%' AND l.precosugerido > '100'
	SELECT l.titulo, l.precosugerido FROM livro AS l WHERE titulo LIKE 'H%' AND l.precosugerido > '100'

6) Recuperar todos os autores que tenham nascido na década de 80 e cujo nome comece com C.
	SELECT * FROM autor where dataNasc BETWEEN '1980-01-01' AND '1989-12-31' AND nome LIKE 'C%'
	SELECT * FROM autor a WHERE a.datanasc BETWEEN '1980-01-01' AND '1989-12-31' AND a.nome LIKE 'C%'
	SELECT * FROM autor AS a WHERE a.datanasc BETWEEN '1980-01-01' AND '1989-12-31' AND a.nome LIKE 'C%'

7) Recuperar idiomas existentes para os livros cadastrados. A resposta não pode possuir resultados repetidos.
	SELECT DISTINCT livro.idioma FROM livro
	SELECT DISTINCT l.idioma FROM livro l
	SELECT DISTINCT l.idioma FROM livro AS l

8) Selecionar título dos livros com preços sugeridos superiores a 50,00.
	SELECT titulo FROM livro WHERE livro.precoSugerido > '50'
	SELECT l.titulo FROM livro l WHERE l.precoSugerido > '50'
	SELECT l.titulo FROM livro AS l WHERE l.precoSugerido > '50'


9) Selecionar nome do autor, e nome e UF das cidades dos autores cuja data de nascimento seja maior do que ‘1970-01-01’.
	Produto cartesiano: 
	SELECT a.nome, c.nome, c.uf FROM autor a, cidade c WHERE
	a.codcid = c.codigo AND a.datanasc > '1970-01-01'

	Utilizando Join: 
	SELECT a.nome, c.nome, c.uf FROM autor a JOIN cidade c ON
	a.codcid = c.codigo AND a.datanasc > '1970-01-01'

10) Selecionar nome dos autores e títulos dos livros cujo idioma ‘Português’.
	Produto cartesiano:
	SELECT a.nome, l.titulo FROM autor a, livro l, autoria aut WHERE
	a.codigo = aut.codaut AND
	l.codigo = aut.codliv AND
	l.idioma = 'Português'

	Utilizando Join:
	SELECT a.nome, l.titulo FROM autor a JOIN autoria aut ON
	a.codigo =  aut.codaut JOIN livro l ON
	l.codigo = aut.codliv AND l.idioma = 'Português'

11) Selecionar as alterações solicitadas para a as autorias feitas no ano de 2000.
	Produto cartesiano:
	SELECT r.alteracao FROM revisao r, autoria aut WHERE
	aut.codaut = r.codaut AND
	aut.codliv = r.codliv AND
	aut.data BETWEEN '2000-01-01' AND '2000-12-31'

	Utilizando Join:
	SELECT r.alteracao FROM revisao r JOIN autoria aut ON
	aut.codaut = r.codaut AND
	aut.codliv = r.codliv AND
	aut.data BETWEEN '2000-01-01' AND '2000-12-31'

12) Selecionar título dos livros, nomes de seus autores, nomes de seus revisores e qual a alteração solicitada.
	Utilizando Produto cartesiano:
	SELECT l.titulo, a.nome, ar.nome, r.alteracao 
	FROM autor a, livro l, revisao r, autoria aut, autor ar WHERE
	aut.codaut = a.codigo AND aut.codliv = l.codigo AND
	aut.codaut = r.codaut AND aut.codliv = r.codliv AND
	r.codaut = ar.codigo

	Utilizando Join:
	SELECT l.titulo, a.nome, ar.nome, r.alteracao FROM autor a
	JOIN autoria aut ON a.codigo = aut.codaut
	JOIN livro l ON l.codigo = aut.codliv
	JOIN revisao r ON aut.codaut = r.codaut AND aut.codliv = r.codliv
	JOIN autor ar ON ar.codigo = r.codrev

13) Selecionar título dos livros e preço sugerido, cujo o nome do tipo contenha a palavra ‘Literatura’.
	Utilizando Produto cartesiano:
	SELECT l.titulo, l.precoSugerido FROM livro l, tipo t WHERE
	t.nome LIKE '%Literatura%' AND l.codtip = t.codigo

	Utilizando Join:
	SELECT l.titulo, l.precoSugerido FROM livro l JOIN tipo t ON
	t.nome LIKE '%Literatura%' AND l.codtip = t.codigo

14) Selecionar o nome dos autores, nome e UF das cidades. O nome da cidade deve ser igual a ‘Floripa’ ou ‘Marau’.
	SELECT a.nome, c.nome, c.uf FROM autor a JOIN cidade c ON c.nome = 'Floripa' or c.nome = 'Marau'
	WHERE a.codcid = c.codigo

15) Nome do médico, e para cada um deles a quantidade de consultas efetuadas,
	o nome do médico deve começar com ‘P’ ou com ‘C’.
	SELECT m.nome, COUNT(m.codigo) FROM medico m JOIN consulta c ON
	m.codigo = c.codmed WHERE m.nome LIKE 'P%' OR m.nome LIKE 'C%'
	GROUP BY m.nome