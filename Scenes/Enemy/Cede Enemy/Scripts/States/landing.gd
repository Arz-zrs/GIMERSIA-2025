extends CedeState

func enter(previous_state_path: String, data := {}) -> void:
	cede.current_grid_pos = data["target_grid_pos"]
	print("cede",cede.current_grid_pos)
	if _is_valid_cell(cede.current_grid_pos):
		if _is_on_player_tile(cede.current_grid_pos):
			var player_node = cede.get_meta("player_node")
			if not player_node.has_iframe:
				AudioAutoloader.playHitSound()
				player_node.emit_signal("hit_by_enemy")
			else:
				print("player has iframe")
		finished.emit(IDLE)
	else:
		finished.emit(FALLING)

func _is_valid_cell(grid_pos: Vector2i) -> bool:
	return cede.world.tilemap_layer.get_cell_source_id(Vector2i(grid_pos.x, grid_pos.y)) != -1

func _is_on_player_tile(grid_pos: Vector2i) -> bool:
	var player_node = cede.get_meta("player_node")
	if not player_node:
		return false
	if player_node.has_iframe:
		return false
	return player_node.current_grid_pos == grid_pos
