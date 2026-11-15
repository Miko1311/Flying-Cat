extends CharacterBody2D

const VELOCIDAD = 250.0
const FUERZA_SALTO = -800.0
const GRAVEDAD = 980.0

@export var animacion: AnimatedSprite2D

var monedas: int = 0
var vidas: int = 3
var punto_inicio: Vector2
var invulnerable: bool = false

func _ready() -> void:
	punto_inicio = global_position # Guarda dónde empezaste para reaparecer si caes
	monedas = 0
	vidas = 3
	actualizar_texto()
	actualizar_corazones()

func sumar_moneda() -> void:
	monedas += 1
	actualizar_texto()

func actualizar_texto() -> void:
	var etiqueta = get_tree().get_first_node_in_group("contador_monedas")
	if etiqueta:
		etiqueta.text = "MONEDAS: " + str(monedas)

func actualizar_corazones() -> void:
	var contenedor = get_tree().get_first_node_in_group("contenedor_corazones")
	if contenedor:
		var lista_corazones = contenedor.get_children()
		for i in range(lista_corazones.size()):
			# Muestra el corazón si el índice es menor a las vidas actuales, si no lo oculta
			lista_corazones[i].visible = i < vidas

func recibir_dano() -> void:
	if invulnerable:
		return
		
	vidas -= 1
	actualizar_corazones()
	
	if vidas <= 0:
		get_tree().reload_current_scene() # Si te quedas sin corazones, reinicia todo
	else:
		# Tiempo breve de invulnerabilidad y parpadeo para que el boss no te quite los 3 de golpe
		invulnerable = true
		if animacion:
			animacion.modulate.a = 0.5
		await get_tree().create_timer(1.2).timeout
		if animacion:
			animacion.modulate.a = 1.0
		invulnerable = false

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += GRAVEDAD * delta

	if Input.is_key_pressed(KEY_W) and is_on_floor():
		velocity.y = FUERZA_SALTO

	var direccion = 0.0
	if Input.is_key_pressed(KEY_A):
		direccion -= 1.0
	if Input.is_key_pressed(KEY_D):
		direccion += 1.0

	velocity.x = direccion * VELOCIDAD
	move_and_slide()

	# --- ANIMACIONES ---
	if animacion:
		if direccion < 0:
			animacion.flip_h = true
		elif direccion > 0:
			animacion.flip_h = false

		if not is_on_floor():
			if animacion.sprite_frames.has_animation("Salto"):
				animacion.play("Salto")
		elif direccion != 0:
			animacion.play("Movimiento")
		else:
			animacion.play("Quieto")

	# --- SI CAE AL VACÍO: QUITA 1 CORAZÓN Y REAPARECE ARRIBA ---
	if position.y > 1000:
		global_position = punto_inicio
		velocity = Vector2.ZERO
		recibir_dano()
