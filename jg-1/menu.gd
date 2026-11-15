extends Control

@export_file("*.tscn") var escena_juego: String
@export var boton_jugar: Button
@export var boton_salir: Button

func _ready() -> void:
	if boton_jugar:
		boton_jugar.pressed.connect(_on_jugar_pressed)
	if boton_salir:
		boton_salir.pressed.connect(_on_salir_pressed)

func _on_jugar_pressed() -> void:
	if escena_juego:
		get_tree().change_scene_to_file(escena_juego)

func _on_salir_pressed() -> void:
	get_tree().quit()
