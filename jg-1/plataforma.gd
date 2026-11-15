extends Area2D

# Al usar @export, podrás cambiar la fuerza de cada plataforma individualmente desde el Inspector
@export var fuerza_rebote: float = -1100.0

func _ready() -> void:
	# Conecta la señal automáticamente por código para no hacerlo manual
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	# Si el objeto que tocó el área es el jugador (CharacterBody2D), lo impulsa
	if body is CharacterBody2D:
		body.velocity.y = fuerza_rebote
