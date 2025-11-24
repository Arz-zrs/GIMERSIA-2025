extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	finished.emit(RESPAWNING)
