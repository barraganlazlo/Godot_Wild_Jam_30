extends Camera2D

onready var link = get_tree().get_nodes_in_group("Player").front()
onready var smooth : bool = true
onready var viewing_sensitivity: float = 18.0
onready var shake: bool = false
onready var shake_intensity: float = 1.0

func _process(delta: float) -> void:
	var link_global_pos: Vector2 = link.global_position
	var dist: Vector2 = Vector2.ZERO
	if smooth:
		var link_loc_mouse: Vector2 = get_global_mouse_position()
		dist = Vector2(link_loc_mouse-link_global_pos) / viewing_sensitivity
		
		#var diff : Vector2 = (2 * player.global_position) + (player.get_local_mouse_position() / sensitivity)
	var shake_vec: Vector2 = Vector2.ZERO
	if shake:
		shake_vec.x = shake_intensity * (sign(rand_range(-1,1)))
		shake_vec.y = shake_intensity * (sign(rand_range(-1,1)))
	global_position = link_global_pos + dist + shake_vec

func shake(time: float = 1.0, intensity: float = 1.0):
	$Timer.stop()
	$Timer.wait_time = time
	shake_intensity = intensity
	shake = true
	$Timer.start()

func _on_Timer_timeout() -> void:
	shake = false
