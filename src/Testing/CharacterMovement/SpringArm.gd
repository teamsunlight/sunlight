extends SpringArm

var target_rot: Vector3 setget set_target_rot
var shaking: bool = false

func _input(event):
	if event is InputEventKey and event.pressed and event.scancode == KEY_E:
		shake(0.2, 0.01)

func shake(duration, intensity):
	# translation = Vector3(25555, 25, 5)
	shaking = true
	var time = 0.0
	while time <= duration:
		var random_rot = Vector3(
			rand_range(-1, 1), rand_range(-1, 1), rand_range(-1, 1)
		)
		rotation = target_rot + random_rot * intensity
		yield(get_tree(), "idle_frame")
		time += 0.02 # TODO: Get delta time
	rotation = target_rot
	shaking = false

func set_target_rot(rot: Vector3):
	# Use this function instead of rotation property
	target_rot = rot
	if not shaking:
		rotation = target_rot
