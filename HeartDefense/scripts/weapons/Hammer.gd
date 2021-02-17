extends Sprite

onready var animation_player:=$AnimationPlayer
onready var main:= get_node("/root/Main")

export var is_active:=true
export var can_build:=true
var build_position_is_empty:=true

const FREE_COLOR := Color(0,0,1,0.75)
const OCCUPIED_COLOR := Color(1,0,0,0.75)
const MIN_target_map_pos := Vector2(1,2)
const MAX_target_map_pos := Vector2(38,21)
const BUILD_RANGE := 100

var last_target_map_pos:=Vector2(-1,-1)

var current_building:=0


func _process(_delta:float)-> void:
	if !is_active :
		return
		
	#ensure that target pos is in range of the player
	var player_global_pos=main.player.global_position
	var target_world_pos=get_global_mouse_position()-player_global_pos
	target_world_pos.x=clamp(target_world_pos.x,-BUILD_RANGE,BUILD_RANGE)
	target_world_pos.y=clamp(target_world_pos.y,-BUILD_RANGE,BUILD_RANGE)
	target_world_pos+=player_global_pos
	
	var target_map_pos=main.buildings.world_to_map(target_world_pos)
	
	#ensure that target_map_pos is inside the map
	target_map_pos.x=clamp(target_map_pos.x, MIN_target_map_pos.x, MAX_target_map_pos.x)
	target_map_pos.y=clamp(target_map_pos.y, MIN_target_map_pos.y, MAX_target_map_pos.y)
	
	
	
	#update preview collision position
	main.preview_collision.global_position=Vector2(8,8) + main.buildings.map_to_world(target_map_pos)
	
	#check if the tile where the preview is is free
	var target_pos_is_free=main.buildings.get_cellv(target_map_pos)==-1
	#check if the if there are enemies or the player on the preview tile
	if(main.preview_collision):
		target_pos_is_free=target_pos_is_free && main.preview_collision.get_overlapping_bodies().size()==0
	
	#update the preview_tile 
	if(last_target_map_pos!=target_map_pos):
		main.preview_buildings.set_cellv(last_target_map_pos,-1)
		main.preview_buildings.set_cellv(target_map_pos,0)
		last_target_map_pos=target_map_pos
	
	if(target_pos_is_free):
		#upate the color of the preview
		main.preview_buildings.modulate=FREE_COLOR
		#Build if it's posible
		if (can_build && Input.is_action_pressed("shoot")) :
			animation_player.play("Build")
			main.buildings.set_cellv(target_map_pos,0)
			main.buildings.update_bitmask_area(target_map_pos)
	else:
		#upate the color of the preview
		main.preview_buildings.modulate=OCCUPIED_COLOR

func activate():
	is_active=true
	visible=true
	main.preview_buildings.visible=true

func desactivate():
	is_active=false
	visible=false
	main.preview_buildings.visible=false
