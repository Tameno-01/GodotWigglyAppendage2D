extends Node


func _process(delta):
	print(get_node("../DynamicBone2D").get_global_point_positions())
