extends Resource
class_name BeatMap

@export var audio_stream: AudioStream
@export var initial_bpm: float = 70.0
@export var offset_seconds: float = 0.0

## Format {beat_number (int) : bpm (float)}
@export var bpm_changes: Dictionary = {}
