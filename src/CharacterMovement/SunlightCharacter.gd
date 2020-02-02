extends KinematicBody

class_name SunlightCharacter

export var Sensitivity_X: float = 0.01
export var Sensitivity_Y: float = 0.01

export var Jump_Speed: float = 15.0
export var Acceleration: float = 10
export var Walk_Max_Speed: float = 6
export var Sprint_Max_Speed: float = 10
export var Rotate_Model_Step: float = PI * 2.0
export var GravityFloorMul: float = 20.0
export var GravityFlyMul: float = 3.0
export var GravityExternalMul: float = 1.0
const ZOOM_MIN = 0.5
const ZOOM_MAX = 5
const Zoom_Step: float = 0.3
const MIN_ROT_Y = -1.55 #(89 degrees)
const MAX_ROT_Y = 0.79 #(45 degrees)
const GRAVITY = 9.8


onready var camera_node: Spatial = $SpringArm
onready var model_node: Spatial = $Hero_Model
onready var state_machine: AnimationTree = get_node("AnimationTree")

var move_dir: Vector2 = Vector2()
var velocity: Vector3 = Vector3()
var max_speed: float = Walk_Max_Speed
var current_speed: float = 0.0
var jumping: bool = false setget _set_jumping
var gravity: float
var target_angle_model: float = 0.0
var rot_model: float = 0.0
var old_angle_model:float = 0.0

var GUI_management: bool = false;
func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass

func _input(event):
	# Player actions processing
	if event is InputEventKey and event.pressed and event.scancode == KEY_J:
		Sprint_Max_Speed *= 8
	if event is InputEventKey and event.pressed and event.scancode == KEY_K:
		Sprint_Max_Speed /= 8
		 
	if Input.is_action_just_pressed("gui_management"):
		GUI_management = !GUI_management
	if GUI_management:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		return
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	var temp: Vector2 = Vector2()

	temp = move_dir #This variable is needed to find out if the keystrokes (arrows) have changed.
	move_dir = Vector2(Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward"),
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left")).normalized()
	# If you have changed, then you need to calculate the new angle of
	# rotation of the model and remember the old one, because the rotation
	# is relatively old.
	if move_dir!= temp:
		rot_model =0
		old_angle_model = target_angle_model
		if move_dir.x < 0 and move_dir.y ==0:
			target_angle_model = 0
		if move_dir.x > 0 and move_dir.y ==0:
			target_angle_model = PI
		if move_dir.x == 0 and move_dir.y >0:
			target_angle_model = -PI/2
		if move_dir.x == 0 and move_dir.y <0:
			target_angle_model = PI/2
		if move_dir.x < 0 and move_dir.y >0:
			target_angle_model = -PI/4
		if move_dir.x < 0 and move_dir.y <0:
			target_angle_model = PI/4
		if move_dir.x > 0 and move_dir.y >0:
			target_angle_model = -PI*3/4
		if move_dir.x > 0 and move_dir.y <0:
			target_angle_model= PI*3/4

		if target_angle_model - old_angle_model >PI:
			old_angle_model +=2*PI
		if target_angle_model - old_angle_model < -PI:
			old_angle_model -=2*PI

	if event.is_action_pressed("jump") and is_on_floor():
		jumping = true
	if event.is_action_pressed("move_sprint"):
		max_speed = Sprint_Max_Speed
	if event.is_action_released("move_sprint"):
		max_speed = Walk_Max_Speed
	#Camera actions
	if event.is_action_pressed("camera_zoom_in"):
		camera_node.spring_length =clamp(camera_node.spring_length - Zoom_Step,ZOOM_MIN,ZOOM_MAX)
	if event.is_action_pressed("camera_zoom_out"):
		camera_node.spring_length =clamp(camera_node.spring_length + Zoom_Step,ZOOM_MIN,ZOOM_MAX)

	if event is InputEventMouseMotion:
		var rotx = clamp(
			camera_node.target_rot.x - event.relative.y * Sensitivity_X,
			MIN_ROT_Y, MAX_ROT_Y
		)
		var roty = camera_node.target_rot.y - event.relative.x * Sensitivity_Y
		if roty > PI:
				roty -= 2 * PI
		elif roty < -PI:
				roty += 2 * PI
		camera_node.set_target_rot(Vector3(rotx, roty, camera_node.target_rot.z))

func _physics_process(delta):
	if is_on_floor():
		gravity = GRAVITY * GravityFloorMul * GravityExternalMul
		if max_speed < current_speed or move_dir ==Vector2.ZERO:
			#If you stop or go to the step (max_speed <current_speed), then slow down
			current_speed -= Acceleration*delta
		else:
			current_speed += Acceleration*delta
		current_speed = clamp(current_speed,0,Sprint_Max_Speed)

		if move_dir != Vector2.ZERO:
			velocity.z = move_dir.x*current_speed
			velocity.x = move_dir.y*current_speed
			velocity = velocity.rotated(Vector3.UP, camera_node.target_rot.y)
			model_node.rotation.y = camera_node.target_rot.y+PI
			rot_model = min(rot_model+delta*Rotate_Model_Step, 1)
			model_node.rotation.y += lerp(old_angle_model, target_angle_model, rot_model)
			if model_node.rotation.y >PI:
				model_node.rotation.y -= PI*2
			if model_node.rotation.y < -PI:
				model_node.rotation.y += PI*2
		else:
			velocity=velocity.normalized() #We keep the old direction of movement, because we let go of the buttons and slow down
			velocity.x = velocity.x*current_speed
			velocity.z = velocity.z*current_speed
			model_node.rotation.y = camera_node.target_rot.y+PI
			rot_model = min(rot_model+delta*Rotate_Model_Step, 1)
			model_node.rotation.y += lerp(old_angle_model, target_angle_model, rot_model)
		if jumping:
			velocity.y += Jump_Speed
			jumping = false
		state_machine.set("parameters/Moving/blend_position", Vector2(velocity.x,velocity.z).length())
	else:
		gravity = GRAVITY * GravityFlyMul * GravityExternalMul

	velocity.y -= gravity * delta
	velocity = move_and_slide(velocity, Vector3.UP, true)

	state_machine.set("parameters/conditions/is_floor", is_on_floor())
	state_machine.set("parameters/conditions/is_not_floor", !is_on_floor())

func _set_jumping(_jumping: bool):
	jumping = _jumping
	state_machine.set("parameters/conditions/is_jump", _jumping)
	pass
