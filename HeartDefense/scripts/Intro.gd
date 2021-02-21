extends ColorRect

onready var fade_in: bool = true
onready var spd = 0.45
onready var trans = Tween.TRANS_LINEAR
onready var eas = Tween.EASE_IN

func _ready() -> void:
	$Timer.wait_time = 5.0
	$Timer.start()
	$Tween.interpolate_property($ColorRect, "modulate", modulate, Color(1.0, 1.0, 1.0, 0.0), spd, trans, eas)
	$Tween.start()


func _on_Timer_timeout() -> void:
	fade_in = false
	$Tween.interpolate_property($ColorRect, "modulate", Color(1.0, 1.0, 1.0, 0.0), Color(1.0, 1.0, 1.0, 1.0), spd, trans, eas)
	$Tween.start()


func _on_Tween_tween_all_completed() -> void:
	if !fade_in:
		Global.go_to_scene("res://Scenes/Gui/Title.tscn")
