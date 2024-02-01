extends Node3D

@export var group_name : String

var positions : Array
var temp_positions : Array
var current_position : Marker3D

var direction : Vector3 = Vector3.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	positions = get_tree().get_nodes_in_group(group_name)
	_get_positions()
	_get_next_position()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if global_position.distance_to(current_position.position) < 10:
		_get_next_position()


func _get_positions():
	temp_positions = positions.duplicate()
	temp_positions.shuffle()
	print("get positions")

func _get_next_position():
	if temp_positions.is_empty():
		print("position empty")
		_get_positions()
	print("position not empty")
	current_position = temp_positions.pop_front()
	#direction = (current_position.position - global_position).normalized()
	direction = to_local(current_position.position).normalized()
