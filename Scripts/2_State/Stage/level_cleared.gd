extends StageState

var player: Player

func enter(previous_state_path: String, data := {}) -> void:
	get_tree().paused = true
	GameStates.game_start = false
	level.level_cleared_menu.visible = true
	level.conductor.stop_music()
	#player.has_moved = false
	#print("You Win")
