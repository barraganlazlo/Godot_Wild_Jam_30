extends AudioStreamPlayer2D

func play_sound(sound, volume:= 0.0, pitch := 1.0):
	stream=sound
	volume_db = volume
	pitch_scale = pitch
	play()

func _on_SoundAutoDelete_finished():
	queue_free()
