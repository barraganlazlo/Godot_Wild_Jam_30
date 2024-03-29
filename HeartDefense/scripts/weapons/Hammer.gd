extends Sprite

onready var animation_player:=$AnimationPlayer
onready var main:= get_node("/root/Main")
onready var ysort = get_tree().get_nodes_in_group("ysort").front()
onready var buildings:= get_node("/root/Main/YSort/Buildings")
onready var preview:=  get_node("/root/Main/YSort/Preview")
onready var built_walls:=  get_node("/root/Main/YSort/BuiltWalls")
onready var preview_collision:=  get_node("/root/Main/YSort/Preview/PreviewCollision")

export var is_active:=true
export var can_build:=true
onready var immunity: bool = true
var build_position_is_empty:=true

const FREE_COLOR := Color(0.08,0.89,0.95,0.75)
const OCCUPIED_COLOR := Color(0.77,0.27,0.27,0.75)
const BUILD_RANGE := 100

var last_target_map_pos:=Vector2(-1,-1)

var hammer_sound_effect:=preload("res://Sounds/build.wav")


#BUILDINGS
enum {WALL, SPEAR, BOMB, NUMBER_BUILDING_TYPES}

var current_building:=WALL

onready var buildings_preview:=[
	get_node("/root/Main/YSort/Preview/PreviewWalls"),
	get_node("/root/Main/YSort/Preview/PreviewSpearBuilding"),
	get_node("/root/Main/YSort/Preview/PreviewBombBuilding")
]
var buildings_scene:=[
	null,
	preload("res://Scenes/Buildings/SpearBuilding.tscn"),
	preload("res://Scenes/Buildings/BombBuilding.tscn")
]
#END BUILDINGS


func _ready():
	set_process(false)


func receive_type(type):
	if type == -1:
		main.player.select(1)
	else:
		select(type)
	
	immunity = true
	$Timer.wait_time = 0.05
	$Timer.start()
	set_process(true)


func _process(_delta:float)-> void:
	if !is_active:
		return
		
	#ensure that target pos is in range of the player
	var player_global_pos=main.player.global_position
	var target_world_pos=get_global_mouse_position()-player_global_pos
	target_world_pos.x=clamp(target_world_pos.x,-BUILD_RANGE,BUILD_RANGE)
	target_world_pos.y=clamp(target_world_pos.y,-BUILD_RANGE,BUILD_RANGE)
	target_world_pos+=player_global_pos
	
	var target_map_pos=built_walls.world_to_map(target_world_pos)
	
	#ensure that target_map_pos is inside the map
	target_map_pos.x=clamp(target_map_pos.x, main.MIN_MAP_POS.x, main.MAX_MAP_POS.x)
	target_map_pos.y=clamp(target_map_pos.y, main.MIN_MAP_POS.y, main.MAX_MAP_POS.y)
	
	
	#update the preview_tile 
	update_preview(target_map_pos)
	last_target_map_pos=target_map_pos
	
	#check if the tile where the preview is is free
	var target_pos_is_free=built_walls.get_cellv(target_map_pos)==-1
	#check if the if there are enemies or the player on the preview tile
	target_pos_is_free=target_pos_is_free && preview_collision.get_overlapping_bodies().size()==0
	
	
#	if(Input.is_action_just_pressed("change building")):
#		var target_building:=(current_building+1) % NUMBER_BUILDING_TYPES
#		select(target_building)
	
	if(target_pos_is_free):
		#update the color of the preview
		preview.modulate=FREE_COLOR
		#Build if it's posible
		if (can_build && Input.is_action_pressed("build")) :
			build(target_map_pos)
	else:
		#update the color of the preview
		preview.modulate=OCCUPIED_COLOR
		if (can_build && Input.is_action_pressed("destruct")) :
			destruct(target_map_pos)
			animation_player.play("Build")
		
	
#	if Input.is_action_just_released("mouse_right"):
#		if immunity:
#			return
#		main.player.select(1)
#		main.player.build_wheel_allowed = false
#		main.player.show_building_range(0)
#		set_process(false)
#	else:
#		main.player.show_building_range(BUILD_RANGE)

func update_preview(target_map_pos:Vector2)->void :
	#update preview collision position
	var world_preview_pos=Vector2(8,8) + built_walls.map_to_world(target_map_pos)
	preview_collision.global_position=world_preview_pos
	buildings_preview[WALL].set_cellv(last_target_map_pos,-1)
	#update preview sprites
	match current_building:
		WALL:
			buildings_preview[WALL].set_cellv(target_map_pos,0)
		_:
			buildings_preview[current_building].global_position=world_preview_pos
	
func build(target_map_pos:Vector2)->void :
	animation_player.play("Build")
	var player_money: int = Global.player_type[Global.PLAYER.MONEY]
	var cost: int
	if current_building == WALL:
		cost = Global.building_types["wall"][Global.BUILDING.COST]
	elif current_building == SPEAR:
		cost = Global.building_types["spear"][Global.BUILDING.COST]
	elif current_building == BOMB:
		cost = Global.building_types["bomb"][Global.BUILDING.COST]
	
	if cost > player_money:
		Global.update_coins(0)
		return
	Global.update_coins(-cost)
	play_build_sound()
	match current_building:
		WALL:
			built_walls.add_tile(target_map_pos,0)
		_:
			var building=buildings_scene[current_building].instance()
			ysort.add_child(building)
			building.global_position=Vector2(8,8)+built_walls.map_to_world(target_map_pos)

func destruct(target_map_pos:Vector2)->void :
	animation_player.play("Build")
	built_walls.add_tile(target_map_pos,-1)
	var bodies=preview_collision.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("Building"):
			body.queue_free()
	
func select(target_building)-> void:
	if target_building==current_building:
		return
	buildings_preview[current_building].visible=false
	buildings_preview[target_building].visible=true
	current_building=target_building

func activate()->void:
	is_active=true
	visible=true
	preview.visible=true

func desactivate()->void:
	is_active=false
	visible=false
	preview.visible=false

func play_build_sound():
	$AudioStreamPlayer2D.stream=hammer_sound_effect
	$AudioStreamPlayer2D.play()


func _on_Timer_timeout() -> void:
	immunity = false
