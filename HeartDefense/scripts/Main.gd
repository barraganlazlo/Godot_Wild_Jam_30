extends Node2D

onready var rng = RandomNumberGenerator.new()
onready var room_pixel_size: Vector2 = Vector2(640.0,360.0)

onready var ysort:= $YSort
onready var heart_building:= $YSort/HeartBuilding
onready var player:= $YSort/Player
onready var buildings:= $YSort/Buildings
onready var camera:= $YSort/Camera2D
export var center_pos: Vector2 = Vector2(0,0)
onready var preview_buildings:= $YSort/Preview/PreviewBuildings
onready var preview_collision:= $YSort/Preview/PreviewCollision

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

