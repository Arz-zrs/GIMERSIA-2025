extends LevelState

func enter(previous_state_path: String, data := {}) -> void:
	level.conductor.start_music()

func handle_input(_event: InputEvent) -> void:
	if _event.is_pressed():
		finished.emit(PLAYING)
