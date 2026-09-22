extends GutTest

## Testes das funcionalidades de salvamento de arquivos do Godot 4 (GUT 9.x).
##
## LEGENDA DOS TIPOS DE TESTE usada nos comentários:
##  - I/O real: o teste toca o disco de verdade (user://), então valida a integração entre o seu código e o sistema de arquivos da engine.
##  - CAMINHO RUIM: verifica que uma situação de erro é sinalizada corretamente.
##  - EDGE CASE ou MUTAÇÃO: entradas extremas (vazio, acentos, emoji, etc.).
##  - PARAMETRIZADO: o mesmo teste rodando com vários conjuntos de dados.
##  - PONTA A PONTA ou END-2-END : simula um fluxo completo de uso (salvar -> carregar).
##  - UNIT ou UNITÁRIO: Simula uma única funcionalidade/método
##  - INTEGRAÇÃO: Utiliza uma ou mais funcionalidades distintas em um só teste
##
## Todos os arquivos são criados em user://gut_salvamento e apagados ao final
## de cada teste, então nada fica sujando o seu projeto.

# Fixtures
const DIR_TESTE := "user://gut_salvamento"

var _caminho: String

func before_each() -> void:
	DirAccess.make_dir_recursive_absolute(DIR_TESTE)
	_caminho = DIR_TESTE + "/arquivo.txt"

func after_each() -> void:
	_limpar_diretorio(DIR_TESTE)

# Funções auxiliares (não são testes: não começam com "test_")
func _limpar_diretorio(dir_path: String) -> void:
	var dir := DirAccess.open(dir_path)
	if dir == null:
		return
	for arquivo in dir.get_files():
		dir.remove(arquivo)
	for sub in dir.get_directories():
		_limpar_diretorio(dir_path + "/" + sub)
	DirAccess.remove_absolute(dir_path)


func _escrever_texto(caminho: String, texto: String) -> void:
	var f := FileAccess.open(caminho, FileAccess.WRITE)
	assert_not_null(f, "deveria abrir '%s' para escrita" % caminho)
	if f == null:
		return
	f.store_string(texto)
	f.close()


func _ler_texto(caminho: String) -> String:
	var f := FileAccess.open(caminho, FileAccess.READ)
	assert_not_null(f, "deveria abrir '%s' para leitura" % caminho)
	if f == null:
		return ""
	var texto := f.get_as_text()
	f.close()
	return texto


# Mini "sistema de save" usado nos testes de ponta a ponta.
func _salvar_jogo(caminho: String, dados: Dictionary) -> Error:
	var f := FileAccess.open(caminho, FileAccess.WRITE)
	if f == null:
		return FileAccess.get_open_error()
	f.store_string(JSON.stringify(dados))
	f.close()
	return OK


func _carregar_jogo(caminho: String) -> Dictionary:
	if not FileAccess.file_exists(caminho):
		return {}
	var f := FileAccess.open(caminho, FileAccess.READ)
	if f == null:
		return {}
	var json := JSON.new()
	var erro := json.parse(f.get_as_text())
	f.close()
	if erro != OK:
		return {}
	var dados = json.data
	return dados if dados is Dictionary else {}

## TIPO: UNIT + I/O real
## TESTA: o modo WRITE sobrescreve (trunca) o conteúdo anterior, sem deixar "sobras" do texto antigo, mesmo quando o texto novo é menor.
func test_TC026_modo_write_sobrescreve_conteudo_anterior() -> void:
	_escrever_texto(_caminho, "conteúdo antigo bem comprido")
	_escrever_texto(_caminho, "novo")

	assert_eq(_ler_texto(_caminho), "novo")


## TIPO: UNIT + I/O real
## TESTA: para acrescentar ao final (append) usa-se READ_WRITE + seek_end(); o conteúdo antigo é preservado.
func test_TC027_acrescentar_ao_final_do_arquivo() -> void:
	_escrever_texto(_caminho, "início")

	var f := FileAccess.open(_caminho, FileAccess.READ_WRITE)
	assert_not_null(f)
	f.seek_end()
	f.store_string(" + fim")
	f.close()

	assert_eq(_ler_texto(_caminho), "início + fim")

## TIPO: INTEGRAÇÃO + PARAMETRIZADO + CASO DE BORDA + I/O real
## TESTA: textos não convencionais sobrevivem à ida e volta ao disco: vazio, acentos, quebras de linha e emoji.
func test_TC028_ida_e_volta_de_textos(params = use_parameters([
		[""],
		["simples"],
		["acentuação: çãõéÇ"],
		["várias\nlinhas\naqui"],
		["emoji 🎮 no meio"],
	])) -> void:
	var texto: String = params[0]
	_escrever_texto(_caminho, texto)

	assert_eq(_ler_texto(_caminho), texto)
	if texto == "":
		assert_file_empty(_caminho)
	else:
		assert_file_not_empty(_caminho)


