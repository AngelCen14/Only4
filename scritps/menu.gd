extends Control

@onready var boton_jugar: Button = $VBoxContainer/botonJugar
@onready var boton_salir : Button = $VBoxContainer/botonSalir

func _ready():
	# Inicializar los botones y crear los eventos de pulsacion
	boton_jugar.pressed.connect(self._boton_jugar_pressed)
	boton_salir.pressed.connect(self._boton_salir_pressed)

func _boton_jugar_pressed():
	get_tree().change_scene_to_file("res://escenas/main.tscn")

func _boton_salir_pressed():
	get_tree().quit()
