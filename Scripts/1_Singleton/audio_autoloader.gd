extends Node2D

@onready var hit_sound = $HitSound
@onready var perfect_sound = $PerfectSound

func playHitSound():
	hit_sound.play()

func playPerfectSound():
	perfect_sound.pitch_scale = randf_range(0.7, 1.5)
	perfect_sound.play()
