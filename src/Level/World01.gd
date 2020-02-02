extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _update():
	if GameMode.tower_count >= 2:
		$DARK_MESHES.destroy()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
