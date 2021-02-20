extends Sprite

onready var type: String = ""

# set the speed of when the enemy drops and
# passing an array of possible enemy types if wanting to be randomized
func init(drop_speed: float, new_type):
	type = new_type
	var t_trans: int = Tween.TRANS_CUBIC
	var t_ease: int = Tween.EASE_IN
	$Tween.interpolate_property(self, "scale", Vector2(2,2), Vector2(0.25,0.25), 
		drop_speed, t_trans, t_ease)
	$Tween.interpolate_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.1), 
		Color(1.0, 1.0, 1.0, 0.7), drop_speed, t_trans, t_ease)
	$Tween.start()


func _on_Tween_tween_all_completed() -> void:
	var main: Node2D = get_tree().get_nodes_in_group("main").front()
	var type_data = Global.enemy_types[type]
	main.create_enemy(global_position, type)
	queue_free()

