extends GutTest

# Testando a API matemática nativa da engine (Gargalos de aproximação de ponto flutuante)
func test_vector2_api_normalization():
	var vec = Vector2(10, 0)
	var normalized = vec.normalized()
	
	assert_eq(normalized, Vector2(1, 0), "A API nativa do Vector2 falhou ao normalizar.")
	assert_eq(normalized.length(), 1.0, "O comprimento do vetor normalizado deve ser exatamente 1.")

# Testando a API nativa de criptografia e hashing do Godot
func test_string_sha256_api():
	var text = "godot_engine_test"
	var hash_result = text.sha256_text()
	
	assert_true(hash_result is String, "A API sha256_text deveria retornar uma String.")
	assert_eq(hash_result.length(), 64, "O hash SHA-256 da engine deve conter 64 caracteres.")

# Testando a API do interpretador JSON nativo
func test_json_parsing_core():
	var json_string = '{"status": "ok", "version": 4}'
	var json_object = JSON.new()
	var error = json_object.parse(json_string)
	
	assert_eq(error, OK, "A API do parser JSON nativo quebrou ou retornou um erro inesperado.")
	
	var data = json_object.get_data()
	assert_eq(data["status"], "ok", "Erro ao recuperar dados tipados do objeto JSON.")
