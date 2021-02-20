extends Sprite

onready var animation_player:=$AnimationPlayer
onready var audio_stream_player:=$AudioStreamPlayer2D
onready var ysort = get_tree().get_nodes_in_group("ysort").front()
export var can_shoot=true
export var is_active=true

var arrow_speed=800
const ARROW := preload("res://Scenes/Weapons/Arrow/FlyingArrow.tscn")
var bow_release_sounds := [
	preload("res://Sounds/Bow release 1.wav"),
	preload("res://Sounds/Bow release 2.wav")
]

func _process(_delta:float)-> void:
	if !is_active :
		return

	if can_shoot && Input.is_action_pressed ("shoot") :
		audio_stream_player.play()
		audio_stream_player.stream=bow_release_sounds[randi()%bow_release_sounds.size()]
		animation_player.play("Shoot")
		var arrow=ARROW.instance()
		ysort.add_child(arrow)
		Global.level_stats[Global.STATS.ARROWS_SHOT] += 1
		arrow.global_position=global_position
		var direction=(get_global_mouse_position()- global_position).normalized()
		print("shoot : ",direction)
		var player_arrow_damage = Global.player_type[0]
		arrow.launch(direction*arrow_speed, player_arrow_damage)
		
func activate():
	is_active=true
	visible=true

func desactivate():
	is_active=false
	visible=false
