extends KinematicBody2D

export var speed = 100
onready var sprite= get_node("Sprite")
# keyboard or joystick input to move the player
var input_direction : Vector2

var velocity 

func _process(_delta):
	input_direction = Vector2.ZERO
	#input is check on process called more often than physics so we don't miss any
	input_direction.x= Input.get_action_strength("right") - Input.get_action_strength("left")
	input_direction.y= Input.get_action_strength("down") - Input.get_action_strength("up")
	var pos_relative_to_mouse=get_viewport().get_mouse_position() - global_position
	if input_direction != Vector2.ZERO:
		print("physics : ",input_direction)
	
	if pos_relative_to_mouse.x>0 :
		sprite.flip_h=false
	elif pos_relative_to_mouse.x<0 :
		sprite.flip_h=true

func _physics_process(_delta):
	#nomalize so the player is not faster when he moves diagonaly
	var movement = input_direction.normalized() * speed
	move_and_slide(movement)
