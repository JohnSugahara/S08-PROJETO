extends RefCounted

const ARQUIVO := "res://Tests0/fixtures/dados_teste.cfg"


static func carregar(secao: String, chave: String):
	var cfg := ConfigFile.new()
	var erro := cfg.load(ARQUIVO)
	if erro != OK:
		push_error("Não foi possível ler as fixtures: %s" % ARQUIVO)
		return null
	if not cfg.has_section_key(secao, chave):
		push_error("Fixture inexistente: [%s] %s" % [secao, chave])
		return null
	return cfg.get_value(secao, chave)
