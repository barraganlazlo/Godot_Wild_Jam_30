extends Sprite

onready var animation_player=$AnimationPlayer

export var is_active:=true
export var can_build:=true
var build_position_is_empty:=true

func _process(_delta:float)-> void:
	if !is_active :
		return

	if can_build && Input.is_action_just_pressed("shoot") :
		animation_player.play("Build")
		if(build_position_is_empty):
			print("build")
		else:
			print("build position occupied")
