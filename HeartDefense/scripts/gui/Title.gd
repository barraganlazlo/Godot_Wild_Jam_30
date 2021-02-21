extends Node2D

onready var sprites = $Sprites
onready var layers = [$Sprites/Background, $Sprites/MidGround, 
	$Sprites/ForeGround, $Sprites/HyperForeGround, $Sprites/Corners]
onready var layers_pos = [Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, 
	Vector2.ZERO, Vector2.ZERO]
onready var max_waning_dist = [0, 5, 12, 20, 30]
onready var screen_size = Vector2(640, 376) / 2

onready var green_nine = $Camera2D/VBoxContainer/VBoxContainer/BrownNine/GreenNine
onready var label = $Camera2D/VBoxContainer/VBoxContainer/BrownNine/GreenNine/Label
onready var fading: bool = false

func _ready() -> void:
	for i in layers.size():
		layers_pos[i] = layers[i].global_position

func _process(delta):
	var mouse_loc_ratio = (get_global_mouse_position() - sprites.global_position) / screen_size * -1
	for i in layers.size():
		layers[i].global_position = layers_pos[i] + (mouse_loc_ratio*max_waning_dist[i])


func _on_TextureButton_button_down() -> void:
	green_nine.self_modulate = Color(0.5, 0.5, 0.5, 1.0)


func _on_TextureButton_button_up() -> void:
	green_nine.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
	if !fading:
		fading = true
		$Timer.wait_time = 0.2
		$Timer.start()
		print("Pressed button")


func _on_Timer_timeout() -> void:
	$Tween.interpolate_property($ColorRect, "modulate", $ColorRect.modulate, Color(1.0,1.0,1.0,1.0),
	0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.start()


func _on_Tween_tween_all_completed() -> void:
	print("going to main")
	Global.go_to_scene("res://Scenes/main.tscn")
