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
