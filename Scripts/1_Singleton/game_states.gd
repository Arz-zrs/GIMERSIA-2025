extends Node

## SINGLETON / AUTOLOAD
var game_over: bool = false

var score: int = 0
var multiplier: int = 1
var consecutive_jumps: int = 0
var on_ride_disc: bool = false
var player_lives: int = 3
var game_turn: int = 0

var levels: Array[String] = [
	"res://Scenes/Stages/1_Tutorial/tutorial_1.tscn",
	"res://Scenes/Stages/2_Tutorial/tutorial_2.tscn",
	"res://Scenes/Stages/3_Tutorial/tutorial_3.tscn",
	"res://Scenes/Stages/1_Stage/stage_1.tscn",
	"res://Scenes/Stages/2_Stage/stage_2.tscn",
	"res://Scenes/Stages/3_Stage/stage_3.tscn",
]

@onready var scene_main_menu = preload("res://Scenes/user_interface/menu/main_menu.tscn")
@onready var scene_level_selector = preload("res://Scenes/user_interface/level_selection/level_selection.tscn")

signal game
signal player_turn_taken(move_dir: Vector2i)
signal player_spawn_finished
signal score_updated(new_score)
signal multiplier_updated(new_multiplier)

const POINTS_PER_JUMP = 10
const JUMPS_FOR_MULTIPLIER = 5

func load_next_level():
	var current_scene_file = get_tree().current_scene.scene_file_path
	var current_index = levels.find(current_scene_file)
	if current_index != -1:
		var next_index = current_index + 1
		if next_index < levels.size():
			var next_level_path = levels[next_index]
			get_tree().change_scene_to_file(next_level_path)
		else:
			print("Final level check")
	else:
		push_error("Current level not found in GameStates.levels list!")

func add_score():
	score += POINTS_PER_JUMP * multiplier
	score_updated.emit(score)
	
	consecutive_jumps += 1
	if consecutive_jumps % JUMPS_FOR_MULTIPLIER == 0:
		_increment_multiplier()

func reset_multiplier():
	multiplier = 1
	consecutive_jumps = 0
	multiplier_updated.emit(multiplier)

func _increment_multiplier():
	multiplier += 1
	multiplier_updated.emit(multiplier)

func reset_game_stats():
	score = 0
	multiplier = 1
	consecutive_jumps = 0
	player_lives = 3
	game_turn = 0
	game_over = false
	score_updated.emit(score)
	multiplier_updated.emit(multiplier)
