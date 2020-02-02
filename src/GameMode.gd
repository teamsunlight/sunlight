extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var tower_count = 0 setget set_tower_count

func set_tower_count(new_tower_count):
	print("Tower count reached %d" % new_tower_count)
	tower_count = new_tower_count
	if tower_count >= 2:
		level.hide_darkness()

var towerB = false
var towerA = false
var level: Node = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
