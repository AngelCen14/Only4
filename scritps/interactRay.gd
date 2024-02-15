extends RayCast3D

@onready var label = $Label
# Called when the node enters the scene tree for the first time.
func _ready():
	add_exception(owner)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_colliding():
		if get_collider_rid().get_id() == 24597277704615:
			label.visible=true
			print("jjjjjjjjjjjjjjjjjjjjjj")
		else :
			label.visible=false
