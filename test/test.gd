extends Node


func _process(_delta: float):
	print(get_node("../DynamicBone2D").get_global_point_positions())
