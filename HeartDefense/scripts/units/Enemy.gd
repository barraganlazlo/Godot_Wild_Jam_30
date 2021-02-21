extends "res://scripts/units/Unit.gd"

onready var main: Node2D = get_tree().get_nodes_in_group("main").front()
onready var damage: int = 1
onready var ysort = get_tree().get_nodes_in_group("ysort").front()

func init(sprite_string: String = "ogre", spd: float = 100.0, anim_spd: float = 2.25, new_hp: int = 10):
	.init(sprite_string, spd, anim_spd, new_hp)
	destination = find_nearest()
	sleep(0.4)
	if type == "orc_shaman":
		$Special.wait_time = 5.0
		$Special.start()

func take_damage(value: int, knockback: Vector2)-> void:
	.take_damage(value, knockback)
	velocity += knockback * Global.enemy_types[type][Global.ENEMY.KNOCKBACK_RES]

func sleep(time):
	set_physics_process(false)
	$WakeUp.stop()
	$WakeUp.wait_time = time
	$WakeUp.start()

func _physics_process(delta: float) -> void:
	._physics_process(delta)
	if global_position.distance_to(destination) <= 3.0:
		destination = find_nearest()
	set_flip(direction)

func _ready():
	add_to_group("Enemy")

func hp_reduced():
	.hp_reduced()
	var move_s = Global.enemy_types[type][Global.ENEMY.SPD]
	var anim_s = Global.enemy_types[type][Global.ENEMY.ANIM_SPD]
	var max_hp = Global.enemy_types[type][Global.ENEMY.HP]
	var weak_ratio = float(hp) / float(max_hp) 
	set_move_spd(weak_ratio * move_s)
	set_animation_spd(weak_ratio * anim_s)

func hp_depleted():
	.hp_depleted()
	var enemy_chance = Global.enemy_types[type][Global.ENEMY.MONEY_CHANCE]
	var chance = rand_range(0, 1)
	if chance < enemy_chance:
		var money_amount = Global.enemy_types[type][Global.ENEMY.MONEY]
		var inst = load("res://Scenes/Wave/Coin.tscn")
		var coin
		var ran_pos: Vector2
		for i in money_amount:
			ran_pos = Vector2((randi() % 10) - 5,(randi() % 10) - 5)
			# Spawn coins
			coin = inst.instance()
			ysort.add_child(coin)
			coin.global_position = global_position + ran_pos
			coin.init()
	

func find_nearest()-> Vector2:
	var list_of_buildings = get_tree().get_nodes_in_group("Building")
	var nearest_pos: Vector2 = get_tree().get_nodes_in_group("Heart_Building").front().global_position
	for i in list_of_buildings:
		if global_position.distance_to(i.global_position) < global_position.distance_to(nearest_pos):
			nearest_pos = i.global_position
	return nearest_pos


func _on_HurtBox_body_entered(body) -> void:
	var knockback_force = 10.0
	var knockback = global_position.direction_to(body.global_position) * knockback_force
	var old_hp = hp
	set_hp(old_hp - body.hp)
	body.take_damage(old_hp, knockback)


func _on_WakeUp_timeout() -> void:
	set_physics_process(true)


func _on_Special_timeout() -> void:
	if type == "orc_shaman":
		sleep(1.0)
		var pos: Vector2 = global_position
		var dir: Vector2 = direction * 25
		pos += dir
		main.create_enemy(pos, "skelet")
		var inst = load("res://Scenes/Particles/Magic.tscn")
		var magic = inst.instance()
		ysort.add_child(magic)
		magic.global_position = pos
