extends LevelState

func enter(previous_state_path: String, data := {}) -> void:
	level.rythim_manager.beat_start()
	if !AudioAutoloader.stage_1_music.playing:
		print("Played first time")
		AudioAutoloader.playStage1Music()
	print("Game Started")

func update(_delta: float) -> void:
	if GameStates.player_lives <= 0:
		finished.emit(GAME_OVER)
		return
	
	if level.current_cleared_cube >= level.target_cleared_cube:
		finished.emit(LEVEL_CLEARED)
		return
