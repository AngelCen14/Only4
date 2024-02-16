extends CharacterBody3D

const VELOCIDAD = 5.0
const GRAVEDAD = 9.8
const SENSIBILIDAD = 0.003

# Agitamiento camara 
const FRECUENCIA_AGITAMENTO = 2.0
const AMPLITUD_AGITAMIENTO = 0.08
var tiempo_agitamiento  = 0.0

@export var llaves = 0;

@onready var cabeza_jugador = $Cabeza
@onready var camara = $Cabeza/Camera3D
@onready var luz_linterna = $Cabeza/Camera3D/Linterna/Luz


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	gravedad(delta)
	control_linterna()
	movimiento(delta)
	press_esc(delta)


func _unhandled_input(event):
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			cabeza_jugador.rotate_y(-event.relative.x * SENSIBILIDAD)
			camara.rotate_x(-event.relative.y * SENSIBILIDAD)
			camara.rotation.x = clamp(camara.rotation.x, deg_to_rad(-60), deg_to_rad(60))


func press_esc(delta):
	# Verificamos si se ha pulsado la tecla Esc
	if Input.is_action_just_pressed("esc"):
		# Cambiamos el modo del ratón entre capturado y liberado
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func gravedad(delta):
	# Manejar la gravedad :)
	if not is_on_floor():
		velocity.y -= GRAVEDAD * delta


func movimiento(delta):
	# MOVIMIENTO DEL PERSONAJE
	var input_dir = Input.get_vector("left", "right", "up", "back")
	var direction = (cabeza_jugador.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * VELOCIDAD
		velocity.z = direction.z * VELOCIDAD
	else:
		velocity.x = move_toward(velocity.x, 0, VELOCIDAD)
		velocity.z = move_toward(velocity.z, 0, VELOCIDAD)
	
	move_and_slide()
	
	# AGITAMIENTO DE LA CAMARA PARA SIMULAR LOS PASOS DEL PERSONAJE
	tiempo_agitamiento += delta * velocity.length()
	camara.transform.origin = agitamiento_camara(tiempo_agitamiento)


func agitamiento_camara(tiempo) -> Vector3:
	var posicion = Vector3.ZERO
	posicion.y = sin(tiempo * FRECUENCIA_AGITAMENTO) * AMPLITUD_AGITAMIENTO
	posicion.x = cos(tiempo * FRECUENCIA_AGITAMENTO / 2) * AMPLITUD_AGITAMIENTO
	return posicion


func control_linterna():
	if Input.is_action_just_pressed("linterna") :
		luz_linterna.visible = !luz_linterna.visible

func get_llaves(keyname):
	if keyname != null:
		print(keyname)
		var str: NodePath=keyname
		get_node(keyname).visible=false
		get_node(keyname).set_process_mode(4)
