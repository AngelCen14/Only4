extends RayCast3D

@onready var label = $Label
@onready var player_llaves = $"../../.."
# Called when the node enters the scene tree for the first time.
func _ready():
	add_exception(owner)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_colliding():
		if(get_collider().name=="Key" || get_collider().name=="Salida"):
			$Label.visible=true
			if Input.is_action_just_pressed("take"):
				player_llaves.llaves+=1
				get_node("../Terreno/key").visible=false
				print($"../../..".llaves)
		else :
			$Label.visible=false
		
	else :
		$Label.visible=false
