extends StaticBody2D

onready var hp: int = 1 setget set_hp
onready var attack_damage: int = 1

# Ignore this variable \/
onready var list_of_obj_types: Array = []

func take_damage(value: int, _position: Vector2)-> void:
	set_hp(hp-value)


func set_hp(value: int):
	print("new hp = %s" % [value])
	hp = value
	if hp <= 0:
		hp_depleted()
	else:
		hp_reduced()

func hp_depleted():
	var inst = load("res://Scenes/Particles/Explode.tscn")
	var particle = inst.instance()
	get_tree().get_root().add_child(particle)

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


func _ready():
	Global.level_stats[Global.STATS.BUILDINGS_BUILT] += 1
	add_to_group("Buildings")

func init(new_hp: int = 10, new_damage: int = 1) -> void:
	set_hp(new_hp)
	attack_damage = new_damage


func set_shader(value):
	var inst = null
	if value != null:
		inst = load(value)
	list_of_obj_types = []
	deep_search(self, Sprite)
	print(list_of_obj_types)
	for i in list_of_obj_types:
		i.material = inst

func deep_search(object, node_type):
	if object.get_child_count() == 0:
		if object is node_type:
			list_of_obj_types.append(object)
	else:
		for i in object.get_children():
			deep_search(i, node_type)




