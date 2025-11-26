extends EntityState

func enter(previous_state_path: String, data := {}) -> void:
	owner.has_iframe = false
	owner.current_grid_pos = data["target_grid_pos"]

	# Check grid validity
	if _is_valid_cell(owner.current_grid_pos):
		 #Enemy kills when players get stomped
		if _is_on_player_tile(owner.current_grid_pos):
			var player_node = owner.get_meta("player_node")
			AudioAutoloader.playHitSound()
			player_node.emit_signal("hit_by_enemy")
		finished.emit(IDLE)
	else:
		owner.is_active = false
		finished.emit(FALLING)

# Calculate grid validity
func _is_valid_cell(grid_pos: Vector2i) -> bool:
	return owner.world.tilemap_layer.get_cell_source_id(Vector2i(grid_pos.x, grid_pos.y)) != -1

# For Killing Player
func _is_on_player_tile(grid_pos: Vector2i) -> bool:
	var player_node = owner.get_meta("player_node")
	if not player_node:
		return false
	#if player_node.has_iframe:
		#return false
	return player_node.current_grid_pos == grid_pos
