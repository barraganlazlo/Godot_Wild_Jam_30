extends "res://scripts/buildings/Building.gd"

onready var nearest_targets: Array = []
onready var attach = $Base/Attach
onready var animPlayer = $AnimationPlayer
onready var ysort = get_tree().get_nodes_in_group("ysort").front()

onready var proj_spd = 10
onready var proj_damage = 2

func _ready():
	._ready()
	hp = Global.building_types["spear"][0]
	proj_damage = Global.building_types["spear"][1]
	proj_spd = Global.building_types["spear"][2]
	attach.rotation = rand_range(0, PI * 2)

func anticipate_heart_beat() -> void:
	if !nearest_targets.empty():
		animPlayer.play("Anticipate")
	else:
		animPlayer.play("Idle")

# Called from animationPlayer
# emits a signal to fire the players and buildings weapons
func heart_beat() -> void:
	if !nearest_targets.empty():
		animPlayer.play("Fire")
		create_proj(nearest_targets.front().global_position)
	else:
		animPlayer.play("Idle")


func _process(_delta: float) -> void:
	if !nearest_targets.empty():
		var target_pos = nearest_targets.front().global_position
		var attach_pos = attach.global_position
		attach.rotation = target_pos.angle_to_point(attach_pos)

func create_proj(target_pos):
	var inst = load("res://Scenes/Weapons/Arrow/FlyingSpear.tscn")
	var arrow = inst.instance()
	ysort.add_child(arrow)
	arrow.global_position=attach.global_position
	var direction=(target_pos- global_position).normalized()
	arrow.launch(direction*proj_spd, proj_damage)

func _on_Area2D_body_entered(body) -> void:
	nearest_targets.append(body)

func _on_Area2D_body_exited(body) -> void:
	if nearest_targets.has(body):
		nearest_targets.erase(body)

func heart_beat_done():
	animPlayer.play("Idle")
