extends StaticBody2D

onready var hp: int = 10 setget set_hp

func set_hp(value: int):
	hp = value
	if hp <= 0:
		queue_free()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
