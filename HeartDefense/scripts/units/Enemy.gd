extends "res://scripts/units/Unit.gd"

onready var damage: int = 1

func init(sprite_string: String = "ogre", spd: float = 100.0, anim_spd: float = 2.25):
	.init(sprite_string, spd, anim_spd)
	destination = find_nearest()

func _physics_process(delta: float) -> void:
	._physics_process(delta)
	set_flip(direction)

func _on_HurtBox_body_entered(body) -> void:
	var knockback_force = 10.0
	var knockback = global_position.direction_to(body.global_position) * knockback_force
	body.take_damage(damage, knockback)
	hp_depleted()

func _ready():
	add_to_group("Enemies")

func find_nearest()-> Vector2:
	var list_of_buildings = get_tree().get_nodes_in_group("building")
	var nearest_pos: Vector2 = get_tree().get_nodes_in_group("heart_building").front().global_position
	for i in list_of_buildings:
		if global_position.distance_to(i.global_position) < global_position.distance_to(nearest_pos):
			nearest_pos = i.global_position
	return nearest_pos
