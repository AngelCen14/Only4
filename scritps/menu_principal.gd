class_name MenuPrincipal
extends Control

@onready var contenedor_principal: VBoxContainer = $ContenedorPrincipal

# Botones
@onready var boton_jugar: Button = $ContenedorPrincipal/ContenedorBotones/botonJugar
@onready var boton_ajustes: Button = $ContenedorPrincipal/ContenedorBotones/botonAjustes
@onready var boton_salir : Button = $ContenedorPrincipal/ContenedorBotones/botonSalir

# Menu de ajustes
@onready var menu_ajustes: MenuAjustes = $MenuAjustes

func _ready():
	conectar_signals()
	boton_jugar.grab_focus() 

func conectar_signals():
	boton_jugar.pressed.connect(on_boton_jugar_pressed)
	boton_ajustes.pressed.connect(on_boton_ajustes_pressed)
	boton_salir.pressed.connect(on_boton_salir_pressed)
	menu_ajustes.salir_menu_opciones.connect(on_salir_menu_opciones)

# --- EVENTOS BOTONES ---
func on_boton_jugar_pressed():
	print("CARGAR JUEGO")
	GLOBAL.cargar_escena = GLOBAL.MAIN
	get_tree().change_scene_to_file(GLOBAL.ESCENA_PANTALLA_CARGA)

func on_boton_ajustes_pressed():
	print("CARGAR MENU OPCIONES")
	contenedor_principal.visible = false
	menu_ajustes.visible = true

func on_boton_salir_pressed():
	print("SALIR DEL JUEGO")
	get_tree().quit()

# --- EVENTOS MENU DE AJUSTES ---
func on_salir_menu_opciones():
	contenedor_principal.visible = true
	menu_ajustes.visible = false
