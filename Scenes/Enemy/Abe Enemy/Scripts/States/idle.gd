extends AbeState

var _next_move_dir: Vector2i = Vector2i.ZERO

func enter(previous_state_path: String, data := {}) -> void:
	var possible_moves = [
		Vector2i(1, 0), # Up
		Vector2i(0, 1),  # Right
		Vector2i(0, -1), # Left
		Vector2i(-1, 0)  # Down
	]
	_next_move_dir = possible_moves.pick_random()
	
	var target_grid_pos = abe.current_grid_pos + _next_move_dir
	var target_screen_pos = abe.world.get_screen_pos_for_cell(target_grid_pos)
	abe.move_highlighter.global_position = target_screen_pos
	abe.move_highlighter.show()
	
	TurnManager.player_turn_taken.connect(_on_player_turn)

func _on_player_turn(player_move_dir: Vector2i):
	abe.move_highlighter.hide()
	finished.emit(HOPPING, {"move_direction": _next_move_dir})

func exit() -> void:
	abe.move_highlighter.hide()
	if TurnManager.player_turn_taken.is_connected(_on_player_turn):
		TurnManager.player_turn_taken.disconnect(_on_player_turn)
