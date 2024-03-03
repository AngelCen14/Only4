class_name AjustesSonido
extends Control

@onready var volumen_label: Label = $HboxContainer/Volumen
@onready var num_volumen_label: Label = $HboxContainer/NumVolumen
@onready var h_slider: HSlider = $HboxContainer/HSlider

@export_enum("Master", "Musica", "Efectos") var nombre_bus: String

var indice_bus: int = 0

func _ready():
	h_slider.value_changed.connect(on_volumen_changed)
	get_nombre_bus_por_indice()
	set_label_volumen()
	set_valor_slider()

func set_label_volumen():
	volumen_label.text = "Volumen " + str(nombre_bus)

func set_label_num_volumen():
	num_volumen_label.text = str(h_slider.value * 100)
	
func get_nombre_bus_por_indice():
	indice_bus = AudioServer.get_bus_index(nombre_bus)

func set_valor_slider():
	h_slider.value = db_to_linear(AudioServer.get_bus_volume_db(indice_bus))
	set_label_num_volumen()

func on_volumen_changed(value: float):
	AudioServer.set_bus_volume_db(indice_bus, linear_to_db(value))
	set_label_num_volumen()
