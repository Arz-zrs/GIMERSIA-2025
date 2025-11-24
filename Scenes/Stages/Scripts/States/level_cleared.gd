extends LevelState

func enter(previous_state_path: String, data := {}) -> void:
	get_tree().paused = true
	level.level_cleared_menu.visible = true
	level.conductor.stop_music()
	#print("You Win")
