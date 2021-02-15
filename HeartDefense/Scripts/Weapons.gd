extends Node2D

func _process(_delta:float)-> void:
	rotation+=get_local_mouse_position().angle()
