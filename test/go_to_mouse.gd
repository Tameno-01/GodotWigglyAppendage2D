extends Node2D


func _process(delta):
	position = get_global_mouse_position()


func _unhandled_input(event):
	if event is InputEventMouseButton:
		scale.x *= -1
