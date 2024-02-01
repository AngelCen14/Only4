extends Control

var boton_jugar: Button
var boton_salir : Button

func _ready():
	# Inicializar los botones y crear los eventos de pulsacion
	boton_jugar = $VBoxContainer/botonJugar
	boton_salir = $VBoxContainer/botonSalir
	boton_jugar.pressed.connect(self._boton_jugar_pressed)
	boton_salir.pressed.connect(self._boton_salir_pressed)

func _boton_jugar_pressed():
	get_tree().change_scene_to_file("res://escenas/main.tscn")

func _boton_salir_pressed():
	get_tree().quit()
