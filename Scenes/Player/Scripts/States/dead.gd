extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	if player.lives > 0:
		player.lives -= 1
		finished.emit(RESPAWNING)
	else:
		print("Game Over")
