extends CedeState

func enter(previous_state_path: String, data := {}) -> void:
	cede.current_grid_pos = data["target_grid_pos"]
	print("cede",cede.current_grid_pos)
	if _is_valid_cell(cede.current_grid_pos):
		finished.emit(IDLE)
	else:
		finished.emit(FALLING)

func _is_valid_cell(grid_pos: Vector2i) -> bool:
	return cede.world.tilemap_layer.get_cell_source_id(Vector2i(grid_pos.x, grid_pos.y)) != -1
