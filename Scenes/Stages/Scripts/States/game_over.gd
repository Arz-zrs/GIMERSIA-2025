extends LevelState

func enter(previous_state_path: String, data := {}) -> void:
	get_tree().paused = true
	level.game_over_menu.visible = true
	print("You Lose")
