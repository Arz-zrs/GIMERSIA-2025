extends PlayerState

var hop_tween: Tween

func enter(previous_state_path: String, data := {}) -> void:
	if hop_tween and hop_tween.is_running():
		hop_tween.kill()
	
	if player.input_buffer != Vector2i.ZERO:
		var next_move = player.input_buffer
		player.input_buffer = Vector2i.ZERO
		
		var target_grid_pos = player.current_grid_pos + next_move
		
		_start_hop(target_grid_pos)
	else:
		finished.emit(IDLE)

func handle_input(_event: InputEvent) -> void:
	var move_dir = Vector2i.ZERO
	
	if _event.is_action_pressed("Up"):
		move_dir = Vector2i(-1, -1)
	elif _event.is_action_pressed("Right"):
		move_dir = Vector2i(1, -1)
	elif _event.is_action_pressed("Left"):
		move_dir = Vector2i(-1, 1)
	elif _event.is_action_pressed("Down"):
		move_dir = Vector2i(1, 1)

	if move_dir != Vector2i.ZERO:
		player.input_buffer = move_dir

func _start_hop(target_grid_pos: Vector2i):
	var target_screen_pos = player.world.get_screen_pos_for_cell(target_grid_pos)
	
	hop_tween = player.create_tween()
	hop_tween.set_parallel(true) 
	hop_tween.tween_property(player, "global_position", target_screen_pos, 0.25)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)
		
	var arc_tween = player.create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	arc_tween.tween_property(player.sprite, "scale:y", 1.5, 0.125) 
	arc_tween.tween_property(player.sprite, "scale:y", 1.0, 0.125)
	
	await hop_tween.finished
	
	var data: Dictionary = {"target_grid_pos": target_grid_pos}
	finished.emit(LANDING, data)
