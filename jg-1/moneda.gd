extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	# Verificamos si el cuerpo que tocó la moneda tiene la función sumar_moneda
	if body.has_method("sumar_moneda"):
		body.sumar_moneda() # Suma +1 y actualiza el Label
		queue_free() # Hace desaparecer la moneda
