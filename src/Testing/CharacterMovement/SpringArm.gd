extends SpringArm

var target_rot: Vector3 setget set_target_rot
var shaking: bool = false

func _input(event):
	if event is InputEventKey and event.pressed and event.scancode == KEY_E:
		shake(0.5, 0.02)

func shake(duration, intensity):
	shaking = true
	var time = 0.0
	while time <= duration:
		var random_rot = Vector3(
			rand_range(-1, 1), rand_range(-1, 1), rand_range(-1, 1)
		)
		rotation = target_rot + random_rot * intensity
		yield(get_tree(), "idle_frame")
		time += get_process_delta_time()
	rotation = target_rot
	shaking = false

func set_target_rot(rot: Vector3):
	# Use this function instead of rotation property
	target_rot = rot
	if not shaking:
		rotation = target_rot