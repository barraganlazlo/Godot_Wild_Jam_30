extends Sprite


onready var animation_player=$AnimationPlayer

export var can_shoot=true
export var is_active=true

func _process(_delta:float)-> void:
	if !is_active :
		return

	if can_shoot && Input.is_action_just_pressed ("shoot") :
		animation_player.play("Shoot")
		print("shoot")
