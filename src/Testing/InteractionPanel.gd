extends Panel

func _ready():
	var viewport_size = get_viewport_rect().size
	rect_size.x = viewport_size.x
	rect_position.y = viewport_size.y -51
	pass 
