extends Node

onready var rng = RandomNumberGenerator.new()

# Timers
onready var spawn =  $Spawn
onready var duration =  $Duration
onready var cooldown =  $Cooldown
onready var buyable = $Buyable
onready var destroyEnemy = $DestroyEnemy

onready var buyable_cost = 2
onready var buyable_chance = 20.0

onready var main = get_parent()
onready var top_left: =Vector2(64,64)
onready var bottom_right: =Vector2(64,64)
onready var max_spawn_rect_size: Vector2 = bottom_right - top_left


# How quick things spawn in wave
onready var spawn_spd: float = 1.0

# Array of string names of enemies that have a chance to be spawned
onready var types: Array = []

# How long the wave lasts
onready var spawn_duration: float = 10.0

# What wave it is
onready var wave: int = 0

# How much time to next wave
onready var wave_cooldown: float = 15.0

func _ready() -> void:
	rng.randomize()
	init()
	init_buyable_timer()


func init(wave_num: int = 1):
	var next_wave_method: String = "level_" + str(wave)
	call(next_wave_method)
	
	spawn.wait_time = spawn_spd
	duration.wait_time = spawn_duration
	cooldown.wait_time = wave_cooldown
	
	spawn.start()
	duration.start()
	wave = wave_num
	if wave == 4:
		buyable_chance = 15
	elif wave == 8:
		buyable_chance = 10



func init_buyable_timer():
	#Per wave, spawns num of buyables
	buyable.wait_time = rng.randf_range(buyable_chance/4,buyable_chance)
	buyable.start()
	buyable_cost += rng.randi_range(2,4)

#	"muddy": 		[15, 0.75, 5, 1, 0.2],
#	"goblin": 		[50, 1.25, 3, 1, 0.3],
#	"orc_shaman": 	[25, 1.0, 8, 2, 0.3],
#	"zombie": 		[5, 0.5, 20, 3, 1.0],
#	"big_zombie": 	[50, 1.25, 3, 1, 0.3],
#	"skelet": 		[50, 1.25, 3, 1, 0.3],
#	"swampy": 		[50, 1.25, 3, 1, 0.3],
#	"big_demon": 	[75, 1.75, 5, 2, 0.7],
#	"ogre": 		[5, 0.5, 20, 3, 1.0],
func level_0():
	types = []
	spawn_spd = 100.0
	spawn_duration = 1.0
	wave_cooldown = 1.0

func level_1():
	types = ["muddy"]
	spawn_spd = 1.5
	spawn_duration = 15.0
	wave_cooldown = 8.0

func level_2():
	types = ["muddy", "skelet"]
	spawn_spd = 1.0
	spawn_duration = 20.0
	wave_cooldown = 10.0

func level_3():
	Global.building_types["wall"][Global.BUILDING.COST] += 1
	types = ["muddy", "skelet", "orc_shaman"]
	spawn_spd = 0.75
	spawn_duration = 20.0
	wave_cooldown = 15.0

func level_4():
	Global.building_types["spear"][Global.BUILDING.COST] += 1
	Global.building_types["bomb"][Global.BUILDING.COST] += 1
	types = [ "goblin", "orc_shaman", "skelet"]
	spawn_spd = .75
	spawn_duration = 25.0
	wave_cooldown = 20.0

func level_5():
	types = ["orc_shaman", "zombie", "big_zombie"]
	spawn_spd = 0.65
	spawn_duration = 25.0
	wave_cooldown = 25.0

func level_6():
	Global.building_types["spear"][Global.BUILDING.COST] += 1
	Global.building_types["wall"][Global.BUILDING.COST] += 1
	types = [ "zombie", "big_zombie", "swampy"]
	spawn_spd = 0.5
	spawn_duration = 30.0
	wave_cooldown = 25.0

func level_7():
	Global.building_types["bomb"][Global.BUILDING.COST] += 1
	types = ["big_zombie", "swampy", "chort"]
	spawn_spd = 0.5
	spawn_duration = 30.0
	wave_cooldown = 25.0

func level_8():
	Global.building_types["spear"][Global.BUILDING.COST] += 1
	types = ["chort", "swampy", "big_demon"]
	spawn_spd = 0.5
	spawn_duration = 30.0
	wave_cooldown = 30.0

func level_9():
	Global.building_types["spear"][Global.BUILDING.COST] += 1
	Global.building_types["bomb"][Global.BUILDING.COST] += 1
	Global.building_types["wall"][Global.BUILDING.COST] += 1
	types = ["necromancer", "big_demon", "chort"]
	spawn_spd = 0.6
	spawn_duration = 35.0
	wave_cooldown = 30.0

func level_10():
	types = ["ogre", "necromancer", "big_demon", "chort"]
	spawn_spd = 0.8
	spawn_duration = 50.0
	wave_cooldown = 10.0

func _on_Spawn_timeout() -> void:
	# Enemy spawn in top-left and bottom-right with a random x,y offset
	var spawn_pos: Vector2 = within_rand_rect()
	var random_type = randi() % types.size()
	main.create_dropped_enemy(spawn_pos, types[random_type])
	spawn.wait_time = spawn_spd
	spawn.start()

func within_rand_rect():
	var spawn_pos: Vector2 = Vector2.ZERO
	var random_spawn = randi() % 2
	var offset: Vector2 = Vector2.ZERO
	if randi() % 2 == 0:
		offset = Vector2(randi() % (int(max_spawn_rect_size.x) + 1), 0)
	else:
		offset = Vector2(0, randi() % (int(max_spawn_rect_size.y) + 1))
	if random_spawn == 0:
		spawn_pos = top_left
	else:
		offset *= -1
		spawn_pos = bottom_right
	return (spawn_pos + offset)

func _on_Duration_timeout() -> void:	
	var next_wave_method: String = "level_" + str(wave)
	if has_method(next_wave_method):
		spawn.stop()
		cooldown.start()
		var inst = load("res://Scenes/Gui/WaveTimer.tscn")
		var waveTimer = inst.instance()
		get_tree().get_nodes_in_group("camera").front().add_child(waveTimer)
		waveTimer.init(wave_cooldown, wave)
		waveTimer.rect_position += Vector2(0,-96)
	else:
		main.game_won()
		stop_waves()

func stop_waves():
	cooldown.stop()
	spawn.stop()
	duration.stop()
	buyable.stop()
	var enemies = get_tree().get_nodes_in_group("Enemy")
	for i in enemies:
		i.sleep(100.0)
	destroyEnemy.wait_time = 0.15
	destroyEnemy.start()

func _on_Cooldown_timeout() -> void:
	init(wave + 1)

func _on_Buyable_timeout() -> void:
	var spawn_pos: Vector2 = within_rand_rect()
	var type: int = rng.randi_range(0,4)
	create_buyable(spawn_pos, type)
	init_buyable_timer()

func create_buyable(room_pos: Vector2, type):
	var inst = load("res://Scenes/Wave/Buyable.tscn")
	var buy = inst.instance()
	main.ysort.add_child(buy)
	buy.global_position = room_pos
	buy.init(type, buyable_cost)


func _on_DestroyEnemy_timeout() -> void:
	var enemies = get_tree().get_nodes_in_group("Enemy")
	if !enemies.empty():
		enemies.front().hp_depleted()
