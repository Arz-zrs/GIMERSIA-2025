extends Node

## SINGLETON / AUTOLOAD
var game_over: bool = false

var score: int = 0
var multiplier: int = 1
var consecutive_jumps: int = 0
var on_ride_disc: bool = false
var player_lives: int = 3
var game_turn: int = 0

@onready var scene_main_menu = preload("res://Scenes/Stages/menu/main_menu.tscn")
@onready var scene_level_selector = preload("res://Scenes/Stages/level_selection/level_selection.tscn")

signal game
signal score_updated(new_score)
signal multiplier_updated(new_multiplier)

const POINTS_PER_JUMP = 10
const JUMPS_FOR_MULTIPLIER = 5

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
