extends CanvasLayer

@export var conductor: Node 
@export var player: Player
@export var note_scene: PackedScene

@export var approach_beats: float = 2.0
var last_spawned_beat: int = 0
var last_processed_beat: int = -1

@onready var center_pos = $CenterSpawnPoint.global_position
@onready var left_spawn_pos = $LeftSpawnPoint.global_position 
@onready var right_spawn_pos = $RightSpawnPoint.global_position

@onready var beat_sprite = $Sprite2D
@onready var right_progress_bar = $right_progress_bar
@onready var left_progress_bar = $left_progress_bar
@onready var health_bar = $HBoxContainer

@onready var left_timing_window = $LTimingWindowIndicator
@onready var right_timing_window = $RTimingWindowIndicator

func _ready() -> void:
	if conductor:
		conductor.beat_hit.connect(_on_conductor_beat_hit)
		last_spawned_beat = int(conductor.song_position_in_beats)
		if conductor.debug_mode:
			left_timing_window.visible = true
			right_timing_window.visible = true
	
	right_progress_bar.max_value = 1.0
	left_progress_bar.max_value = 1.0

func _process(_delta: float) -> void:
	if not conductor or not conductor.is_active:
		return
	
	var beat_progress = fmod(conductor.song_position_in_beats, 1.0)
	var time_left_visual = 1.0 - beat_progress
	left_progress_bar.value = time_left_visual
	right_progress_bar.value = time_left_visual
	
	if player.is_hopping and player.last_hop_beat != last_processed_beat:
		_validate_player_hit()
	
	_handle_note_spawning()

func _validate_player_hit():
	AudioAutoloader.playPerfectSound()
	_beat_indicator()

	last_processed_beat = player.last_hop_beat

func _handle_note_spawning():
	var future_beat = conductor.song_position_in_beats + approach_beats
	
	if int(future_beat) > last_spawned_beat:
		last_spawned_beat = int(future_beat)
		spawn_visual_note(last_spawned_beat)

func spawn_visual_note(target_beat_num: int):
	if not note_scene: return
	
	var note_right = note_scene.instantiate()
	var note_left = note_scene.instantiate()
	add_child(note_right)
	add_child(note_left)
	
	note_right.setup(conductor, target_beat_num, approach_beats, right_spawn_pos, center_pos + Vector2(20, 0))
	note_left.setup(conductor, target_beat_num, approach_beats, left_spawn_pos, center_pos  + Vector2(-20, 0))

func _on_conductor_beat_hit(beat_num: int):
	if player.last_hop_beat < beat_num and !GameStates.on_ride_disc:
		GameStates.reset_multiplier()
		_beat_indicator()

func _beat_indicator():
	beat_sprite.frame_coords = Vector2(1, 0)
	
	await get_tree().create_timer(0.1).timeout
	
	beat_sprite.frame_coords = Vector2(0, 0)

func update_hp():
	#print("Updating HP") # debug only
	var current_lives: int = GameStates.player_lives

	for i in range(health_bar.get_child_count()):
		var heart_icon = health_bar.get_child(i)
		heart_icon.visible = i < current_lives
