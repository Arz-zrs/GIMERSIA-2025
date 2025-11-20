extends Node

signal player_turn_taken(move_dir: Vector2i)
signal player_spawn_finished

@export var pause_menu_scene: PackedScene

var pause_menu_instance: CanvasLayer

func _ready():
	if pause_menu_scene:
		pause_menu_instance = pause_menu_scene.instantiate()
		get_tree().get_root().add_child.call_deferred(pause_menu_instance)
		pause_menu_instance.resume_pressed.connect(_resume)
		pause_menu_instance.hide()
	else:
		push_error("TurnManager: PauseMenu.tscn has not been assigned!")

func pause():
	get_tree().paused = true
	if pause_menu_instance:
		pause_menu_instance.show()

func _resume():
	get_tree().paused = false
	if pause_menu_instance:
		pause_menu_instance.hide()
