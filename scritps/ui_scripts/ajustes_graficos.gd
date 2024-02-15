class_name AjustesGraficos
extends Control

@onready var option_button_modos_ventana: OptionButton = $MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer/OptionButtonModosVentana
@onready var option_button_resoluciones: OptionButton = $MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer2/OptionButtonModosVentana

const WINDOW_MODE_ARRAY: Array[String] = [
	"Pantalla completa",
	"Modo Ventana",
	"Ventana sin bordes",
	"Pantalla completa sin bordes"
]

const DICCIONARIO_RESOLUCIONES: Dictionary = {
	"640 x 480" : Vector2(640, 480),
	"800 x 600" : Vector2(800, 600),
	"1024 x 768" : Vector2(1024, 768),
	"1152 x 648" : Vector2(1152, 648),
	"1280 x 720" : Vector2(1280, 720),
	"1366 x 768" : Vector2(1366, 768),
	"1600 x 900" : Vector2(1600, 900),
	"1920 x 1080" : Vector2(1920, 1080),
	"2560 x 1440" : Vector2(2560, 1440),
	"3840 x 2160" : Vector2(3840, 2160)
}

func _ready():
	cargar_modos_ventana()
	cargar_resoluciones()
	option_button_modos_ventana.item_selected.connect(on_seleccionar_modo_ventana)
	option_button_resoluciones.item_selected.connect(on_seleccionar_resolucion)

func cargar_modos_ventana():
	for modo_ventana in WINDOW_MODE_ARRAY:
		option_button_modos_ventana.add_item(modo_ventana)

func cargar_resoluciones():
	for resolucion in DICCIONARIO_RESOLUCIONES:
		option_button_resoluciones.add_item(resolucion)

func on_seleccionar_modo_ventana(index: int):
	match index:
		0: # Pantalla completa
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1: # Modo ventana
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2: # Ventana sin bordes
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		3: # Pantalla completa sin bordes
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)

func on_seleccionar_resolucion(index: int):
	DisplayServer.window_set_size(DICCIONARIO_RESOLUCIONES.values()[index])
