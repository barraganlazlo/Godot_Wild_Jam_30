extends "res://scripts/units/Unit.gd"

func _ready():
	init("elf_m", 120.0, 2.0)

func init(sprite_string: String = "ogre", spd: float = 100.0, anim_spd: float = 2.25):
	.init(sprite_string, spd, anim_spd)
	destination = get_tree().get_nodes_in_group("heart_building").front().global_position

onready var weapons :=[
	$AnimatedSprite/Weapons/Hammer,
	$AnimatedSprite/Weapons/Bow
]
var current_weapon:=0

func _process(_delta:float)-> void:
	#todo : make an array to store inputs from previous frames so we don't miss any
	#input is check on process called more often than physics 
	if(Input.is_action_just_pressed("change weapon")):
		var target_weapon:=(current_weapon+1) % weapons.size()
		select(target_weapon)



func _physics_process(delta :float)-> void:
	destination = global_position
	var new_destination: Vector2 = Vector2.ZERO
	new_destination.x= Input.get_action_strength("right") - Input.get_action_strength("left")
	new_destination.y= Input.get_action_strength("down") - Input.get_action_strength("up")
	if new_destination == Vector2.ZERO:
		set_animation("Idle")
	else:
		set_animation("Run")
	destination += new_destination
	
	._physics_process(delta)
	var aim_direction:=get_local_mouse_position()
	set_flip(aim_direction)

func select(target_weapon)-> void:
	if target_weapon==current_weapon:
		return
	weapons[target_weapon].activate()
	weapons[current_weapon].desactivate()
#	weapons[target_weapon].visible=true
#	weapons[target_weapon].is_active=true
#	weapons[current_weapon].visible=false
#	weapons[current_weapon].is_active=false
	current_weapon=target_weapon
