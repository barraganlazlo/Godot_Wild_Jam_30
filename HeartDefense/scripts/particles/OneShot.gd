extends Particles2D


func _ready() -> void:
	one_shot = true
	emitting = true
	var timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "destroy")
	timer.wait_time = lifetime + 0.15
	timer.start()


func destroy():
	queue_free()
