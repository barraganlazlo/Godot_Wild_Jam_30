extends VBoxContainer

onready var total_time: float
onready var remaining_time: float
onready var incoming_wave: int = 0
onready var spawning_in: bool = true
func _ready():
	modulate = Color(1.0,1.0,1.0,0.0)

func init(new_total_time: float, wave: int) -> void:
	total_time = new_total_time
	incoming_wave = wave
	$Label.text = ("Wave " + str(wave))
	$Timer.wait_time = total_time
	$Timer.start()
	$Tween.interpolate_property(self, "modulate", Color(1.0,1.0,1.0,0.0), Color(1.0, 1.0, 1.0, 1.0), 1.0, Tween.TRANS_CUBIC, Tween.EASE_IN)
	$Tween.start()

func _process(_delta: float) -> void:
	remaining_time = $Timer.time_left
	$WaveTimer.value = 360 * (1 - (remaining_time/total_time))

func _on_Timer_timeout() -> void:
	set_process(false)
	$WaveTimer.value = 360
	$Tween.interpolate_property(self, "modulate", Color(1.0,1.0,1.0,1.0), Color(1.0, 1.0, 1.0, 0.0), 1.0, Tween.TRANS_CUBIC, Tween.EASE_IN)
	$Tween.start()

func _on_Tween_tween_all_completed() -> void:
	if spawning_in == false:
		queue_free()
	spawning_in = false
