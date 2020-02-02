extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var isOnAltar = false

# Called when the node enters the scene tree for the first time.
func _ready():
	GameMode.level = self
	pass # Replace with function body.
	
func _input(event):
	if event.is_action_pressed("interact") and isOnAltar:
		#Finish game
		final_fx()

func final_fx():
	print("final fx")
	var end_duration: float = 5
	var pp: WorldEnvironment = $WorldEnvironment2
	var endenv: Environment = pp.environment
	var tween: Tween = $WorldEnvironment2/Tween
	old_exposure = endenv.tonemap_exposure
	old_white = endenv.tonemap_white
	tween.interpolate_method(self, "set_final_environment", 0, 1, end_duration, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()
	var char_camera: SunlightCamera = $SunlightCharacter/SpringArm
	char_camera.shake(end_duration, 0.05)

var old_exposure: float = 12
var old_white: float = 1
func set_final_environment(ratio):
	print(ratio)
	var pp: WorldEnvironment = $WorldEnvironment2
	var endenv: Environment = pp.environment
	endenv.tonemap_exposure = old_exposure + ratio * (12 - old_exposure)
	endenv.tonemap_white = old_white * (1 - ratio)
	pp.environment = endenv

func hide_darkness():
	print("hide darkness")
	var darkness: Node = $DARK_MESHES
	var tween : Tween = $DARK_MESHES/Tween
	var char_camera: SunlightCamera = $SunlightCharacter/SpringArm
	tween.interpolate_property(darkness,"translation", darkness.translation, darkness.translation + Vector3(0, -20, 0) , 5, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	tween.start()



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
		


func _on_AltarArea_body_entered(body):
	print("Entered...")
	if body is SunlightCharacter:
		print("Inside")
		isOnAltar = true


func _on_AltarArea_body_exited(body):
	print("Entered Exit...")
	if body is SunlightCharacter:
		print("Exited alter...")
		isOnAltar = false

