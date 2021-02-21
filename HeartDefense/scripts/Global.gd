extends Node

signal update_coins(value)

onready var level_stats: Array = [0,0,0,0,0]

enum STATS {
	MONSTERS_KILLED,
	BUILDINGS_BUILT,
	ARROWS_SHOT,
	HEART_BEATS,
	MONEY_COLLECTED,
	limit,
}

enum PLAYER {
	DAMAGE,
	MONEY,
	ATTACK_SPEED,
}
# [ Damage , Money ]
onready var player_type: Array = [1, 0, 1.0]
onready var og_player_type: Array = player_type.duplicate(true)
enum ENEMY {
	SPD,
	ANIM_SPD,
	HP,
	MONEY,
	MONEY_CHANCE,
	KNOCKBACK_RES,
}

onready var enemy_types: Dictionary = {
	# [ Move spd , Animation spd , Hp , Money_amount, Money_chance, knockback-res]
	"muddy": 		[10, 0.50, 5, 1, 0.6, 0.7],
	"skelet": 		[20, 0.75, 2, 1, 0.7, 0.9],
	"goblin": 		[25, 1.00, 2, 1, 0.8, 0.8],
	"orc_shaman": 	[20, 0.75, 5, 1, 0.6, 0.8],
	"zombie": 		[25, 0.75, 8, 1, 0.8, 0.5],
	"big_zombie": 	[15, 0.50, 25, 2, 0.6, 0.2],
	"swampy": 		[30, 0.75, 20, 2, 0.4, 0.1],
	"chort":		[40, 1.25, 18, 2, 0.5, 0.6],
	"big_demon": 	[80, 1.75, 8, 1, 0.8, 1.0],
	"necromancer":	[30, 1.00, 10, 2, 0.5, 0.9],
	"ogre": 		[5, 0.25, 50, 3, 0.5, 0.0],
}

enum BUILDING {
	HP,
	DAMAGE,
	PROJ_SPD,
	COST,
}
onready var building_types: Dictionary = {
	# [ Hp , Damage , proj_spd, cost]
	"spear": 	[2, 2, 650, 3],
	"wall":  	[5, 0 , 0, 1],
	"bomb": 	[2, 1, 110, 3],
}
onready var og_building_types: Dictionary = building_types.duplicate(true)

onready var passive_money: int = 1

func _ready() -> void:
	var timer = Timer.new()
	timer.name = "PassiveTimer"
	add_child(timer)
	timer.connect("timeout", self, "passive_income")
	timer.wait_time = 2.0
	timer.start()

func passive_income():
	update_coins(passive_money)

func update_coins(value):
	if value > 0:
		level_stats[STATS.MONEY_COLLECTED] += value
	player_type[PLAYER.MONEY] += value
	emit_signal("update_coins", value)

func retry():
	call_deferred("go_to_scene")
	
func go_to_scene(scene: String = "res://Scenes/main.tscn"):
	get_tree().change_scene(scene)
