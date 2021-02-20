extends Node

# Timers
onready var spawn =  $Spawn
onready var duration =  $Duration
onready var cooldown =  $Cooldown

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
onready var wave: int = 1

# How much time to next wave
onready var wave_cooldown: float = 15.0

func _ready() -> void:
	init()


func init(wave_num: int = 1):
	var next_wave_method: String = "level_" + str(wave)
	if has_method(next_wave_method):
		call(next_wave_method)
	else:
		print("YOU WIN")
	
	spawn.wait_time = spawn_spd
	duration.wait_time = spawn_duration
	cooldown.wait_time = wave_cooldown
	
	spawn.start()
	duration.start()
	wave = wave_num



func level_1():
	types = ["muddy"]
	spawn_spd = 0.5
	spawn_duration = 3.0
	wave_cooldown = 15.0

func level_2():
	types = ["muddy"]
	spawn_spd = 0.5
	spawn_duration = 99.0
	wave_cooldown = 15.0

func _on_Spawn_timeout() -> void:
	# Enemy spawn in top-left and bottom-right with a random x,y offset
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
	spawn_pos += offset
	
	var random_type = randi() % types.size()
	main.create_dropped_enemy(spawn_pos, types[random_type])
	spawn.wait_time = spawn_spd
	spawn.start()

func _on_Duration_timeout() -> void:
	spawn.stop()
	cooldown.start()
	var inst = load("res://Scenes/Gui/WaveTimer.tscn")
	var waveTimer = inst.instance()
	get_tree().get_nodes_in_group("camera").front().add_child(waveTimer)
	waveTimer.init(wave_cooldown, wave)
	waveTimer.rect_position += Vector2(0,-64)

func _on_Cooldown_timeout() -> void:
	init(wave + 1)






