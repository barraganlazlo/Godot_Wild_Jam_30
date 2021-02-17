extends Node

onready var level_stats: Array = [0,0,0,0]

enum STATS {
	MONSTERS_KILLED,
	BUILDINGS_BUILT,
	ARROWS_SHOT,
	HEART_BEATS,
	limit,
}

func retry():
	call_deferred("go_to_scene")
	
func go_to_scene():
	get_tree().change_scene("res://Scenes/Main.tscn")
