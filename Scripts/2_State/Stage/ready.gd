extends StageState

func enter(previous_state_path: String, data := {}) -> void:
	level.conductor.start_music()

func handle_input(_event: InputEvent) -> void:
	if _event.is_pressed():
		GameStates.game_start = true
		finished.emit(PLAYING)
