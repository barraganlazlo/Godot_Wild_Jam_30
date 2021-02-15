extends Sprite

onready var animation_player:=$AnimationPlayer
onready var main:= get_tree().get_root().get_node("Main")

export var is_active:=true
export var can_build:=true
var build_position_is_empty:=true

func _process(_delta:float)-> void:
	if !is_active :
		return
	
	if can_build && Input.is_action_just_pressed("shoot") :
		animation_player.play("Build")
		var tile_preview_position=main.buildings.world_to_map(get_global_mouse_position())
		main.buildings.set_cellv(tile_preview_position,0)
		main.buildings.update_bitmask_area(tile_preview_position)
