# PROJETO S07

|**Membros:**|
|John Nunes Sugahara | 268 | Engenharia de Software
|Vínicius Carvalho Ensá||
|Tales||

Projeto de testes automatizados utilizando a engine **Godot** e o framework **GUT (Godot Unit Testing)**.
---

## Testes ~~ John Nunes Sugahara

### Dados Válidos / Caminho Feliz

Cenários com entradas corretas e fluxos esperados de sucesso.


TC001 — Normalização simples: verifica a normalização de um vetor.

TC002 — Normalização diagonal: verifica a normalização de um vetor diagonal.

TC003 — Comprimento: verifica o comprimento de um vetor.

TC004 — Distância: verifica a distância entre dois pontos.

TC005 — Soma: verifica a soma de dois vetores.

TC006 — Subtração: verifica a subtração de dois vetores.

TC007 — Normalização do vetor zero: verifica a normalização de Vector2.ZERO.

TC008 — Distância do mesmo ponto: verifica a distância de um ponto para ele mesmo.

### Dados Inválidos / Caminho Infeliz

TC009 — Soma com zero: verifica a soma de um vetor com Vector2.ZERO.

TC010 — Subtração por si mesmo: verifica a subtração de um vetor por ele mesmo.

TC011 — Multiplicação por zero: verifica a multiplicação de um vetor por 0.

TC012 — Valores negativos: verifica um vetor com componentes negativas.

TC013 — Vetores opostos: verifica o produto escalar entre vetores opostos.

TC014 — Vetores perpendiculares: verifica o produto escalar entre vetores perpendiculares.

TC015 — Rotação de 360°: verifica se uma rotação completa mantém o vetor.

TC016 — Valores muito pequenos: verifica a normalização de valores próximos de zero.

---

## Testes ~~ Vinícius Carvalho Ensá

### Dados Válidos / Caminho Feliz

Cenários com entradas corretas e fluxos esperados de sucesso.

TC017 — Ordenação de array: verifica a ordenação de um array em ordem crescente e decrescente.

TC018 — Manipulação de string: verifica a separação, conversão para maiúsculas e formatação de um texto.

TC019 — Geração de números aleatórios: verifica se a mesma seed produz sempre a mesma sequência.

TC020 — Inserção de nó na cena: verifica a inserção de um nó filho e a emissão do sinal correspondente.

TC021 — Escrita e leitura de arquivo: verifica se o conteúdo lido de um arquivo é igual ao conteúdo gravado.


### Dados Inválidos / Caminho Infeliz

TC022 — JSON malformado: verifica se um JSON inválido retorna erro de parse.

TC023 — Arquivo inexistente: verifica se a abertura de um arquivo inexistente retorna nulo.

TC024 — Texto inválido: verifica a conversão de um texto não numérico para número.

TC025 — Item inexistente: verifica a busca de um item ausente em array e dicionário.

TC026 — Expressão regular inválida: verifica a compilação de um padrão de RegEx malformado.

---

## Testes ~~ Tales Henrique Moreira Carvalho

### Dados Válidos / Caminho Feliz

Cenários com entradas corretas e fluxos esperados de sucesso.

TC026 — Sobrescrita: modo WRITE trunca o conteúdo anterior.

TC027 — Append: acrescenta texto ao final do arquivo.

TC030 — Pastas recursivas: cria a árvore de pastas e salva dentro dela.

TC031 — Remoção: apaga um arquivo existente.

TC033 — Renomear: move o arquivo mantendo o conteúdo.

TC034 — Copiar: cria uma cópia idêntica sem alterar o original.

TC035 — JSON: salva um Dictionary e recarrega corretamente.

TC037 — store_var/get_var: preserva os tipos nativos do Godot.

TC038 — Binário: lê valores binários na ordem e tamanho gravados.

TC039 — ConfigFile: salva e carrega valores corretamente.

TC041 — Resource: salva e recarrega um Resource equivalente.

TC042 — Criptografia (cru): conteúdo não aparece em texto puro no disco.

TC043 — Criptografia (senha certa): recupera o conteúdo original.

### Dados Inválidos / Caminho Ruim

Cenários com entradas inválidas ou situações de erro.

TC029 — Pasta inexistente: escrita falha se a pasta não existe.

TC032 — Remoção inexistente: remover arquivo que não existe retorna erro.

TC036 — JSON corrompido: gera erro de parse.

TC040 — ConfigFile ausente: chave e arquivo inexistentes retornam valor padrão e erro.

TC044 — Criptografia (senha errada): abertura falha.

### Casos de Borda / Parametrizado

Mesmo teste rodando com múltiplos conjuntos de dados extremos.

TC028 — Textos variados: vazio, acentuado, multilinha e com emoji.

### Ponta a Ponta

Fluxo completo de uso, simulando um sistema real de save de jogo.

TC045 — Fluxo completo: salva, carrega, altera e recarrega um save.

TC046 — Save inexistente: retorna dicionário vazio.

TC047 — Save corrompido: retorna dicionário vazio.

TC048 — Formato errado: JSON válido mas fora do formato esperado retorna vazio.


### COMO GERAR RELATORIOS XML

Você precisa ter o Godot instalado, na steam tem ele por 2GB, de graça.

Roda o comando no CMD: & "Path do godot.exe" --headless -s res://addons/gut/gut_cmdln.gd

# Fontes

- Godot Engine — Vector2:
  https://docs.godotengine.org/en/stable/classes/class_vector2.html

- Godot Engine — GDScript:
  https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/

- GUT — Asserts and Methods:
  https://gut.readthedocs.io/en/godot_3x/Asserts-and-Methods.html
