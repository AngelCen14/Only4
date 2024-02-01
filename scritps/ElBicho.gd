extends CharacterBody3D

const SPEED = 1.8
const RANGO_ATAQUE = 2

var markers = []
var current_marker_index = 0
var state_machine
var player = null

@export var markers_group : String
@export var player_path : NodePath
@onready var nav_agent = $NavigationAgent3D
@onready var anim_tree = $AnimationTree

func _ready():
	# Obtener todos los nodos en el grupo de marcadores
	markers = get_tree().get_nodes_in_group(markers_group)
	state_machine = anim_tree.get("parameters/playback")
	player = get_node(player_path)

func _process(delta):
	velocity = Vector3.ZERO

	match state_machine.get_current_node():
		"Andar":
			# Moverse hacia el marcador actual
			nav_agent.set_target_position(markers[current_marker_index].global_transform.origin)
			var next_nav_point = nav_agent.get_next_path_position()
			velocity = (next_nav_point - global_transform.origin).normalized() * SPEED

			# Mirar hacia la posición del marcador actual
			look_at(Vector3(global_position.x + velocity.x, global_position.y, global_position.z + velocity.z), Vector3.UP)

			# Verificar si ha llegado al marcador actual
			if global_position.distance_to(markers[current_marker_index].global_transform.origin) < 1.0:
				# Cambiar al siguiente marcador
				current_marker_index = (current_marker_index + 1) % markers.size()
				
			#Movimiento del bicho, sigue al "target" que es el player
			#nav_agent.set_target_position(player.global_transform.origin)
			#var next_nav_point = nav_agent.get_next_path_position()
			#velocity = (next_nav_point - global_transform.origin).normalized() * SPEED

		"Atacar":
			# Mirar hacia la posición del jugador
			look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)

	# Condiciones
	anim_tree.set("parameters/conditions/atacar", _target_in_range())
	anim_tree.set("parameters/conditions/andar", !_target_in_range())

	move_and_slide()

func _target_in_range():
	return global_position.distance_to(player.global_position) < RANGO_ATAQUE
