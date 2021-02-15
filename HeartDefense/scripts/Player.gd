extends KinematicBody2D

export var speed = 100
# keyboard or joystick input to move the player
var input_direction : Vector2

onready var character_sprite =$Character
onready var bow =$Character/Weapon/Bow
onready var hammer =$Character/Weapon/Hammer

enum Weapon{
	HAMMER, #BUILD
	BOW,
	NUMBER_OF_WEAPONS
}
var current_weapon=Weapon.HAMMER

func _process(_delta:float)-> void:
	#todo : make an array to store inputs from previous frames so we don't miss any
	#input is check on process called more often than physics 
	input_direction.x= Input.get_action_strength("right") - Input.get_action_strength("left")
	input_direction.y= Input.get_action_strength("down") - Input.get_action_strength("up")
	
	var local_mouse_pos=get_local_mouse_position()

	if local_mouse_pos.x>0 :
		character_sprite.set_scale(Vector2(1,1))
	elif local_mouse_pos.x<0 :
		character_sprite.set_scale(Vector2(-1,1))
		
	if(Input.is_action_just_pressed("change weapon")):
		var target_weapon=(current_weapon+1)%Weapon.NUMBER_OF_WEAPONS
		print(Weapon.NUMBER_OF_WEAPONS)
		print(current_weapon)
		print(target_weapon)
		select(target_weapon)



func _physics_process(_delta :float)-> void:
	#nomalize so the player is not faster when he moves diagonaly
	var movement = input_direction.normalized() * speed
	move_and_slide(movement)
	
func unselect(weapon)-> void:
	match weapon:
		Weapon.HAMMER :
			print("unselect hammer")
			hammer.visible=false
			hammer.is_active=false

		Weapon.BOW :
			print("unselect bow")
			bow.visible=false
			bow.is_active=false
			
		_:
			print("error weapon not supported")

func select(target_weapon)-> void:
	if target_weapon==current_weapon:
		return
	unselect(current_weapon)
	current_weapon=target_weapon
	match target_weapon:
		Weapon.HAMMER :
			print("select hammer")
			hammer.visible=true
			hammer.is_active=true
		Weapon.BOW :
			print("select bow")
			bow.visible=true
			bow.is_active=true
		_:
			print("error weapon not supported")
