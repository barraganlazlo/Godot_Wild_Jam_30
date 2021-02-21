extends AudioStreamPlayer2D

func play_sound(sound, volume:= 0.0):
	stream=sound
	volume_db = volume
	play()

func _on_SoundAutoDelete_finished():
	queue_free()
