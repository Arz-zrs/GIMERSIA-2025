extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	player.has_iframe = false
	player.current_grid_pos = data["target_grid_pos"]
	
	var overlapping_areas = player.hitbox.get_overlapping_areas()
	
	for area in overlapping_areas:
		if area.is_in_group("disc"):
			finished.emit(ON_DISC, {"disc":area.get_parent()})
			return
	
	#print(player.current_grid_pos)
	if _is_valid_cell(player.current_grid_pos):
		if _is_on_enemy_tile(player.current_grid_pos):
			AudioAutoloader.playHitSound()
			
			finished.emit(FALLING)
		else:
			match player.current_match:
				GameStates.Match.PERFECT:
					_tween_bounce(true)
				GameStates.Match.OK:
					_tween_bounce(false)
				GameStates.Match.MISS:
					_tween_shake()
			player.world.on_player_landed(player.current_grid_pos)
			finished.emit(IDLE, {"next_move" : data["next_move"]})
	else:
		finished.emit(FALLING)

func _is_valid_cell(grid_pos: Vector2i) -> bool:
	return player.world.tilemap_layer.get_cell_source_id(Vector2i(grid_pos.x, grid_pos.y)) != -1

func _is_on_enemy_tile(grid_pos: Vector2i) -> bool:
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if enemy.current_grid_pos == grid_pos and enemy.is_active:
			return true
	return false

func _get_camera() -> Camera2D:
	return player.camera

func _tween_shake() -> void:
	var cam = _get_camera()
	if not cam: return
	
	var tween = create_tween()
	# Shake heavily then return to zero
	for i in range(5):
		var random_offset = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * GameStates.SHAKE_INTENSITY
		tween.tween_property(cam, "offset", random_offset, GameStates.SHAKE_DURATION / 5.0)
	tween.tween_property(cam, "offset", Vector2.ZERO, 0.05)

func _tween_bounce(is_perfect: bool) -> void:
	var cam = _get_camera()
	if not cam: return
	
	var intensity = GameStates.BOUNCE_OFFSET_PERFECT if is_perfect else GameStates.BOUNCE_OFFSET_OK
	var time = 0.15 if is_perfect else 0.1
	
	var tween = create_tween()
	# Dip the camera down (impact weight) then bounce back up
	tween.tween_property(cam, "offset:y", intensity, time * 0.5).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(cam, "offset:y", 0.0, time * 0.5).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
