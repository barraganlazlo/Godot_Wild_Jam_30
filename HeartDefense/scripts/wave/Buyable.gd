extends Area2D

enum UPGRADE {
	ARROW_DAMAGE,
	ATTACK_SPEED,
	SPEAR
	PASSIVE_INCOME,
	HP
}
onready var type: int = UPGRADE.ARROW_DAMAGE
onready var cost: int = 1
onready var tween_up: bool = true
onready var flashing: bool = false

func init(new_type, new_cost) -> void:
	type = new_type
	cost = new_cost
	$Label.text = str(cost)
	$Timer.start()
	
	var res: String
	if (type == UPGRADE.ARROW_DAMAGE):
		res = "res://Sprites/weapons/bow/weapon_bow1.png"
	elif (type == UPGRADE.ATTACK_SPEED):
		res = "res://Sprites/weapons/bow/weapon_bow2.png"
	elif (type == UPGRADE.SPEAR):
		res = "res://Sprites/buildings/spear/building_spear_weapon1.png"
	elif (type == UPGRADE.PASSIVE_INCOME):
		res = "res://Sprites/coin/coin_anim_f0.png"
	elif (type == UPGRADE.HP):
		res = "res://Sprites/buildings/building_base.png"
	$Sprite.texture = load(res)

func tween():
	$Tween.stop(self, "position")
	var spd = 1.5
	var tran = Tween.TRANS_CUBIC
	var eas = Tween.EASE_OUT
	if tween_up:
		$Tween.interpolate_property(self, "position", position, position+Vector2(0,5), spd, tran, eas)
	else:
		$Tween.interpolate_property(self, "position", position, position-Vector2(0,5), spd, tran, eas)
	tween_up = !tween_up
	$Tween.start()

func _on_Buyable_body_entered(body: Node) -> void:
	if Global.player_type[Global.PLAYER.MONEY] >= cost:
		Global.update_coins(-cost)
		var inst = load("res://Scenes/Particles/Magic.tscn")
		var magic = inst.instance()
		get_tree().get_nodes_in_group("ysort").front().add_child(magic)
		magic.global_position = global_position
		queue_free()
		give_reward()

func give_reward():
	if (type == UPGRADE.ARROW_DAMAGE):
		Global.player_type[Global.PLAYER.DAMAGE] += 1
	elif (type == UPGRADE.ATTACK_SPEED):
		Global.player_type[Global.PLAYER.ATTACK_SPEED] *= 1.2
	elif (type == UPGRADE.SPEAR):
		Global.building_types["spear"][Global.BUILDING.DAMAGE] += 1
		Global.building_types["bomb"][Global.BUILDING.DAMAGE] += 1
	elif (type == UPGRADE.PASSIVE_INCOME):
		Global.passive_money += 1
	elif (type == UPGRADE.HP):
		Global.building_types["spear"][Global.BUILDING.HP] += 1
		Global.building_types["bomb"][Global.BUILDING.HP] += 1
		Global.building_types["wall"][Global.BUILDING.HP] += 1


func _on_Timer_timeout() -> void:
	if !flashing:
		flashing = true
		$Tween.interpolate_property(self, "modulate", modulate, 
			Color(1.0, 1.0, 1.0, 0.0), 5.0, Tween.TRANS_CIRC, Tween.EASE_IN)
		$Tween.start()
		$Timer.wait_time = 5.0
		$Timer.start()
	else:
		queue_free()
