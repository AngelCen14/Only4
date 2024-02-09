extends CharacterBody3D

const WALK_SPEED = 1.8
const RUN_SPEED = 3.6
const RANGO_ATAQUE = 2
const VELOCIDAD_ROTACION = 2

var markers = []
var current_marker_index = 0
var state_machine
var player = null
var player_detected: bool = false
var timerCont=0
var numrand=0
var cont=0
var iaBool:bool=true
var gritoUsado:bool=false


@export var markers_group : String
@export var player_path : NodePath
@onready var nav_agent = $NavigationAgent3D
@onready var anim_tree = $AnimationTree

func _ready():
	# Obtener todos los nodos en el grupo de marcadores
	markers = get_tree().get_nodes_in_group(markers_group)
	state_machine = anim_tree.get("parameters/playback")
	player = get_node(player_path)
	$Timer.start(3)


func _process(delta):
	velocity = Vector3.ZERO
	match state_machine.get_current_node():
		"Idle":
			if player_detected:
				var tar = Vector3(player.global_position.x, global_position.y, player.global_position.z)
				interpolate_rotation(tar,delta)
			else :
				buscar()
			#print("idle")
		"Andar":
			move_to_marker(delta)
		"Run":
			pass
		"Atacar":
			#print("atacar")
			# Mirar hacia la posición del jugador
			look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
			
	anim_tree.set("parameters/conditions/atacar", _target_in_range(RANGO_ATAQUE))	
	
	AI_MAIN(delta)
	
	move_and_slide()
	

func _on_timer_timeout():
	#timerCont+=1
	numrand = randi_range(1,3)
	#print(numrand)
	#iaBool = !iaBool
	
func AI_MAIN(delta):
	if timerCont<5:
		if player_detected:
			print("detectado")
			anim_tree.set("parameters/conditions/idle", true)
			anim_tree.set("parameters/conditions/andar", false)
			#grito()
			
		else:
			anim_tree.set("parameters/conditions/idle", false)
			anim_tree.set("parameters/conditions/andar", true)
			move_to_marker(delta)

func grito():
	if !gritoUsado:
		state_machine.travel("parameters/conditions/grito",true)
		gritoUsado=true

func gritar():
	#print(iaBool)
	anim_tree.set("parameters/conditions/idle", true)
	anim_tree.set("parameters/conditions/andar", false)
	if iaBool:
		anim_tree.set("parameters/conditions/grito", true)
	else :
		anim_tree.set("parameters/conditions/grito", false)
	await get_tree().create_timer(2.0).timeout
	iaBool=false


func buscar():# Posicion random
	return Vector3(randi_range(-5,5), global_position.y, randi_range(-5,5))

func interpolate_rotation(target_position, delta):#rota la direccion de forma fluida
	var target_rotation = (target_position - global_transform.origin).normalized()
	var new_transform = global_transform
	new_transform.basis = new_transform.basis.slerp(Basis().looking_at(target_rotation, Vector3.UP), VELOCIDAD_ROTACION * delta)
	new_transform.origin = global_transform.origin  # Preserve the current position
	global_transform = new_transform

func _target_in_range(rango):# Devuelve bool si está en rango
	return global_position.distance_to(player.global_position) < rango

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

func move_to_player(speed):
	#Movimiento del bicho, sigue al "target" que es el player
	nav_agent.set_target_position(player.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * speed
	look_at(Vector3(global_position.x + velocity.x, global_position.y, global_position.z + velocity.z), Vector3.UP)

# Funciones del area de vision 
func on_enter(other: Node3D) -> void:
	if other == player:
		player_detected = true
func on_exit(other: Node3D) -> void:
	if other == player:
		player_detected = false

# Funcion de entrar a las casas
func _on_casa_1_body_entered(other: Node3D) -> void:
	if other == player:
		player_detected = false
