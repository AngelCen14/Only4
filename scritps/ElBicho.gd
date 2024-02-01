extends CharacterBody3D


const SPEED = 1.8
const RANGO_ATAQUE = 2

var player = null
var marker = null
var state_machine



@export var player_plath : NodePath
@export var player_plath2 : NodePath
@export var wander_direction : Node3D

@onready var nav_agent = $NavigationAgent3D
@onready var anim_tree = $AnimationTree

func _ready():
	player = get_node(player_plath)
	marker = get_node(player_plath2)
	state_machine = anim_tree.get("parameters/playback")


func _process(delta):
	velocity = Vector3.ZERO
	var direction = Vector3()
	
	match state_machine.get_current_node():
		"Andar":
			#Movimiento del bicho, sigue al "target" que es el player
			#nav_agenset_t.target_position(player.global_transform.origin)
			#var next_nav_point = nav_agent.get_next_path_position()
			#velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
			
			#Movimiento al marker
			#nav_agent.set_target_position(marker.global_transform.origin)
			#var next_nav_point = nav_agent.get_next_path_position()
			#velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
			
			nav_agent.set_target_position(wander_direction.direction*200)
			var next_nav_point = nav_agent.get_next_path_position()
			velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
			
			
			#velocity = wander_direction.direction * 200
			
			#Mirar a la posicion que se mueve
			look_at(Vector3(global_position.x + velocity.x, global_position.y, global_position.z + velocity.z), Vector3.UP)
		"Atacar":
			#Mirar a la posicion que se mueve
			look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
	
	
	#Condiciones
	anim_tree.set("parameters/conditions/atacar", _target_in_range())
	anim_tree.set("parameters/conditions/andar", !_target_in_range())


	move_and_slide()


func _target_in_range():
	return global_position.distance_to(player.global_position) < RANGO_ATAQUE
