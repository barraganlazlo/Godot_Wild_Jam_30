extends Sprite

onready var animation_player:=$AnimationPlayer
onready var main = get_tree().get_nodes_in_group("main").front()
export var can_shoot=true
export var is_active=true

var arrow_speed=800
const ARROW := preload("res://Scenes/Weapons/Arrow/FlyingArrow.tscn")

func _process(_delta:float)-> void:
	if !is_active :
		return

	if can_shoot && Input.is_action_pressed ("shoot") :
		animation_player.play("Shoot")
		var arrow=ARROW.instance()
		main.ysort.add_child(arrow)
		Global.level_stats[Global.STATS.ARROWS_SHOT] += 1
		arrow.global_position=global_position
		var direction=(get_global_mouse_position()- global_position).normalized()
		print("shoot : ",direction)
		arrow.launch(direction*arrow_speed)

func activate():
	is_active=true
	visible=true

func desactivate():
	is_active=false
	visible=false
