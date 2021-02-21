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
	MONEY,
	ATTACK_SPEED,
}
# [ Damage , Money ]
onready var player_type: Array = [1, 10, 1.0]

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
	"muddy": 		[25, 0.75, 5, 1, 0.5, 0.7],
	"goblin": 		[45, 1.00, 4, 1, 0.75, 0.8],
	"orc_shaman": 	[20, 0.75, 5, 2, 0.5, 0.8],
	"zombie": 		[25, 0.75, 12, 2, 0.8, 0.6],
	"big_zombie": 	[15, 0.50, 26, 3, 0.8, 0.2],
	"skelet": 		[35, 1.00, 6, 1, 0.9, 0.9],
	"swampy": 		[30, 1.25, 25, 3, 0.5, 0.5],
	"big_demon": 	[125, 1.75, 12, 2, 0.9, 0.1],
	"ogre": 		[20, 0.5, 60, 5, 0.25, 0.05],
}

enum BUILDING {
	HP,
	DAMAGE,
	PROJ_SPD,
	COST,
}
onready var building_types: Dictionary = {
	# [ Hp , Damage , proj_spd, cost]
	"spear": 	[3, 2, 700, 3],
	"wall":  	[4, 0 , 0, 1],
	"bomb": 	[2, 1, 10, 3],
}

onready var passive_money: int = 1

func _ready() -> void:
	var timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "passive_income")
	timer.wait_time = 2.0
	timer.start()

func passive_income():
	update_coins(passive_money)

func update_coins(value):
	player_type[PLAYER.MONEY] += value
	emit_signal("update_coins", value)

func retry():
	call_deferred("go_to_scene")
	
func go_to_scene(scene: String = "res://Scenes/main.tscn"):
	get_tree().change_scene(scene)
