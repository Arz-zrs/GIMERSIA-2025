extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	if data.has("next_move"):
		if data["next_move"] == moves[0]:
			player.animation_player.play("idle_up")
		elif data["next_move"] == moves[1]:
			player.animation_player.play("idle_right")
		elif data["next_move"] == moves[2]:
			player.animation_player.play("idle_left")
		elif data["next_move"] == moves[3]:
			player.animation_player.play("idle_down")
	else:
		player.animation_player.play("idle_down")
	
	if player.input_buffer != Vector2i.ZERO:
		finished.emit(HOPPING)

func handle_input(_event: InputEvent) -> void:
	var move_dir = Vector2i.ZERO
	
	if _event.is_action_pressed("Up"):
		move_dir = moves[0]
	elif _event.is_action_pressed("Right"):
		move_dir = moves[1]
	elif _event.is_action_pressed("Left"):
		move_dir = moves[2]
	elif _event.is_action_pressed("Down"):
		move_dir = moves[3]

	if move_dir != Vector2i.ZERO:
		player.input_buffer = move_dir
		#GameStates.player_turn_taken.emit(move_dir) i comment this so that enemy will move on beat only
		
	finished.emit(HOPPING)
