extends KinematicBody2D

const PLANTED_ARROW :=preload("res://Scenes/Weapons/Arrow/PlantedArrow.tscn")

onready var delete_timer=$DeleteTimer

var velocity := Vector2(0,0)
var gravity:=0.005
var damages:int=4

func _ready()->void:
	set_physics_process(false)

func _physics_process(delta:float)->void:
	velocity*=1-gravity
	var collision=move_and_collide(velocity*delta)
	if collision!=null :
		if collision.collider.is_in_group("Enemies"):
			var planted_arrow=PLANTED_ARROW.instance()
			planted_arrow.rotation=rotation
			collision.collider.add_child(planted_arrow)
			planted_arrow.global_position=global_position
			collision.collider.take_damage(damages)
			queue_free()
		else:
			velocity=velocity.bounce(collision.normal)
			velocity*= 0.2 +rand_range(-0.025,0.025)
			delete_timer.start()
			collision_mask=0
	rotation=velocity.angle()

func launch(init_velocity : Vector2)->void:
	velocity=init_velocity
	set_physics_process(true)
	


func _on_Timer_timeout():
	pass # Replace with function body.


func _on_DeleteTimer_timeout():
	queue_free()
