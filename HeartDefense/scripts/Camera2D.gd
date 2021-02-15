extends Camera2D

onready var link = get_tree().get_nodes_in_group("player").front()
onready var viewing_sensitivity: float = 18.0

func _process(delta: float) -> void:
	var link_loc_mouse: Vector2 = get_global_mouse_position()
	var link_global_pos: Vector2 = link.global_position
	var dist: Vector2 = Vector2(link_loc_mouse-link_global_pos) / viewing_sensitivity
	#var diff : Vector2 = (2 * player.global_position) + (player.get_local_mouse_position() / sensitivity)
	global_position = link_global_pos + dist