## TIPO: UNIT + CAMINHO RUIM + I/O real
## TESTA: Salvar dentro de uma pasta que não existe falha (a engine NÃO cria as pastas automaticamente ao abrir o arquivo).
func test_TC029_salvar_pasta_inexistente_falha() -> void:
	var caminho := DIR_TESTE + "/pasta/que/nao/existe/save.txt"

	var f := FileAccess.open(caminho, FileAccess.WRITE)

	assert_null(f)
	assert_ne(FileAccess.get_open_error(), OK)


## TIPO: INTEGRAÇÃO + I/O real
## TESTA: make_dir_recursive_absolute cria toda a árvore de pastas de uma vez, e depois é possível salvar um arquivo dentro dela.
func test_TC030_criar_pasta_recursivamente_salvar_dentro() -> void:
	var sub := DIR_TESTE + "/a/b/c"
	assert_false(DirAccess.dir_exists_absolute(sub))

	assert_eq(DirAccess.make_dir_recursive_absolute(sub), OK)
	assert_true(DirAccess.dir_exists_absolute(sub))

	var caminho := sub + "/save.txt"
	_escrever_texto(caminho, "ok")
	assert_file_exists(caminho)
	assert_eq(_ler_texto(caminho), "ok")


## TIPO: UNIT + I/O real
## TESTA: DirAccess.remove_absolute apaga o arquivo do disco.
func test_TC031_remover_arquivo() -> void:
	_escrever_texto(_caminho, "x")
	assert_file_exists(_caminho)

	assert_eq(DirAccess.remove_absolute(_caminho), OK)

	assert_file_does_not_exist(_caminho)
	assert_false(FileAccess.file_exists(_caminho))


## TIPO: UNIT + CAMINHO RUIM + I/O real
## TESTA: remover um arquivo que não existe devolve um código de erro.
func test_TC032_remover_arquivo_inexistente() -> void:
	var erro := DirAccess.remove_absolute(DIR_TESTE + "/fantasma.txt")

	assert_ne(erro, OK)


## TIPO: UNIT + I/O real
## TESTA: rename_absolute move o arquivo para o novo nome, mantendo o conteúdo e removendo o nome antigo.
func test_TC033_renomear_arquivo() -> void:
	var novo := DIR_TESTE + "/renomeado.txt"
	_escrever_texto(_caminho, "conteúdo")

	assert_eq(DirAccess.rename_absolute(_caminho, novo), OK)

	assert_file_does_not_exist(_caminho)
	assert_file_exists(novo)
	assert_eq(_ler_texto(novo), "conteúdo")


## TIPO: UNIT + I/O real
## TESTA: copy_absolute cria uma cópia idêntica e mantém o original (útil para backups de save).
func test_TC034_copiar_arquivo_mantem_original() -> void:
	var copia := DIR_TESTE + "/backup.txt"
	_escrever_texto(_caminho, "dados do jogador")

	assert_eq(DirAccess.copy_absolute(_caminho, copia), OK)

	assert_file_exists(_caminho)
	assert_file_exists(copia)
	assert_eq(_ler_texto(copia), "dados do jogador")

## TIPO: INTEGRAÇÃO + I/O real
## TESTA: salvar um Dictionary como JSON e recarregar. Também documenta a "pegadinha" clássica: números inteiros voltam como float do JSON.
func test_TC035_json_ida_e_volta() -> void:
	var caminho := DIR_TESTE + "/save.json"
	var dados := {
		"nome": "Ana",
		"nivel": 7,
		"vida": 87.5,
		"itens": ["espada", "poção"],
		"vivo": true,
	}
	_escrever_texto(caminho, JSON.stringify(dados, "\t"))

	var lido = JSON.parse_string(_ler_texto(caminho))

	assert_typeof(lido, TYPE_DICTIONARY)
	assert_eq(lido["nome"], "Ana")
	assert_eq(lido["vida"], 87.5)
	assert_eq(lido["itens"], ["espada", "poção"])
	assert_true(lido["vivo"])
	# Caracterização: o inteiro 7 volta como float 7.0.
	assert_typeof(lido["nivel"], TYPE_FLOAT)
	assert_eq(int(lido["nivel"]), 7)


## TIPO: UNIT + CAMINHO RUIM + I/O real
## TESTA: um arquivo com JSON corrompido é detectado como erro de parse (o jogo pode então cair para um save de backup ou valores padrão).
func test_TC036_json_corrompido_erro_parse() -> void:
	var caminho := DIR_TESTE + "/quebrado.json"
	_escrever_texto(caminho, "{ \"nome\": \"Ana\", isso nao e json ")

	var json := JSON.new()
	var erro := json.parse(_ler_texto(caminho))

	assert_eq(erro, ERR_PARSE_ERROR)


