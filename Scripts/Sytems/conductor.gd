extends Node

signal beat_hit(beat_num: int)

## RYTHM STATS
var current_bpm: float = 120.0
var sec_per_beat: float = 0.5
var song_position_in_beats: float = 0.0
var last_reported_beat: int = 0
var is_active: bool = false

@onready var player_audio: AudioStreamPlayer = $AudioStreamPlayer
var current_map: BeatMap

func load_map(map: BeatMap):
	current_map = map
	current_bpm = map.initial_bpm
	sec_per_beat = 60.0 / current_bpm
	song_position_in_beats = 0.0
	last_reported_beat = 0
	player_audio.stream = map.audio_stream

func start_music():
	player_audio.play()
	is_active = true

func stop_music():
	player_audio.stop()
	is_active = false

func _process(delta: float):
	if not is_active: return

	var raw_time = player_audio.get_playback_position() + AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency()
	raw_time -= current_map.offset_seconds
	
	song_position_in_beats += (delta * current_bpm) / 60.0

	if int(song_position_in_beats) > last_reported_beat:
		last_reported_beat = int(song_position_in_beats)
		emit_signal("beat_hit", last_reported_beat)
		_check_for_bpm_change(last_reported_beat)

func _check_for_bpm_change(beat: int):
	if current_map.bpm_changes.has(beat):
		var new_bpm = current_map.bpm_changes[beat]
		_update_bpm(new_bpm)

func _update_bpm(new_bpm: float):
	current_bpm = new_bpm
	sec_per_beat = 60.0 / current_bpm
	print("BPM Changed to: ", current_bpm)
