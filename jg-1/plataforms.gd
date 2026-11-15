extends Area2D

@export var fuerza_rebote: float = -1100.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		body.velocity.y = fuerza_rebote
