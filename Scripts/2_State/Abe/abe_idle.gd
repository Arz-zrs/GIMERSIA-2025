extends AbeState

var _last_moved_turn: int = -1
var _next_move_dir: Vector2i = Vector2i.ZERO

func enter(previous_state_path: String, data := {}) -> void:
	_clear_highlight()
	abe.has_iframe = false
	var possible_moves = [
		Vector2i(2, -1), # Up
		Vector2i(-1, 2),  # Right
		Vector2i(1, -2), # Left
		Vector2i(-2, 1)  # Down
	]
	
	# Search for valid grid so it doesn't fall
	var valid_moves = []
	for move in possible_moves:
		var target_grid_pos = abe.current_grid_pos + move
		
		# Check if the tile exists and is walkable
		if abe.world.is_tile_walkable(target_grid_pos):
			valid_moves.append(move)

	# Assign moves if grid is valid
	if valid_moves.size() > 0:
		_next_move_dir = valid_moves.pick_random()
	else:
		_next_move_dir = Vector2i.ZERO

		# Show abe move highlighter
	if _next_move_dir != Vector2i.ZERO:
		var target_grid_pos = abe.current_grid_pos + _next_move_dir
		var target_screen_pos = abe.world.get_screen_pos_for_cell(target_grid_pos)
		#abe.move_highlighter.global_position = target_screen_pos
		#abe.move_highlighter.show()
	
	#  Set TileMap Cell
	if _next_move_dir != Vector2i.ZERO:
		var target_grid_pos = abe.current_grid_pos + _next_move_dir
		# Set the tile to the RED alternative tile
		abe.world.tilemap_layer.set_cell(
			target_grid_pos,
			abe.highlight_tile_source_id,
			abe.highlight_tile_atlas_coords,
			abe.highlight_tile_alt_id
		)
		abe._last_highlighted_pos = target_grid_pos
	
	# Connect to beat
	if not GameStates.beat_hit.is_connected(_on_beat_hit):
		GameStates.beat_hit.connect(_on_beat_hit)

#func update(_delta: float) -> void:
	#if GameStates.beat_hit:
		#_on_beat_hit()
	

func _on_beat_hit(_beat_num: int):
	var current_turn = GameStates.game_turn
	# if 2nd beat, abe moves
	if current_turn % 2 != 0:
		_last_moved_turn = current_turn
		#abe.move_highlighter.hide()
		finished.emit(HOPPING, {"move_direction": _next_move_dir}) 

# Helper function to restore the normal tile
func _clear_highlight():
	if abe._last_highlighted_pos != Vector2i(-999, -999):
		# Restore to normal tile
		abe.world.tilemap_layer.set_cell(
			abe._last_highlighted_pos,
			abe.normal_tile_source_id,
			abe.normal_tile_atlas_coords,
			abe.normal_tile_alt_id
		)
		# Reset tracker
		abe._last_highlighted_pos = Vector2i(-999, -999)

func exit() -> void:
	#abe.move_highlighter.hide()
	if GameStates.beat_hit.is_connected(_on_beat_hit):
		GameStates.beat_hit.disconnect(_on_beat_hit)
