extends Node

signal update_coins(value)

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

enum ENEMY {
	SPD,
	ANIM_SPD,
	HP,
	MONEY,
	MONEY_CHANCE,
}

onready var enemy_types: Dictionary = {
	# [ Move spd , Animation spd , Hp , Money_amount, Money_chance]
	"muddy": 		[25, 0.75, 5, 1, 0.5],
	"goblin": 		[60, 1.75, 7, 1, 0.75],
	"orc_shaman": 	[20, 0.75, 3, 2, 0.5],
	"zombie": 		[15, 0.50, 12, 2, 1.0],
	"big_zombie": 	[10, 0.50, 26, 3, 1.0],
	"skelet": 		[35, 1.0, 3, 2, 0.4],
	"swampy": 		[30, 1.25, 15, 3, 0.5],
	"big_demon": 	[125, 1.75, 3, 1, 0.9],
	"ogre": 		[15, 0.5, 50, 5, 1.0],
}

enum BUILDING {
	HP,
	DAMAGE,
	PROJ_SPD,
	COST,
}
onready var building_types: Dictionary = {
	# [ Hp , Damage , proj_spd, cost]
	"spear": 	[2, 3 , 700, 3],
	"wall":  	[3, 0 , 0, 1],
	"bomb": 	[1, 2 , 10, 3],
}

func _ready() -> void:
	var timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "passive_income")
	timer.wait_time = 2.5
	timer.start()

func passive_income():
	update_coins(1)

func update_coins(value):
	player_type[PLAYER.MONEY] += value
	emit_signal("update_coins", value)

func retry():
	call_deferred("go_to_scene")
	
func go_to_scene():
	get_tree().change_scene("res://Scenes/main.tscn")
