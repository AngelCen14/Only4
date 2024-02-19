class_name MenuPausa
extends Control

@onready var menu_ajustes = $MenuAjustes
@onready var panel_container = $PanelContainer

func _ready():
	menu_ajustes.salir_menu_opciones.connect(on_salir_menu_opciones)
	
func _process(delta):
	if Input.is_action_just_pressed("esc") and !get_tree().paused:
		pausar()
	elif Input.is_action_just_pressed("esc") and get_tree().paused:
		reanudar()
		
func reanudar():
	get_tree().paused = false
	self.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func pausar():
	get_tree().paused = true
	self.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_boton_reanudar_pressed():
	reanudar()

func _on_boton_ajustes_pressed():
	panel_container.visible = false
	menu_ajustes.visible = true

func _on_boton_salir_pressed():
	reanudar()
	GLOBAL.cargar_escena = GLOBAL.ESCENA_MENU_PRINCIPAL
	get_tree().change_scene_to_file(GLOBAL.ESCENA_PANTALLA_CARGA)
	
func on_salir_menu_opciones():
	panel_container.visible = true
	menu_ajustes.visible = false
