extends RayCast3D

@onready var label = $Label
@onready var player_llaves = $"../../.."


# Called when the node enters the scene tree for the first time.
func _ready():
	add_exception(owner)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_colliding():
		var str: String = get_collider().name
		if(get_collider().name.contains("key")):
			$Label.visible=true
			if Input.is_action_just_pressed("take"):
				player_llaves.llaves+=1
				var keyname= "../Terreno/"+get_collider().get_parent().get_parent().get_parent().get_parent().name
				player_llaves.get_llaves(keyname)
				print(get_collider().name)
		elif (get_collider().name=="Salida"):
			$Label.visible=true
			if Input.is_action_just_pressed("take"):
				if player_llaves.llaves>=4:
					print("winer winer chiken diner")
					Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
					get_tree().change_scene_to_file(GLOBAL.ESCENA_VICTORIA)
				else :
					print("te falta odio...")
		else :
			$Label.visible=false
	else :
		$Label.visible=false
