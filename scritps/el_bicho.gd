extends CharacterBody3D

const WALK_SPEED = 1.8
const RUN_SPEED = 3.0
const RANGO_ATAQUE = 2
const VELOCIDAD_ROTACION = 2

var markers = []
var current_marker_index = 0
var state_machine
var player = null
var player_detected: bool = false
var player_visto:bool = false
var lastPlayerPos
var timerCont=0
var numrand=0
var cont=0
var iaBool:bool=true
var gritoUsado:bool=false
var andar
var correr
var gritar
var atacar


@export var markers_group : String
@export var player_path : NodePath
@onready var nav_agent = $NavigationAgent3D
@onready var anim_tree = $AnimationTree
@onready var audio_grito = $Sonidos/Gritar
@onready var pasos = $Sonidos/Pasos
@onready var respirar = $Sonidos/Breath

func _ready():
	# Obtener todos los nodos en el grupo de marcadores
	markers = get_tree().get_nodes_in_group(markers_group)
	state_machine = anim_tree.get("parameters/playback")
	player = get_node(player_path)
	$Timer.start(3)
	lastPlayerPos = Vector3(player.global_transform.origin)


func _process(delta):
	andar = anim_tree.get("parameters/conditions/andar")
	correr = anim_tree.get("parameters/conditions/run")
	gritar = anim_tree.get("parameters/conditions/grito")
	atacar = anim_tree.get("parameters/conditions/atacar")
	velocity = Vector3.ZERO
	#print(lastPlayerPos)
	match state_machine.get_current_node():
		"Idle":
			#print("idle")
			interpolate_rotation(lastPlayerPos,delta)
		"Andar":
			#print("andar")
			if player_visto:
				move_to_lastPlayerPos(delta)
				if global_position.distance_to(lastPlayerPos) < 2:
					player_visto=false
					iaBool=true
			else :
				move_to_marker(delta)
		"Correr":
			#print("run")
			move_to_player()
		"Atacar":
			#print("atacar")
			# Mirar hacia la posición del jugador
			look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
	
	anim_tree.set("parameters/conditions/atacar", _target_in_range(RANGO_ATAQUE))
	
	set_idle()
	AI_MAIN(delta)
	
	move_and_slide()
	

func _on_timer_timeout():
	timerCont+=1
	numrand = randi_range(1,100)
	nav_agent.set_target_position(lastPlayerPos)
	var next_nav_point = nav_agent.get_next_path_position()
	print(next_nav_point)
	print(global_transform.origin)
	if _target_in_range(10):
		lastPlayerPos=Vector3(player.global_transform.origin)
	if !player_visto:
		iaBool = false

func AI_MAIN(delta):
	if player_detected:
		#print("detectado")
		interpolate_rotation(player.global_transform.origin, delta)
		if !gritar and !atacar:
			anim_tree.set("parameters/conditions/andar",false)
			anim_tree.set("parameters/conditions/run",true)
	else:
		#print("no detectado")
		if iaBool or numrand<=30 and !player_visto:
			anim_tree.set("parameters/conditions/andar",false)
			anim_tree.set("parameters/conditions/run",false)
		else:
			anim_tree.set("parameters/conditions/run",false)
			anim_tree.set("parameters/conditions/andar",true)

func grito():
	state_machine.travel("Gritar")
	audio_grito.pitch_scale=randf_range(0.9,1.0)
	audio_grito.play()

func set_idle():
	if !gritar and !andar and !correr and !atacar:
		anim_tree.set("parameters/conditions/idle", true)
	else:
		anim_tree.set("parameters/conditions/idle", false)

func interpolate_rotation(target_position, delta):#rota la direccion de forma fluida
	var target_rotation = (target_position - global_transform.origin).normalized()
	var new_transform = global_transform
	new_transform.basis = new_transform.basis.slerp(Basis().looking_at(target_rotation, Vector3.UP), VELOCIDAD_ROTACION * delta)
	new_transform.origin = global_transform.origin  # Preserve the current position
	global_transform = new_transform

func _target_in_range(rango):# Devuelve bool si está en rango
	return global_position.distance_to(player.global_position) < rango

func move_to_lastPlayerPos(delta):
		# Moverse hacia el marcador actual
	nav_agent.set_target_position(lastPlayerPos)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * WALK_SPEED
	interpolate_rotation(next_nav_point, delta)

func move_to_marker(delta):
	# Moverse hacia el marcador actual
	nav_agent.set_target_position(markers[current_marker_index].global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * WALK_SPEED
	# Mirar hacia la posición del marcador actual
	#look_at(Vector3(global_position.x + velocity.x, global_position.y, global_position.z + velocity.z), Vector3.UP)
	interpolate_rotation(next_nav_point, delta)
	if global_position.distance_to(markers[current_marker_index].global_transform.origin) < 1.0:
		# Cambiar al siguiente marcador
		current_marker_index = (current_marker_index + 1) % markers.size()

func move_to_player():
	#Movimiento del bicho, sigue al "target" que es el player
	nav_agent.set_target_position(player.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * RUN_SPEED
	look_at(Vector3(global_position.x + velocity.x, global_position.y, global_position.z + velocity.z), Vector3.UP)

func audio_pasos():
	pasos.pitch_scale=randf_range(0.6,0.8)
	pasos.play()

# Funciones del area de vision 
func on_enter(other: Node3D) -> void:
	if other == player:
		player_detected = true
		player_visto=true
		respirar.pitch_scale=randf_range(0.8,1.0)
		grito()
func on_exit(other: Node3D) -> void:
	if other == player:
		player_detected = false
		gritoUsado=false
		respirar.pitch_scale=randf_range(0.65,0.75)
		lastPlayerPos = Vector3(player.global_transform.origin)

# Funcion de entrar a las casas
func _on_casa_1_body_entered(other: Node3D) -> void:
	if other == player:
		player_detected = false
		player_visto=false
		grito()
		$AreaVision.monitoring = false


func _on_casa_1_body_exited(other: Node3D) -> void:
	if other == player:
		$AreaVision.set_monitoring(true)
