extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	GameMode.level = self
	pass # Replace with function body.
	
func hide_darkness():
	print("hide darkness")
	var darkness: Node = $DARK_MESHES
	var tween : Tween = $DARK_MESHES/Tween
	var char_camera: SunlightCamera = $SunlightCharacter/SpringArm
	tween.interpolate_property(darkness,"translation", darkness.translation, darkness.translation + Vector3(0, -20, 0) , 5, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	tween.start()
	char_camera.shake(5, 0.01)



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TeleportAreaA_body_entered(body):
	var tween : Tween = $SunlightCharacter/Tween
	if body is SunlightCharacter:
		var position : Spatial = $TowerATeleport
		var character: Spatial = $SunlightCharacter
		tween.interpolate_property(character,"translation", character.translation, position.translation, 0.4, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
		tween.start()


func _on_Area_body_entered(body):
	var tween : Tween = $SunlightCharacter/Tween
	if body is SunlightCharacter:
		var position : Spatial = $TowerBTeleport
		var character: Spatial = $SunlightCharacter
		tween.interpolate_property(character,"translation", character.translation, position.translation, 0.4, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
		tween.start()
