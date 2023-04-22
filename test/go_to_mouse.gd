extends Node2D


func _process(_delta: float):
	position = get_global_mouse_position()


func _unhandled_input(input_event: InputEvent):
	if input_event is InputEventMouseButton:
		scale.x *= -1
