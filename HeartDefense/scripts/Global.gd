extends Node

onready var level_stats: Array = [0,0,0,0]

enum STATS {
	MONSTERS_KILLED,
	BUILDINGS_BUILT,
	ARROWS_SHOT,
	HEART_BEATS,
	limit,
}

enum PLAYER {
	DAMAGE,
	MONEY
}
# [ Damage , Money ]
onready var player_type: Array = [1, 0]

onready var enemy_types: Dictionary = {
	# [ Move spd , Animation spd , Hp ]
	"muddy": [20, 0.75, 5],
	"big_demon": [40, 0.75, 5],
	"orc_shaman": [40, 0.75, 5],
	"ogre": [40, 0.75, 5],
	"goblin": [40, 0.75, 5],
}

onready var building_types: Dictionary = {
	# [ Hp , Damage , proj_spd]
	"spear": [2, 2 , 700],
	"wall":  [3, 0 , 0]
}
func retry():
	call_deferred("go_to_scene")
	
func go_to_scene():
	get_tree().change_scene("res://Scenes/Main.tscn")
