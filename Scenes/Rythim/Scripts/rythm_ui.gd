extends Control

@export var conductor: Node 
@export var player: Player
@export var note_scene: PackedScene

@export var approach_beats: float = 2.0
var last_spawned_beat: int = 0

@onready var center_pos = $CenterSpawnPoint.global_position
@onready var left_spawn_pos = $LeftSpawnPoint.global_position 
@onready var right_spawn_pos = $RightSpawnPoint.global_position

@onready var beat_indicator = $BeatIndicator
@onready var beat_sprite = $Sprite2D
@onready var right_progress_bar = $right_progress_bar
@onready var left_progress_bar = $left_progress_bar
@onready var health_bar = $HBoxContainer

func _ready() -> void:
	if conductor:
		conductor.beat_hit.connect(_on_conductor_beat_hit)
		last_spawned_beat = int(conductor.song_position_in_beats)
	
	right_progress_bar.max_value = 1.0
	left_progress_bar.max_value = 1.0

func _process(_delta: float) -> void:
	if not conductor or not conductor.is_active:
		return
	
	var beat_progress = fmod(conductor.song_position_in_beats, 1.0)
	var time_left_visual = 1.0 - beat_progress
	left_progress_bar.value = time_left_visual
	right_progress_bar.value = time_left_visual
	
	_handle_note_spawning()

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
	_handle_beat_logic()

func _handle_beat_logic():

	if player.is_hopping:
		# SUCCESS CASE
		AudioAutoloader.playPerfectSound()
		_flash_indicator(Color.GREEN)

	else:
		# FAILURE / IDLE CASE
		GameStates.reset_multiplier()
		_flash_indicator(Color.RED)


func _flash_indicator(color: Color):
	beat_indicator.color = color
	beat_sprite.frame_coords = Vector2(1, 0)
	
	await get_tree().create_timer(0.1).timeout
	
	beat_indicator.color = Color.WHITE
	beat_sprite.frame_coords = Vector2(0, 0)

func update_hp():
	print("Updating HP")
	var current_lives: int = GameStates.player_lives

	for i in range(health_bar.get_child_count()):
		var heart_icon = health_bar.get_child(i)
		heart_icon.visible = i < current_lives
