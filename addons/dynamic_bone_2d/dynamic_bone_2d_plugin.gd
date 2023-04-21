tool
extends EditorPlugin


func _enter_tree():
	# When this plugin node enters tree, add the custom type
	add_custom_type("DynamicBone2D", "Line2D", preload("res://addons/dynamic_bone_2d/dynamic_bone_2d.gd"), preload("res://icon.png"))


func _exit_tree():
	# When the plugin node exits the tree, remove the custom type
	remove_custom_type("DynamicBone2D")
