extends Control

const MAIN = "res://escenas/main.tscn"
const PANTALLA_CARGA = "res://escenas/UI/pantalla_carga.tscn"

@onready var boton_jugar: Button = $VBoxContainer/botonJugar
@onready var boton_salir : Button = $VBoxContainer/botonSalir

func _ready():
	# Inicializar los botones y crear los eventos de pulsacion
	boton_jugar.pressed.connect(self._boton_jugar_pressed)
	boton_salir.pressed.connect(self._boton_salir_pressed)

func _boton_jugar_pressed():
	GLOBAL.cambio_escena = MAIN
	get_tree().change_scene_to_file(PANTALLA_CARGA)

func _boton_salir_pressed():
	get_tree().quit()
