extends SpringArm

class_name SunlightCamera

var target_rot: Vector3 setget set_target_rot
var shaking: bool = false

func _input(event):
	if event is InputEventKey and event.pressed and event.scancode == KEY_F:
		shake(1, 0.02)

func shake(duration, intensity):
	shaking = true
	var time = 0.0
	var random_rot: Vector3 = Vector3()
	while time <= duration:
		randomize()
		random_rot.x = rand_range(-1, 1)
		randomize()
		random_rot.y = rand_range(-1, 1)
		randomize()
		random_rot.z = rand_range(-1, 1)
		rotation = target_rot + random_rot * intensity
		print("Shaking %f" % time)
		print("random rot", random_rot)
		yield(get_tree(), "idle_frame")
		time += get_process_delta_time()
	rotation = target_rot
	shaking = false

func set_target_rot(rot: Vector3):
	# Use this function instead of rotation property
	target_rot = rot
	if not shaking:
		rotation = target_rot
