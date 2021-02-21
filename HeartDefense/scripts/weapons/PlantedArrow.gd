extends Sprite

var impacts : Array =[
	preload("res://Sounds/Arrow enemy impact 1.wav"),
	preload("res://Sounds/Arrow enemy impact 2.wav"),
	preload("res://Sounds/Arrow enemy impact 3.wav")
]

const SOUND_AUTO_DELETE = preload("res://Scenes/SoundAutoDelete.tscn")

func _ready():
	var instance=SOUND_AUTO_DELETE.instance()
	get_tree().get_root().add_child(instance)
	instance.global_position=global_position
	instance.play_sound(impacts[randi() % impacts.size()])
