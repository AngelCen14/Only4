class_name MenuAjustes
extends Control

@onready var boton_salir: Button = $MarginContainer/VBoxContainer/botonSalir

signal salir_menu_opciones

func _ready():
	boton_salir.pressed.connect(boton_salir_pressed)
	
func boton_salir_pressed():
	salir_menu_opciones.emit()
	
