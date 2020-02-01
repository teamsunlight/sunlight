extends KinematicBody

export var speed = 10
export var acceleration = 5
export var gravity = 0.98
export var jump_power = 30
export var mouse_sensitivity = 0.3

onready var head = $Head
onready var camera = $Head/Camera

var velocity = Vector3()
var camera_x_rotation = 0

var carried_object = null
var throw_power = 0

var look_vector = Vector3()

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))

		var x_delta = event.relative.y * mouse_sensitivity
		if camera_x_rotation + x_delta > -90 and camera_x_rotation + x_delta < 90: 
			camera.rotate_x(deg2rad(-x_delta))
			camera_x_rotation += x_delta

func _process(_delta):
	
	#Lock mouse cursor inside gamescreen
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	#Looking direction	
	var dir = (get_node("Head/Camera/Pickup").get_global_transform().origin - get_node("Head/Camera").get_global_transform().origin).normalized()
	look_vector = dir
	
	#Interaction prompt
	if $Head/Camera/Interaction.is_colliding():
		var interactable_object = $Head/Camera/Interaction.get_collider()
		if interactable_object.has_method("pick_up"):
			$Interaction.show()
			$Interaction/MarginContainer/Text.set_text("[RMB]  Pick up: " + interactable_object.get_name())
		elif interactable_object.has_method("interact"):
			$Interaction.show()
			$Interaction/MarginContainer/Text.set_text("[E]  Interact with: " + interactable_object.get_name())
		else:
			$Interaction/MarginContainer/Text.set_text("")
			$Interaction.hide()			
	else:
		$Interaction/MarginContainer/Text.set_text("")
		$Interaction.hide()
		
func _physics_process(delta):
	var head_basis = head.get_global_transform().basis
	
	var direction = Vector3()
	if Input.is_action_pressed("move_forward"):
		direction -= head_basis.z
	elif Input.is_action_pressed("move_backward"):
		direction += head_basis.z
	
	if Input.is_action_pressed("move_left"):
		direction -= head_basis.x
	elif Input.is_action_pressed("move_right"):
		direction += head_basis.x
		
	if Input.is_mouse_button_pressed(BUTTON_RIGHT):
		if carried_object != null:
			carried_object.pick_up(self)
		else:
			if $Head/Camera/Interaction.is_colliding():
				var x = $Head/Camera/Interaction.get_collider()
				if x.has_method("pick_up"):
					x.pick_up(self)
					
	if Input.is_action_just_released("drop"):
		if carried_object != null:
			carried_object.throw(throw_power)
		throw_power = 0
	
	direction = direction.normalized()
	
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta)
	velocity.y -= gravity
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y += jump_power
	
	velocity = move_and_slide(velocity, Vector3.UP)
	
#Throw stuff
func throwing(_delta):
	if carried_object != null:
		if Input.is_action_pressed("drop"):
			if throw_power <= 250:
				throw_power += 2
