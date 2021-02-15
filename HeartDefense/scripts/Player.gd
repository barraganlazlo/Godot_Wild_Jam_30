extends KinematicBody2D

export var speed = 100
# keyboard or joystick input to move the player
var input_direction : Vector2

onready var character_sprite : Sprite =$Character
onready var weapons :=[
	$Character/Weapons/Hammer,
	$Character/Weapons/Bow
]

var current_weapon:=0

func _process(_delta:float)-> void:
	#todo : make an array to store inputs from previous frames so we don't miss any
	#input is check on process called more often than physics 
	input_direction.x= Input.get_action_strength("right") - Input.get_action_strength("left")
	input_direction.y= Input.get_action_strength("down") - Input.get_action_strength("up")
	
	var aim_direction:=get_local_mouse_position()

	if aim_direction.x>0 :
		character_sprite.set_scale(Vector2(1,1))
	elif aim_direction.x<0 :
		character_sprite.set_scale(Vector2(-1,1))
		
	if(Input.is_action_just_pressed("change weapon")):
		var target_weapon:=(current_weapon+1)%weapons.size()
		select(target_weapon)



func _physics_process(_delta :float)-> void:
	#nomalize so the player is not faster when he moves diagonaly
	var movement = input_direction.normalized() * speed
	move_and_slide(movement)

func select(target_weapon)-> void:
	if target_weapon==current_weapon:
		return
	weapons[target_weapon].visible=true
	weapons[target_weapon].is_active=true
	weapons[current_weapon].visible=false
	weapons[current_weapon].is_active=false
	current_weapon=target_weapon
