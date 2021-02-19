extends Node2D

onready var rng = RandomNumberGenerator.new()
onready var room_pixel_size: Vector2 = Vector2(640.0,360.0)

onready var ysort:= $YSort
onready var heart_building:= $YSort/HeartBuilding
onready var player:= $YSort/Player
onready var camera:= $YSort/Camera2D
export var center_pos: Vector2 = Vector2(0,0)
onready var game_over: bool = false

func _ready() -> void: 
	rng.randomize()
	heart_building.connect("heart_beat", self, "heart_beat")

func heart_beat():
	var i = randi() % 5
	var sprite_string: String = "orc_shaman"
	if i == 0:
		sprite_string = "big_demon"
	elif i == 1:
		sprite_string = "goblin"
	elif i == 2:
		sprite_string = "muddy"
	elif i == 3:
		sprite_string = "ogre"
	print(sprite_string)
	var rand_spd: float = rng.randf_range(1.0, 2.25)
	var rand_move_spd: float = rand_spd * 25
	var rand_anim_spd: float = rand_spd
	create_enemy(Vector2(96, 96), sprite_string, rand_move_spd, rand_anim_spd)
	
	
	var transformed_position = heart_building.get_global_transform_with_canvas().origin / get_viewport_rect().size
	var aspect_ratio = get_viewport_rect().size.aspect()
	transformed_position.x = (transformed_position.x - 0.5) * aspect_ratio + 0.5
	var center_pos = Vector2(transformed_position.x,1.0-transformed_position.y)
	$Shockwave/ColorRect.material.set_shader_param("center", center_pos)
	$Shockwave/AnimationPlayer.current_animation = "Pulse"
	$Shockwave/AnimationPlayer.play("Pulse")


func create_enemy(room_pos: Vector2,sprite: String, move_spd: float, anim_spd: float):
	var enemy_load = load("res://Scenes/Enemy.tscn")
	var inst = enemy_load.instance()
	$YSort.add_child(inst)
	inst.global_position = room_pos
	inst.init(sprite, move_spd, anim_spd)

func game_won():
	var heart_b = get_tree().get_nodes_in_group("heart_building").front()
	var heart_s = heart_b.get_node("Heart")
	
	# Pan Camera to heart
	camera.link = heart_s
	camera.smooth = true
	
	# Slow down engine
	$Tween.interpolate_property(Engine, "time_scale", Engine.time_scale, 
		0.1, 0.35, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	
	$Tween.start()

func game_over():
	$Tween.stop_all()
	var spd = 0.5
	var heart_b = get_tree().get_nodes_in_group("heart_building").front()
	var heart_s = heart_b.get_node("Heart")
	# Discolor heart
	$Tween.interpolate_property(heart_s, "modulate", Color(1,1,1,1), 
		Color(0.2, 0.1, 0.3, 1.0), spd, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	# Shrink Heart
	$Tween.interpolate_property(heart_s, "scale", heart_s.scale, 
		Vector2(0.75, 0.75), spd, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	
	# Pan Camera to heart
	camera.link = heart_s
	camera.smooth = true

	# Slow down engine
	$Tween.interpolate_property(Engine, "time_scale", Engine.time_scale, 
		0.1, spd, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	
	$Tween.start()

func _on_Tween_tween_all_completed() -> void:
	Engine.time_scale = 1.0
	print("freeze")
	for i in get_tree().get_nodes_in_group("Enemies"):
		i.set_animation_spd(0.0)
		i.set_physics_process(false)
		i.set_process(false)
	var player = get_tree().get_nodes_in_group("Player").front()
	player.set_animation_spd(0.0)
	player.set_physics_process(false)
	player.set_process(false)
	var weapons = get_tree().get_nodes_in_group("Weapons").front()
	weapons.queue_free()
	
	
	var results: String = "Won"
	if game_over:
		camera.shake(100.0, 1.25)
		results = "Lost"
		var heart_b = get_tree().get_nodes_in_group("heart_building").front()
		var heart_s = heart_b.get_node("Heart")
		var inst = load("res://Scenes/Particles/Explode.tscn")
		var particle = inst.instance()
		heart_s.add_child(particle)
		particle.global_position = heart_s.global_position
	show_level_results(results)

func show_level_results(results: String):
	var inst = load("res://Scenes/Gui/LevelResults.tscn")
	var levelResults = inst.instance()
	$Shockwave.add_child(levelResults)
	levelResults.rect_position = Vector2(camera.global_position.x, 0)
	var level_stats: Array = Global.level_stats
	levelResults.init(results, level_stats)
