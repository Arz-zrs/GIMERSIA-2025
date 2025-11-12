extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	if GameStates.player_lives > 0:
		GameStates.player_lives -= 1
		player.world.rythim_manager.update_hp()
		finished.emit(RESPAWNING)
	else:
		print("Game Over")
