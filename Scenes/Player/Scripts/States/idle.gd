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
	if not _event.is_pressed() or _event.is_echo():
		return

	var move_dir = Vector2i.ZERO

	if _event.is_action("Up"):
		move_dir = moves[0]
	elif _event.is_action("Right"):
		move_dir = moves[1]
	elif _event.is_action("Left"):
		move_dir = moves[2]
	elif _event.is_action("Down"):
		move_dir = moves[3]

	if move_dir == Vector2i.ZERO:
		return
	
	var song_beat = player.conductor.song_position_in_beats
	
	var closest_beat = round(song_beat) 
	
	#if beat_diff > GameStates.HIT_WINDOW:
		##print("OFF BEAT! Diff: ", time_off_beat) Debugging only
		#return 
		
	player.input_buffer = move_dir
	player.last_hop_beat = int(closest_beat)
	
	finished.emit(HOPPING)
