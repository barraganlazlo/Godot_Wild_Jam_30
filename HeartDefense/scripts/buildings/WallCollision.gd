extends "res://scripts/buildings/Building.gd"

onready var built_walls := get_node("..")

func _ready()->void:
	._ready()
	hp= Global.building_types["wall"][0]

func hp_depleted()->void:
	.hp_depleted()
	built_walls.add_tile(built_walls.world_to_map(global_position-Vector2(8,8)),-1)

func anticipate_heart_beat():
	pass

func heart_beat():
	pass
