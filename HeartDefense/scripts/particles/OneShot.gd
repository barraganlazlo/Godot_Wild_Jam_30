extends Particles2D


func _ready() -> void:
	one_shot = true
	emitting = true

func set_emitting(value: bool):
	emitting = value
	if !emitting:
		queue_free()
