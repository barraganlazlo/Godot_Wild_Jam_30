extends Area2D

onready var target: Vector2 = Vector2.ZERO
onready var speed: float
onready var damage: int = 1
onready var coming_up : bool = true
onready var distance : float = 0.0
onready var tween : Tween 

func _ready() -> void:
	$CollisionShape2D.disabled = true

func launch(dist, spd, dam) -> void:
	distance = dist
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
	var airborne_alpha = (1.0 / airborne_scale)
# warning-ignore:return_value_discarded
	tween.stop_all()
	if coming_up:
# warning-ignore:return_value_discarded
		tween.interpolate_property($Sprite, "scale", 
		Vector2(1,1),Vector2(airborne_scale, airborne_scale), 
		tween_speed_selected, tween_trans, Tween.EASE_OUT)
		
# warning-ignore:return_value_discarded
		tween.interpolate_property($Sprite, "modulate", 
		Color(1, 1, 1, 1), Color(1, 1, 1, airborne_alpha), 
		tween_speed_selected, tween_trans, Tween.EASE_OUT)
	else:
# warning-ignore:return_value_discarded
		tween.interpolate_property($Sprite, "scale", 
		Vector2(airborne_scale,airborne_scale),Vector2(1, 1), 
		tween_speed_selected, tween_trans, Tween.EASE_IN)
		
# warning-ignore:return_value_discarded
		tween.interpolate_property($Sprite, "modulate", 
		Color(1, 1, 1, airborne_alpha), Color(1, 1, 1, 1), 
		tween_speed_selected, tween_trans, Tween.EASE_IN)
# warning-ignore:return_value_discarded
	tween.start()


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
	var knockback = global_position.direction_to(body.global_position) * knockback_force
	body.take_damage(damage, knockback)


func _on_Delete_timeout() -> void:
	queue_free()
