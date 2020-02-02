extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var active = true

func _input(event):
	if event.is_action_pressed("interact") and active and !GameMode.towerB:
		GameMode.tower_count += 1
		$Sprite3D.hide()
		$Effect.show()
		$towerTop_GLOW001.show()
		active = false
		#Active current instance effect	
		

# Called when the node enters the scene tree for the first time.
func _ready():
	#$Position3D/Label.hide()
	$Sprite3D.hide()
	$Effect.hide()
	$towerTop_GLOW001.hide()

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area_body_entered(body):
	if body is MainCharacter and active:
		#$Position3D/Label.show()
		$Sprite3D.show()
		GameMode.towerB = true


func _on_Area_body_exited(body):
	if body is MainCharacter:
		#$Position3D/Label.hide()
		$Sprite3D.hide()
		GameMode.towerB = false

