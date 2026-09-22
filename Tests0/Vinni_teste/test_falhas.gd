extends GutTest

const Fixtures = preload("res://Tests0/Vinni_teste/fixtures/fixtures.gd")


# TC-022
func test_tc006_json_malformado_retorna_erro():
	var json := JSON.new()

	var erro := json.parse(Fixtures.carregar("TC-006", "json_invalido"))

	assert_ne(erro, OK, "não pode aceitar JSON quebrado")
	assert_eq(erro, ERR_PARSE_ERROR)
	assert_ne(json.get_error_message(), "", "a engine tem que explicar o erro")
	assert_null(json.get_data(), "não pode sobrar dado depois de um parse com erro")


# TC-023
func test_tc007_abrir_arquivo_inexistente_retorna_null():
	var caminho: String = Fixtures.carregar("TC-007", "caminho")

	var arquivo := FileAccess.open(caminho, FileAccess.READ)

	assert_null(arquivo)
	assert_eq(FileAccess.get_open_error(), ERR_FILE_NOT_FOUND)
	assert_false(FileAccess.file_exists(caminho))


# TC-024
func test_tc008_string_invalida_nao_vira_numero():
	var inteiro_invalido: String = Fixtures.carregar("TC-008", "inteiro_invalido")
	var inteiro_com_lixo: String = Fixtures.carregar("TC-008", "inteiro_com_lixo")
	var float_invalido: String = Fixtures.carregar("TC-008", "float_invalido")

	assert_false(inteiro_invalido.is_valid_int(), "'abc' não é inteiro")
	assert_false(inteiro_com_lixo.is_valid_int(), "'12abc' não é inteiro")
	assert_false(float_invalido.is_valid_float(), "'1.2.3' não é float")
	assert_eq(inteiro_invalido.to_int(), 0, "to_int() de texto inválido deve dar 0")


# TC-025
func test_tc009_busca_de_item_inexistente_nao_quebra():
	var inventario: Dictionary = Fixtures.carregar("TC-009", "inventario")
	var lista: Array = Fixtures.carregar("TC-009", "lista")
	var chave_ausente: String = Fixtures.carregar("TC-009", "chave_ausente")
	var item_ausente: String = Fixtures.carregar("TC-009", "item_ausente")

	assert_false(inventario.has(chave_ausente))
	assert_null(inventario.get(chave_ausente))
	assert_eq(inventario.get(chave_ausente, 0), 0, "deve devolver o valor padrão")
	assert_eq(lista.find(item_ausente), -1)
	assert_false(lista.has(item_ausente))


# TC-026
func test_tc010_regex_com_padrao_invalido():
	var regex := RegEx.new()

	var resultado := regex.compile(Fixtures.carregar("TC-010", "padrao_invalido"))

	assert_ne(resultado, OK, "o padrão inválido não pode compilar")
	assert_false(regex.is_valid())
	# A engine imprime um erro ao compilar
	assert_engine_error(Fixtures.carregar("TC-010", "trecho_erro_engine"))
