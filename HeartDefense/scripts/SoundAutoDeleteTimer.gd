extends AudioStreamPlayer2D

func play_sound(sound):
	stream=sound
	play()

func _on_SoundAutoDelete_finished():
	queue_free()
