extends KinematicBody2D

const PLANTED_ARROW :=preload("res://Scenes/Weapons/Arrow/PlantedArrow.tscn")

onready var delete_timer=$DeleteTimer

var bong_sound_effects :=[
	preload("res://Sounds/bong.wav"),
	preload("res://Sounds/bong2.wav"),
	preload("res://Sounds/bong3.wav"),
	preload("res://Sounds/bong4.wav")
]

const SOUND_AUTO_DELETE = preload("res://Scenes/SoundAutoDelete.tscn")

var velocity := Vector2(0,0)
var gravity:=0.005
var damage: int = 1
func _ready()->void:
	set_physics_process(false)

func _physics_process(delta:float)->void:
	velocity*=1-gravity
	var collision=move_and_collide(velocity*delta)
	rotation=velocity.angle()
	if collision!=null :
		var body = collision.collider
		if body.is_in_group("Enemy"):
			var planted_arrow=PLANTED_ARROW.instance()
			planted_arrow.rotation=rotation
			body.add_child(planted_arrow)
			var random_pos = Vector2((randi()%10) - 6, (randi()%10) - 6)
			planted_arrow.global_position=body.global_position + random_pos
			var knockback_force = 150
			var knockback = global_position.direction_to(body.global_position) * knockback_force
			body.take_damage(damage, knockback)
			queue_free()
		else:
			velocity=velocity.bounce(collision.normal)
			velocity*= 0.2 +rand_range(-0.025,0.025)
			delete_timer.start()
			collision_mask=0
			play_sound(bong_sound_effects[randi()%bong_sound_effects.size()])

func launch(init_velocity : Vector2, proj_damage)->void:
	damage = proj_damage
	velocity=init_velocity
	set_physics_process(true)
	
func play_sound(s):
	var sound=SOUND_AUTO_DELETE.instance()
	get_tree().get_root().add_child(sound)
	sound.global_position=global_position
	sound.play_sound(s)

func _on_Timer_timeout():
	pass # Replace with function body.


func _on_DeleteTimer_timeout():
	queue_free()
