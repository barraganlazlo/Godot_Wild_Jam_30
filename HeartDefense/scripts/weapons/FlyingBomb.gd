extends Area2D

onready var target: Vector2 = Vector2.ZERO
onready var speed: float
onready var damage: int = 1
onready var coming_up : bool = true
onready var distance : float = 0.0
onready var target_pos: Vector2 = Vector2.ZERO
onready var tween : Tween 
onready var heart_build_pos = get_tree().get_nodes_in_group("Heart_Building").front().global_position

var bomb_sound_effect :=preload("res://Sounds/bomb.wav")

const SOUND_AUTO_DELETE = preload("res://Scenes/SoundAutoDelete.tscn")


func _ready() -> void:
	$CollisionShape2D.disabled = true

func launch(target, spd, dam) -> void:
	var dir = heart_build_pos.direction_to(target) * 16
	target_pos = target - dir
	distance = global_position.distance_to(target_pos)
	speed = spd
	damage = dam
	tween = Tween.new()
	add_child(tween)
# warning-ignore:return_value_discarded
	tween.connect("tween_all_completed", self, "tween_completed")
	coming_up = true
	set_airborne(coming_up, distance)


func set_airborne(_coming_up := true, _distance := 0.0) -> void:
	var tween_speed_selected : float = ((distance + 1.0) / speed) / 2.0
	var tween_trans = Tween.TRANS_CUBIC
	var airborne_scale : float = clamp(pow(tween_speed_selected + 1.0,2),1.0,4.0)
	var airborne_alpha = (1.0 / airborne_scale) / 2.0
# warning-ignore:return_value_discarded
	tween.stop_all()
	if coming_up:
# warning-ignore:return_value_discarded
		tween.interpolate_property($AnimatedSprite, "scale", 
		Vector2(1,1),Vector2(airborne_scale, airborne_scale), 
		tween_speed_selected, tween_trans, Tween.EASE_OUT)
		
# warning-ignore:return_value_discarded
		tween.interpolate_property($AnimatedSprite, "modulate", 
		Color(1, 1, 1, 1), Color(1, 1, 1, airborne_alpha), 
		tween_speed_selected, tween_trans, Tween.EASE_OUT)
		
# warning-ignore:return_value_discarded
		tween.interpolate_property(self, "global_position", 
		global_position, (global_position + target_pos)/2, 
		tween_speed_selected, tween_trans, Tween.EASE_IN)
	else:
# warning-ignore:return_value_discarded
		tween.interpolate_property($AnimatedSprite, "scale", 
		Vector2(airborne_scale,airborne_scale),Vector2(.5, .5), 
		tween_speed_selected, tween_trans, Tween.EASE_IN)
		
# warning-ignore:return_value_discarded
		tween.interpolate_property($AnimatedSprite, "modulate", 
		Color(1, 1, 1, airborne_alpha), Color(1, 1, 1, 0.8), 
		tween_speed_selected, tween_trans, Tween.EASE_IN)
		
# warning-ignore:return_value_discarded
		tween.interpolate_property(self, "global_position", 
		global_position, target_pos, 
		tween_speed_selected, tween_trans, Tween.EASE_OUT)
	tween.start()

func play_sound(s,volume=0):
	var sound=SOUND_AUTO_DELETE.instance()
	get_tree().get_root().add_child(sound)
	sound.global_position=global_position
	sound.play_sound(s, volume)

func tween_completed():
	if coming_up:
		coming_up = false
		set_airborne(coming_up, distance)
	else:
		$CollisionShape2D.disabled = false
		$Delete.wait_time = 0.25
		$Delete.start()


func _on_FlyingBomb_body_entered(body) -> void:
	var knockback_force = 300
	var knockback = heart_build_pos.direction_to(global_position) * knockback_force
	body.take_damage(damage, knockback)


func _on_Delete_timeout() -> void:
	var inst = load("res://Scenes/Particles/FlyingBomb.tscn")
	var particle = inst.instance()
	play_sound(bomb_sound_effect)
	get_tree().get_nodes_in_group("ysort").front().add_child(particle)
	particle.global_position = global_position
	queue_free()
