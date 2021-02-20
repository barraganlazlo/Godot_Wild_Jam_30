extends Timer

onready var time

func init(time: float = 0.5) -> void:
	stop()
	get_parent().set_shader("res://shaders/flash.material")
	wait_time = time
	start()

func _on_FlashTimer_timeout() -> void:
	get_parent().set_shader(null)
	queue_free()
