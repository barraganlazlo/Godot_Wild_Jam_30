extends "res://entities/entity/StateTemplate.gd"

onready var air_speed : float = 250.0
onready var coming_up : bool = true
onready var distance : float = 0.0
onready var tween : Tween 

func enter():
	tween = Tween.new()
	add_child(tween)
# warning-ignore:return_value_discarded
	tween.connect("tween_all_completed", self, "tween_completed")
	coming_up = true
	
	var mouse_position = owner.get_global_mouse_position()
	distance = mouse_position.distance_to(owner.global_position)
	set_airborne(coming_up, distance)

func set_airborne(_coming_up := true, _distance := 0.0) -> void:
	var tween_speed_selected : float = ((distance + 1.0) / air_speed) / 2.0
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
		if has_node("Tween"):
			$Tween.queue_free()
		emit_signal("finished", "idle")

func step(_delta):
	# Keep within bounds
	pass


func exit():
	if has_node("Tween"):
		$Tween.queue_free()
