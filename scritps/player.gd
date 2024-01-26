extends CharacterBody3D

const VELOCIDAD: float = 5.0
const GRAVEDAD: float = 9.8
const SENSIBILIDAD: float = 0.003

@onready var cabeza_jugador = $Cabeza
@onready var camara = $Cabeza/Camera3D
@onready var luz_linterna = $Cabeza/Camera3D/Linterna/Luz

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		cabeza_jugador.rotate_y(-event.relative.x * SENSIBILIDAD)
		camara.rotate_x(-event.relative.y * SENSIBILIDAD)
		camara.rotation.x = clamp(camara.rotation.x, deg_to_rad(-60), deg_to_rad(60))

func _physics_process(delta):
	gravedad(delta)
	movimiento()
	control_linterna()
	
func gravedad(delta):
	# Manejar la gravedad :)
	if not is_on_floor():
		velocity.y -= GRAVEDAD * delta
		
func movimiento():
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "back")
	var direction = (cabeza_jugador.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * VELOCIDAD
		velocity.z = direction.z * VELOCIDAD
	else:
		velocity.x = move_toward(velocity.x, 0, VELOCIDAD)
		velocity.z = move_toward(velocity.z, 0, VELOCIDAD)

	move_and_slide()
	
func control_linterna():
	if Input.is_action_just_pressed("linterna") :
		luz_linterna.visible = !luz_linterna.visible
