extends Node
onready var room_tile_size: Vector2 = Vector2(40.0,27.5)
onready var room_pixel_size: Vector2 = room_tile_size * 16.0

onready var heart_building:= $YSort/HeartBuilding
onready var player:= $YSort/Player
onready var buildings:= $YSort/Buildings

func _ready() -> void: 
	heart_building.connect("heart_beat", self, "heart_beat")

func heart_beat():
	$CanvasLayer/AnimationPlayer.current_animation = "Pulse"
	$CanvasLayer/AnimationPlayer.play("Pulse")
