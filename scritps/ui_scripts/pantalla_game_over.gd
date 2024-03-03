class_name PantallaGameOver
extends Control

func on_click_boton_salir_menu():
	GLOBAL.cargar_escena = GLOBAL.ESCENA_MENU_PRINCIPAL
	get_tree().change_scene_to_file(GLOBAL.ESCENA_PANTALLA_CARGA)
