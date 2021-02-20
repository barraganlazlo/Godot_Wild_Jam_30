extends "res://scripts/units/Unit.gd"

onready var damage: int = 1
onready var ysort = get_tree().get_nodes_in_group("ysort").front()

func init(sprite_string: String = "ogre", spd: float = 100.0, anim_spd: float = 2.25, new_hp: int = 10):
	.init(sprite_string, spd, anim_spd, new_hp)
	destination = find_nearest()
	set_physics_process(false)
	$WakeUp.wait_time = 0.4
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
			print("create coin")
			ran_pos = Vector2((randi() % 10) - 5,(randi() % 10) - 5)
			# Spawn coins
			coin = inst.instance()
			ysort.add_child(coin)
			coin.global_position = global_position + ran_pos
			coin.init()
			print(coin.global_position)
			print(global_position)
	

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
	body.take_damage(damage, knockback)
	hp_depleted()


func _on_WakeUp_timeout() -> void:
	set_physics_process(true)
