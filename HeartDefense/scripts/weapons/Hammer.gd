extends Sprite

onready var animation_player:=$AnimationPlayer
onready var main:= get_node("/root/Main")

export var is_active:=true
export var can_build:=true
var build_position_is_empty:=true

const FREE_COLOR := Color(0,0,1,0.75)
const OCCUPIED_COLOR := Color(1,0,0,0.75)
const MIN_TILE_POSITION := Vector2(1,2)
const MAX_TILE_POSITION := Vector2(38,21)

var last_tile_preview_position:=Vector2(-1,-1)

var current_building:=0


func _process(_delta:float)-> void:
	if !is_active :
		return
	
	var tile_preview_position=main.buildings.world_to_map(get_global_mouse_position())
	
	
	#ensure that tile_preview_position is inside the map
	if(tile_preview_position.x<MIN_TILE_POSITION.x):
		tile_preview_position.x=MIN_TILE_POSITION.x
	if(tile_preview_position.y<MIN_TILE_POSITION.y):
		tile_preview_position.y=MIN_TILE_POSITION.y
	if(tile_preview_position.x>MAX_TILE_POSITION.x):
		tile_preview_position.x=MAX_TILE_POSITION.x
	if(tile_preview_position.y>MAX_TILE_POSITION.y):
		tile_preview_position.y=MAX_TILE_POSITION.y
	
	#update preview collision position
	main.preview_collision.global_position=Vector2(8,8) + main.buildings.map_to_world(tile_preview_position)
	
	#check if the tile where the preview is is free
	var tile_preview_is_free=main.buildings.get_cellv(tile_preview_position)==-1
	#check if the if there are enemies or the player on the preview tile
	if(main.preview_collision):
		tile_preview_is_free=tile_preview_is_free && main.preview_collision.get_overlapping_bodies().size()==0
	
	#update the preview_tile 
	if(last_tile_preview_position!=tile_preview_position):
		main.preview_buildings.set_cellv(last_tile_preview_position,-1)
		main.preview_buildings.set_cellv(tile_preview_position,0)
		last_tile_preview_position=tile_preview_position
	
	if(tile_preview_is_free):
		#upate the color of the preview
		main.preview_buildings.modulate=FREE_COLOR
		#Build if it's posible
		if (can_build && Input.is_action_pressed("shoot")) :
			animation_player.play("Build")
			main.buildings.set_cellv(tile_preview_position,0)
			main.buildings.update_bitmask_area(tile_preview_position)
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
