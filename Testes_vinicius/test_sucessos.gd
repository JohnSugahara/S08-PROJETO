extends GutTest

const Fixtures = preload("res://Tests0/fixtures/fixtures.gd")


# TC-017
func test_tc001_array_sort_ordena_elementos():
	var numeros: Array = Fixtures.carregar("TC-001", "desordenado")

	numeros.sort()
	assert_eq(numeros, Fixtures.carregar("TC-001", "crescente"), "sort() deve ordenar do menor para o maior")

	numeros.sort_custom(func(a, b): return a > b)
	assert_eq(numeros, Fixtures.carregar("TC-001", "decrescente"), "sort_custom() deve ordenar do maior para o menor")
	assert_eq(numeros.size(), 5, "a ordenação não pode perder nem duplicar um elemento")


# TC-018
func test_tc002_string_split_upper_e_format():
	var partes: PackedStringArray = Fixtures.carregar("TC-002", "csv").split(Fixtures.carregar("TC-002", "separador"))
	var mensagem: String = Fixtures.carregar("TC-002", "template").format({
		"nome": Fixtures.carregar("TC-002", "nome"),
		"pontos": Fixtures.carregar("TC-002", "pontos"),
	})

	assert_eq(partes.size(), 3, "split deveria gerar 3 partes")
	assert_eq(partes[1], "GUT")
	assert_eq(partes[0].to_upper(), "GODOT")
	assert_eq(mensagem, Fixtures.carregar("TC-002", "mensagem_esperada"))


# TC-019
func test_tc003_rng_mesma_seed_gera_mesma_sequencia():
	var semente: int = Fixtures.carregar("TC-003", "seed")
	var minimo: int = Fixtures.carregar("TC-003", "minimo")
	var maximo: int = Fixtures.carregar("TC-003", "maximo")
	var rng_a := RandomNumberGenerator.new()
	var rng_b := RandomNumberGenerator.new()
	rng_a.seed = semente
	rng_b.seed = semente

	var seq_a := []
	var seq_b := []
	for i in int(Fixtures.carregar("TC-003", "quantidade")):
		seq_a.append(rng_a.randi_range(minimo, maximo))
		seq_b.append(rng_b.randi_range(minimo, maximo))

	assert_eq(seq_a, seq_b, "mesma seed tem que dar a mesma sequência")
	for valor in seq_a:
		assert_between(valor, minimo, maximo, "numero sorteado fora do intervalo")


# TC-020
func test_tc004_node_add_child_emite_sinal():
	var nome_filho: String = Fixtures.carregar("TC-004", "nome_filho")
	var pai := Node.new()
	add_child_autofree(pai)
	var filho := Node.new()
	filho.name = nome_filho
	watch_signals(pai)

	pai.add_child(filho)

	assert_eq(pai.get_child_count(), 1)
	assert_eq(pai.get_node(nome_filho), filho)
	assert_eq(filho.get_parent(), pai)
	assert_signal_emitted(pai, Fixtures.carregar("TC-004", "sinal"))


# TC-021
func test_tc005_fileaccess_escreve_e_le_o_mesmo_conteudo():
	var caminho: String = Fixtures.carregar("TC-005", "caminho")
	var conteudo: String = Fixtures.carregar("TC-005", "conteudo")

	var escrita := FileAccess.open(caminho, FileAccess.WRITE)
	assert_not_null(escrita, "não abriu para escrita")
	escrita.store_string(conteudo)
	escrita.close()

	var leitura := FileAccess.open(caminho, FileAccess.READ)
	assert_not_null(leitura, "não abriu para leitura")
	var lido := leitura.get_as_text()
	leitura.close()

	assert_file_exists(caminho)
	assert_eq(lido, conteudo)

	DirAccess.remove_absolute(caminho)
	assert_file_does_not_exist(caminho)
