extends LevelState

func enter(previous_state_path: String, data := {}) -> void:
	#print("Game Started") #debugging only
	pass

func update(_delta: float) -> void:
	if level.current_cleared_cube >= level.target_cleared_cube:
		finished.emit(LEVEL_CLEARED)
		return
