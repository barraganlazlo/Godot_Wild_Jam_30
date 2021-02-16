extends KinematicBody2D


var velocity := Vector2(0,0)
var gravity:=0.005

func _ready():
	set_physics_process(false)

func _physics_process(delta):
	velocity*=1-gravity
	var collision=move_and_collide(velocity*delta)
	if collision!=null :
		if collision.collider.is_in_group("Enemies"):
			#todo damage enemy
			velocity=Vector2.ZERO
			queue_free()
		else:
			velocity=velocity.bounce(collision.normal)
			velocity*= 0.2 +rand_range(-0.025,0.025)
			yield(get_tree().create_timer(1.0), "timeout")
			queue_free()
			
	rotation=velocity.angle()

func launch(init_velocity : Vector2):
	velocity=init_velocity
	set_physics_process(true)
	
