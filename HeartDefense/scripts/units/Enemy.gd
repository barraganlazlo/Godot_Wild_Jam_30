extends "res://scripts/units/Unit.gd"

onready var damage: int = 1

func init(sprite_string: String = "ogre", spd: float = 100.0, anim_spd: float = 2.25, new_hp: int = 10):
	.init(sprite_string, spd, anim_spd, new_hp)
	destination = find_nearest()
	set_physics_process(false)
	$WakeUp.wait_time = 0.4
	$WakeUp.start()

func _physics_process(delta: float) -> void:
	._physics_process(delta)
	if global_position.distance_to(destination) <= 3.0:
		destination = find_nearest()
	set_flip(direction)

func _ready():
	add_to_group("Enemy")

func hp_reduced():
	.hp_reduced()
	var move_s = Global.enemy_types[type][0]
	var anim_s = Global.enemy_types[type][1]
	var max_hp = Global.enemy_types[type][2]
	var weak_ratio = float(hp) / float(max_hp) 
	set_move_spd(weak_ratio * move_s)
	set_animation_spd(weak_ratio * anim_s)
	
func find_nearest()-> Vector2:
	var list_of_buildings = get_tree().get_nodes_in_group("Building")
	var nearest_pos: Vector2 = get_tree().get_nodes_in_group("Heart_Building").front().global_position
	for i in list_of_buildings:
		if global_position.distance_to(i.global_position) < global_position.distance_to(nearest_pos):
			nearest_pos = i.global_position
	return nearest_pos


func _on_HurtBox_body_entered(body) -> void:
	var knockback_force = 10.0
	var knockback = global_position.direction_to(body.global_position) * knockback_force
	body.take_damage(damage, knockback)
	hp_depleted()


func _on_WakeUp_timeout() -> void:
	set_physics_process(true)
