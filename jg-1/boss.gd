extends CharacterBody2D

@export var velocidad: float = 150.0
@export var vida_maxima: int = 5
@export var impulso_rebote_jugador: float = -750.0

@export var zona_debil: Area2D
@export var zona_ataque: Area2D
@export var sprite: Sprite2D

const GRAVEDAD = 980.0
var direccion: float = -1.0
var vida_actual: int

func _ready() -> void:
	vida_actual = vida_maxima
	actualizar_barra()
	
	if zona_debil:
		zona_debil.body_entered.connect(_on_cabeza_pisada)
	if zona_ataque:
		zona_ataque.body_entered.connect(_on_jugador_golpeado)

func actualizar_barra() -> void:
	var barra = get_tree().get_first_node_in_group("barra_boss")
	if barra:
		barra.max_value = vida_maxima
		barra.value = vida_actual

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVEDAD * delta

	if is_on_wall():
		direccion *= -1.0

	velocity.x = direccion * velocidad

	if sprite:
		sprite.flip_h = direccion > 0

	move_and_slide()

func _on_cabeza_pisada(body: Node2D) -> void:
	if body is CharacterBody2D and body != self and body.velocity.y > 0:
		body.velocity.y = impulso_rebote_jugador
		recibir_dano()

func _on_jugador_golpeado(body: Node2D) -> void:
	# Llama a recibir_dano() del jugador en lugar de reiniciar de inmediato
	if body != self and body.has_method("recibir_dano"):
		body.recibir_dano()
		# Empuja un poco al jugador hacia atrás al golpearlo
		body.velocity.y = -400.0
		body.velocity.x = direccion * 400.0

func recibir_dano() -> void:
	vida_actual -= 1
	actualizar_barra()
	
	if sprite:
		sprite.modulate = Color.RED
		await get_tree().create_timer(0.15).timeout
		sprite.modulate = Color.WHITE

	if vida_actual <= 0:
		# Oculta la barra al morir el boss
		var barra = get_tree().get_first_node_in_group("barra_boss")
		if barra:
			barra.visible = false
		queue_free()
