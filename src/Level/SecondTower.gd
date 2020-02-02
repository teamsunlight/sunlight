extends Spatial

class_name tower2

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var active = true

func _input(event):
	if event.is_action_pressed("interact") and active and GameMode.tower2:
		GameMode.tower_count += 1
		$PromptMessage2/Sprite3D.hide()
		$EffectSecondTower.show()
		$MeshInstance2.show()
		active = false
		#Active current instance effect	
		

# Called when the node enters the scene tree for the first time.
func _ready():
	#$Position3D/Label.hide()
	#$Towers/SecondTower/PromptMessage2/Sprite3D.hide()
	#$Towers/SecondTower/EffectSecondTower.hide()
	#$Towers/SecondTower/MeshInstance2.hide()
	pass

func _on_TowerBArea_body_entered(body):
		if body is SunlightCharacter and active:
			$PromptMessage2/Sprite3D.show()
			GameMode.tower2 = true
			
func _on_TowerBArea_body_exited(body):
		if body is SunlightCharacter:
			$PromptMessage2/Sprite3D.hide()
			GameMode.tower2 = false
