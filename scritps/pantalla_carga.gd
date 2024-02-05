extends Control

@onready var progreso: Array
@onready var estado_carga_escena: int

@onready var timer = $Timer
@onready var label_cargando = $LabelCargando

var contador: int = 0

func _ready():
	ResourceLoader.load_threaded_request(GLOBAL.cambio_escena)
	iniciar_timer(timer, 0.3)
	
func _process(delta):
	estado_carga_escena = ResourceLoader.load_threaded_get_status(GLOBAL.cambio_escena, progreso)
	
	if estado_carga_escena == ResourceLoader.THREAD_LOAD_LOADED:
		get_tree().call_deferred("change_scene_to_packed", ResourceLoader.load_threaded_get(GLOBAL.cambio_escena))
	
func iniciar_timer(timer: Timer, tiempo: float):
	timer.wait_time = tiempo
	timer.start()
	timer.connect("timeout", modificar_label_cargando)

func modificar_label_cargando(): 
	if contador < 3:
		label_cargando.text += "."
		contador+=1
	else:
		label_cargando.text = "CARGANDO"
		contador = 0
