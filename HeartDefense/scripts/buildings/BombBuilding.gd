extends "res://scripts/buildings/Building.gd"

onready var nearest_targets: Array = []
onready var attach = $Base/Attach
onready var ysort = get_tree().get_nodes_in_group("ysort").front()

onready var proj_spd = 10
onready var proj_damage = 2



const AutoDeleteSong =preload("res://Scenes/SoundAutoDelete.tscn")

func _ready():
	hp = Global.building_types["bomb"][0]
	proj_damage = Global.building_types["bomb"][1]
	proj_spd = Global.building_types["bomb"][2]

func anticipate_heart_beat() -> void:
	if !nearest_targets.empty():
		attach.animation = "Anticipate"
	else:
		attach.animation = "Idle"

# Called from animationPlayer
# emits a signal to fire the players and buildings weapons
func heart_beat() -> void:
	if !nearest_targets.empty():
		attach.animation = "Fire"
		var i = randi() % nearest_targets.size()
		create_proj(nearest_targets[i].global_position)
	else:
		attach.animation = "Idle"


func create_proj(target_pos):
	var inst = load("res://Scenes/Weapons/Arrow/FlyingBomb.tscn")
	var bomb = inst.instance()
	ysort.add_child(bomb)
	bomb.global_position=attach.global_position
	bomb.launch(target_pos, proj_spd, proj_damage)
	
	var sound = AutoDeleteSong.instance()
	ysort.add_child(sound)
	sound.play_sound(load("res://Sounds/tomb.wav"), 3.0, 0.7)


func _on_Area2D_body_entered(body) -> void:
	nearest_targets.append(body)

func _on_Area2D_body_exited(body) -> void:
	if nearest_targets.has(body):
		nearest_targets.erase(body)


func _on_Attach_animation_finished() -> void:
	if attach.animation == "Fire":
		attach.animation = "Idle"
