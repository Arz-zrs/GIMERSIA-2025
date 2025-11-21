extends Node

@onready var hit_sound: AudioStreamPlayer2D = $HitSound
@onready var perfect_sound: AudioStreamPlayer2D = $PerfectSound

func playHitSound():
	hit_sound.play()

func playPerfectSound():
	perfect_sound.pitch_scale = randf_range(0.7, 1.5)
	perfect_sound.play()