## TIPO: INTEGRAÇÃO + I/O real
## TESTA: store_var/get_var preservam os TIPOS do Godot (Vector2, Color, int, PackedStringArray), o que o JSON não consegue fazer sozinho.
func test_TC037_store_var_preserva_tipos_godot() -> void:
	var caminho := DIR_TESTE + "/save.dat"
	var dados := {
		"pos": Vector2(10.5, -3),
		"cor": Color.RED,
		"nivel": 7,
		"tags": PackedStringArray(["a", "b"]),
	}

	var f := FileAccess.open(caminho, FileAccess.WRITE)
	f.store_var(dados)
	f.close()

	f = FileAccess.open(caminho, FileAccess.READ)
	var lido = f.get_var()
	f.close()

	assert_eq(lido["pos"], Vector2(10.5, -3))
	assert_eq(lido["cor"], Color.RED)
	assert_typeof(lido["nivel"], TYPE_INT)
	assert_eq(lido["tags"], PackedStringArray(["a", "b"]))


## TIPO: INTEGRAÇÃO (binário) + I/O real
## TESTA: valores binários precisam ser lidos na MESMA ORDEM e com os MESMOS tamanhos em que foram gravados (8, 16, 32, 64 bits, float e string).
func test_TC038_binario_ordem_de_escrita_e_leitura() -> void:
	var caminho := DIR_TESTE + "/dados.bin"

	var f := FileAccess.open(caminho, FileAccess.WRITE)
	f.store_8(200)
	f.store_16(60000)
	f.store_32(4000000000)
	f.store_64(1 << 40)
	f.store_float(3.5)
	f.store_pascal_string("olá")
	f.close()

	f = FileAccess.open(caminho, FileAccess.READ)
	assert_eq(f.get_8(), 200)
	assert_eq(f.get_16(), 60000)
	assert_eq(f.get_32(), 4000000000)
	assert_eq(f.get_64(), 1 << 40)
	assert_eq(f.get_float(), 3.5)
	assert_eq(f.get_pascal_string(), "olá")
	assert_eq(f.get_position(), f.get_length(), "deveria ter lido o arquivo inteiro")
	f.close()



## TIPO: INTEGRAÇÃO + I/O real
## TESTA: ConfigFile.save() grava estrutura chave-valor e ConfigFile.load() recupera os valores em uma nova instância.
func test_TC039_configfile_salvar_carregar() -> void:
	var caminho := DIR_TESTE + "/config.cfg"
	var cfg := ConfigFile.new()
	cfg.set_value("audio", "volume", 0.8)
	cfg.set_value("video", "tela_cheia", true)
	cfg.set_value("jogador", "nome", "Ana")

	assert_eq(cfg.save(caminho), OK)
	assert_file_exists(caminho)

	var novo := ConfigFile.new()
	assert_eq(novo.load(caminho), OK)
	assert_eq(novo.get_value("audio", "volume"), 0.8)
	assert_true(novo.get_value("video", "tela_cheia"))
	assert_eq(novo.get_value("jogador", "nome"), "Ana")


## TIPO: INTEGRAÇÃO + CAMINHO RUIM + EDGE CASE + I/O real
## TESTA: Chaves inexistentes devolvem valores padrão, e carregar um .cfg que não existe retorna ERR_FILE_NOT_FOUND.
func test_TC040_configfile_valor_padrao_arquivo_inexistente() -> void:
	var cfg := ConfigFile.new()

	assert_eq(cfg.load(DIR_TESTE + "/nao_existe.cfg"), ERR_FILE_NOT_FOUND)
	assert_false(cfg.has_section_key("audio", "volume"))
	assert_eq(cfg.get_value("audio", "volume", 1.0), 1.0)


## TIPO: INTEGRAÇÃO + I/O real
## TESTA: ResourceSaver.save grava um Resource em .tres e ResourceLoader.load recria um objeto equivalente (CACHE_MODE_IGNORE força ler do disco em vez de devolver a mesma instância em cache).
func test_TC041_salvar_carregar_resource() -> void:
	var caminho := DIR_TESTE + "/gradiente.tres"
	var original := Gradient.new()
	original.add_point(0.5, Color.RED)

	assert_eq(ResourceSaver.save(original, caminho), OK)
	assert_file_exists(caminho)

	var carregado := ResourceLoader.load(caminho, "", ResourceLoader.CACHE_MODE_IGNORE) as Gradient

	assert_not_null(carregado)
	assert_true(carregado != original, "deveria ser uma instância nova")
	assert_eq(carregado.get_point_count(), original.get_point_count())
	assert_eq(carregado.get_offset(1), 0.5)
	assert_eq(carregado.get_color(1), Color.RED)


