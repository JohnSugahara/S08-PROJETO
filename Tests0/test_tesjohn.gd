extends GutTest

const VECTOR_FIXTURES = {
	"TC001": {"input": Vector2(10, 0), "expected_norm": Vector2(1, 0)},
	"TC002": {"input": Vector2(3, 4), "expected_x": 0.6, "expected_y": 0.8},
	"TC003": {"input": Vector2(3, 4), "expected_len": 5.0},
	"TC004": {"a": Vector2(0, 0), "b": Vector2(3, 4), "expected_dist": 5.0},
	"TC005": {"a": Vector2(10, 5), "b": Vector2(2, 3), "expected_sum": Vector2(12, 8)},
	"TC006": {"a": Vector2(10, 5), "b": Vector2(2, 3), "expected_sub": Vector2(8, 2)},
	"TC007": {"input": Vector2.ZERO, "expected_norm": Vector2.ZERO},
	"TC008": {"input": Vector2(10, 20), "expected_dist": 0.0},
	"TC009": {"input": Vector2(10, 20), "expected_sum": Vector2(10, 20)},
	"TC010": {"input": Vector2(10, 20), "expected_sub": Vector2.ZERO},
	"TC011": {"input": Vector2(10, 20), "expected_mult": Vector2.ZERO},
	"TC012": {"input": Vector2(-10, -20), "expected_x": -10.0, "expected_y": -20.0},
	"TC013": {"a": Vector2(1, 0), "b": Vector2(-1, 0), "expected_dot": -1.0},
	"TC014": {"a": Vector2(1, 0), "b": Vector2(0, 1), "expected_dot": 0.0},
	"TC015": {"input": Vector2(1, 0), "expected_rot_x": 1.0, "expected_rot_y": 0.0},
	"TC016": {"input": Vector2(0.000001, 0.000001)}
}

# --- CASOS DE TESTE ---

# TC-001: Normalização de um vetor simples
func test_TC001_vector2_normalization():
	var data = VECTOR_FIXTURES["TC001"]
	var normalized = data["input"].normalized()
	
	assert_eq(normalized, data["expected_norm"])
	assert_almost_eq(normalized.length(), 1.0, 0.0001)

# TC-002: Normalização de um vetor diagonal
func test_TC002_vector2_diagonal_normalization():
	var data = VECTOR_FIXTURES["TC002"]
	var normalized = data["input"].normalized()
	
	assert_almost_eq(normalized.x, data["expected_x"], 0.0001)
	assert_almost_eq(normalized.y, data["expected_y"], 0.0001)
	assert_almost_eq(normalized.length(), 1.0, 0.0001)

# TC-003: Comprimento de um vetor
func test_TC003_vector2_length():
	var data = VECTOR_FIXTURES["TC003"]
	assert_eq(data["input"].length(), data["expected_len"])

# TC-004: Distancia entre dois pontos
func test_TC004_vector2_distance():
	var data = VECTOR_FIXTURES["TC004"]
	assert_eq(data["a"].distance_to(data["b"]), data["expected_dist"])

# TC-005: Soma de vetores
func test_TC005_vector2_addition():
	var data = VECTOR_FIXTURES["TC005"]
	assert_eq(data["a"] + data["b"], data["expected_sum"])

# TC-006: Subtração de vetores
func test_TC006_vector2_subtraction():
	var data = VECTOR_FIXTURES["TC006"]
	assert_eq(data["a"] - data["b"], data["expected_sub"])

# TC-007: Normalização do vetor zero
func test_TC007_vector2_zero_normalization():
	var data = VECTOR_FIXTURES["TC007"]
	var normalized = data["input"].normalized()
	
	assert_eq(normalized, data["expected_norm"])
	assert_false(is_nan(normalized.x))
	assert_false(is_nan(normalized.y))

# TC-008: Distância entre o mesmo ponto
func test_TC008_vector2_same_position_distance():
	var data = VECTOR_FIXTURES["TC008"]
	assert_eq(data["input"].distance_to(data["input"]), data["expected_dist"])

# TC-009: Soma com vetor zero
func test_TC009_vector2_add_zero():
	var data = VECTOR_FIXTURES["TC009"]
	assert_eq(data["input"] + Vector2.ZERO, data["expected_sum"])

# TC-010: Subtração do vetor por ele mesmo
func test_TC010_vector2_subtract_itself():
	var data = VECTOR_FIXTURES["TC010"]
	assert_eq(data["input"] - data["input"], data["expected_sub"])

# TC-011: Multiplicação por zero
func test_TC011_vector2_multiply_by_zero():
	var data = VECTOR_FIXTURES["TC011"]
	assert_eq(data["input"] * 0, data["expected_mult"])

# TC-012: Vetor com componentes negativas
func test_TC012_vector2_negative_values():
	var data = VECTOR_FIXTURES["TC012"]
	assert_eq(data["input"].x, data["expected_x"])
	assert_eq(data["input"].y, data["expected_y"])
	assert_almost_eq(data["input"].length(), sqrt(500.0), 0.0001)

# TC-013: Vetores em direções opostas
func test_TC013_vector2_opposite_vectors():
	var data = VECTOR_FIXTURES["TC013"]
	assert_eq(data["a"].dot(data["b"]), data["expected_dot"])

# TC-014: Vetores perpendiculares
func test_TC014_vector2_perpendicular_vectors():
	var data = VECTOR_FIXTURES["TC014"]
	assert_eq(data["a"].dot(data["b"]), data["expected_dot"])

# TC-015: Rotação completa de 360 graus
func test_TC015_vector2_full_rotation():
	var data = VECTOR_FIXTURES["TC015"]
	var rotated = data["input"].rotated(2 * PI)
	
	assert_almost_eq(rotated.x, data["expected_rot_x"], 0.0001)
	assert_almost_eq(rotated.y, data["expected_rot_y"], 0.0001)

# TC-016: Vetor com valores extremamente pequenos
func test_TC016_vector2_very_small_values():
	var data = VECTOR_FIXTURES["TC016"]
	var normalized = data["input"].normalized()
	
	assert_false(is_nan(normalized.x))
	assert_false(is_nan(normalized.y))
	assert_almost_eq(normalized.length(), 1.0, 0.0001)
