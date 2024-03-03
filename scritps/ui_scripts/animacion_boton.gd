class_name AnimacionBoton 
extends Button

const ESCALA = 2

@onready var original_scale = scale
var original_font_size

func _ready():
	connect("mouse_entered", on_mouse_enter)
	connect("mouse_exited", on_mouse_exit)
	original_font_size = get_theme_font_size("font_size")
	
func on_mouse_enter():
	scale *= ESCALA
	position -= (size * ESCALA / 4)
	add_theme_font_size_override("font_size", original_font_size*(ESCALA-0.5))
	
func on_mouse_exit():
	scale = original_scale
	position += (size * ESCALA /4)
	add_theme_font_size_override("font_size", original_font_size)

