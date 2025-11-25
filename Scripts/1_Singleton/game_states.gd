extends Node

## SINGLETON / AUTOLOAD
# Enumeration to define the quality of a player's action match with the beat.
enum Match {PERFECT, OK, MISS}

var on_ride_disc: bool = false
var game_turn: int = 0

const levels: Array[String] = [
	"res://Scenes/Stages/tutorial_1.tscn",
	"res://Scenes/Stages/tutorial_2.tscn",
	"res://Scenes/Stages/tutorial_3.tscn",
	"res://Scenes/Stages/stage_1.tscn",
	"res://Scenes/Stages/stage_2.tscn",
	"res://Scenes/Stages/stage_3.tscn",
]

@onready var scene_main_menu = preload("res://Scenes/user_interface/main_menu.tscn")
@onready var scene_level_selector = preload("res://Scenes/user_interface/level_selection.tscn")

signal beat_hit(beat_num: int)
signal player_spawn_finished

const POINTS_PER_JUMP = 10
const JUMPS_FOR_MULTIPLIER = 5
const HIT_WINDOW: float = 0.1
const PERFECT_WINDOW: float = 0.100
const OK_WINDOW: float = 0.250

func load_next_level():
	var current_scene_file = get_tree().current_scene.scene_file_path
	var current_index = levels.find(current_scene_file)
	if current_index != -1:
		var next_index = current_index + 1
		if next_index < levels.size():
			var next_level_path = levels[next_index]
			get_tree().change_scene_to_file(next_level_path)
		else:
			#print("Final level check")
			pass
	else:
		push_error("Current level not found in GameStates.levels list!")

func reset_game_stats():
	game_turn = 0