## TIPO: INTEGRAÇÃO + SEGURANÇA + I/O real
## TESTA: Se conteúdo criptografado está própriamente criptografado lendo o arquivo cru
func test_TC042_arquivo_criptografado_raw() -> void:
	var caminho := DIR_TESTE + "/secreto.sav"

	var f := FileAccess.open_encrypted_with_pass(caminho, FileAccess.WRITE, "senha123")
	assert_not_null(f)
	f.store_string("segredo")
	f.close()

	var leitura := FileAccess.open(caminho, FileAccess.READ)
	var bytes := leitura.get_buffer(leitura.get_length())
	leitura.close()
	assert_false(bytes.hex_encode().contains("segredo".to_utf8_buffer().hex_encode()))

## TIPO: INTEGRAÇÃO + I/O real
## TESTA: Se conteúdo criptografado pode ser descriptografado sem perda de informação com a chave correta
func test_TC043_arquivo_criptografado_senha_correta() -> void:
	var caminho := DIR_TESTE + "/secreto.sav"
	var f := FileAccess.open_encrypted_with_pass(caminho, FileAccess.WRITE, "senha123")
	f.store_string("segredo")
	f.close()
	
	var leitura := FileAccess.open_encrypted_with_pass(caminho, FileAccess.READ, "senha123")
	assert_not_null(leitura)
	assert_eq(leitura.get_as_text(), "segredo")
	leitura.close()
	
## TIPO: INTEGRAÇÃO + CAMINHO RUIM + I/O real
## TESTA: Se conteúdo criptografado está própriamente criptografado e não pode ser lido sem a senha correta
func test_TC044_arquivo_criptografado_senha_errada() -> void:
	var caminho := DIR_TESTE + "/secreto.sav"
	var f := FileAccess.open_encrypted_with_pass(caminho, FileAccess.WRITE, "senha123")
	f.store_string("segredo")
	f.close()

	var leitura := FileAccess.open_encrypted_with_pass(caminho, FileAccess.READ, "senhaerrada")

	assert_null(leitura)
	assert_engine_error("MD5 sum")
	assert_eq(FileAccess.get_open_error(), ERR_FILE_CORRUPT)

## TIPO: PONTA A PONTA + I/O real
## TESTA: Fluxo completo de salvar -> conferir arquivo -> carregar -> alterar -> reescrever -> carregar atualizado.
func test_TC045_fluxo_completo_salvar_carregar() -> void:
	var caminho := DIR_TESTE + "/slot1.json"
	var dados := {"nome": "Tales", "fase": "Ilha", "ouro": 42}

	assert_eq(_salvar_jogo(caminho, dados), OK)
	assert_file_exists(caminho)

	var carregado := _carregar_jogo(caminho)
	assert_eq(carregado["nome"], "Tales")
	assert_eq(carregado["fase"], "Ilha")
	assert_eq(int(carregado["ouro"]), 42)

	carregado["ouro"] = 51
	assert_eq(_salvar_jogo(caminho, carregado), OK)

	var recarregado := _carregar_jogo(caminho)
	assert_eq(int(recarregado["ouro"]), 51)


## TIPO: PONTA A PONTA + CAMINHO RUIM + I/O real
## TESTA: Se um arquivo não existe, carrega um arquivo vazio ao invés de causar uma excessão
func test_TC046_carregar_arquivo_faltante_devolve_vazio() -> void:
	var carregado := _carregar_jogo(DIR_TESTE + "/slot_inexistente.json")

	assert_eq(carregado, {})
	assert_true(carregado.is_empty())


## TIPO: PONTA A PONTA + CAMINHO RUIM + I/O real
## TESTA: Redundância para corrupção de arquivos, arquivos com informações faltantes são descartados
func test_TC047_carregar_corrompido_devolve_vazio() -> void:
	var caminho := DIR_TESTE + "/slot_corrompido.json"
	_escrever_texto(caminho, "{ \"nome\": \"Ana\", \"moedas\": ")

	var carregado := _carregar_jogo(caminho)

	assert_true(carregado.is_empty())


## TIPO: PONTA A PONTA + CAMINHO RUIM + I/O real
## TESTA: Tentar carregar um Json (formato certo) mas com texto não padronizado retorna nulo
func test_TC048_carregar_json_formato_errado() -> void:
	var caminho := DIR_TESTE + "/slot_lista.json"
	_escrever_texto(caminho, "[1, 2, 3]")

	var carregado := _carregar_jogo(caminho)

	assert_true(carregado.is_empty())
