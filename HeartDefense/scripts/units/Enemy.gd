extends "res://scripts/units/Unit.gd"

func init(sprite_string: String = "ogre", spd: float = 100.0, anim_spd: float = 2.25):
	.init(sprite_string, spd, anim_spd)
	destination = get_tree().get_nodes_in_group("heart_building").front().global_position

func _physics_process(delta: float) -> void:
	._physics_process(delta)
	set_flip(direction)

func _on_HurtBox_body_entered(body) -> void:
	body.hp -= 1

func _ready():
	add_to_group("Enemies")
