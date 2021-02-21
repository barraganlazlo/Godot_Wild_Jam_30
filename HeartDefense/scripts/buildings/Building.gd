extends StaticBody2D

onready var hp: int = 10 setget set_hp
onready var attack_damage: int = 1

# Ignore this variable \/
onready var list_of_obj_types: Array = []

func _ready()->void:
	Global.level_stats[Global.STATS.BUILDINGS_BUILT] += 1
	add_to_group("Building")
	print("building")

func take_damage(value: int, _position: Vector2)-> void:
	set_hp(hp-value)


func set_hp(value: int):
	hp = value
	if hp <= 0:
		hp_depleted()
	else:
		hp_reduced()

func hp_depleted():
	var inst = load("res://Scenes/Particles/Bomb.tscn")
	var particle = inst.instance()
	particle.global_position = global_position
	get_tree().get_nodes_in_group("ysort").front().add_child(particle)
	get_tree().get_nodes_in_group("camera").front().shake(0.5, 0.4)
	queue_free()

func hp_reduced():
	var timer
	if has_node("FlashTimer"):
		timer = get_node("FlashTimer")
	else: 
		var inst = load("res://shaders/FlashTimer.tscn")
		timer = inst.instance()
		add_child(timer)
		timer.name = "FlashTimer"
	timer.init(0.25)


func init(new_hp: int = 10, new_damage: int = 1) -> void:
	set_hp(new_hp)
	attack_damage = new_damage


func set_shader(value):
	var inst = null
	if value != null:
		inst = load(value)
	list_of_obj_types = []
	deep_search(self, Sprite)
	for i in list_of_obj_types:
		i.material = inst

func deep_search(object, node_type):
	if object is node_type:
		list_of_obj_types.append(object)
	if object.get_child_count() != 0:
		for i in object.get_children():
			deep_search(i, node_type)




