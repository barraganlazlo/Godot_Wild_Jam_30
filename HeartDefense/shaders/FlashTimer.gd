extends Timer

onready var time

func init(time: float = 0.5) -> void:
	stop()
	var parent_material = get_parent().material
	get_parent().set_shader("res://shaders/flash.material")
	wait_time = time
	print(time)
	start()

func _on_FlashTimer_timeout() -> void:
	get_parent().set_shader(null)
	queue_free()
