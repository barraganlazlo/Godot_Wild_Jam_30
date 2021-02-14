extends Node
onready var room_tile_size: Vector2 = Vector2(40.0,27.5)
onready var room_pixel_size: Vector2 = room_tile_size * 16.0

func _ready() -> void:
	var heart_building = $YSort/Building
	heart_building.connect("heart_beat", self, "heart_beat")


func heart_beat():
	$CanvasLayer/AnimationPlayer.current_animation = "Pulse"
	$CanvasLayer/AnimationPlayer.play("Pulse")
