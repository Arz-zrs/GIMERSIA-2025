extends LevelState

func enter(previous_state_path: String, data := {}) -> void:
	get_tree().paused = true
	await get_tree().create_timer(1.2).timeout
	
	
	level.game_over_menu.visible = true
	print("You Lose")
