extends CedeState

func enter(previous_state_path: String, data := {}) -> void:
	TurnManager.player_turn_taken.connect(_on_player_turn)

func exit() -> void:
	TurnManager.player_turn_taken.disconnect(_on_player_turn)

func _on_player_turn(player_move_dir: Vector2i):
	GameStates.game_turn += 1
	cede.player_move_count += 1
	if cede.player_move_count < 2:
		return
	cede.player_move_count = 0
	
	var player_node: Node2D = cede.get_meta("player_node")
	var my_pos: Vector2i = cede.current_grid_pos
	var player_current_pos: Vector2i = player_node.current_grid_pos
	var player_target_pos: Vector2i = player_current_pos + player_move_dir
	
	var possible_moves = [
		Vector2i(1, 0), # Up
		Vector2i(0, 1),  # Right
		Vector2i(0, -1),  # Left
		Vector2i(-1, 0)    # Down
	]
	

	var best_move: Vector2i = Vector2i.ZERO
	var min_distance: int = _get_grid_distance(my_pos, player_target_pos)
	for move_dir in possible_moves:
		var new_pos: Vector2i = my_pos + move_dir
		var new_distance: int = _get_grid_distance(new_pos, player_target_pos)
		
		if new_distance < min_distance:
			min_distance = new_distance
			best_move = move_dir
			
	finished.emit(HOPPING, {"move_direction": best_move})

func _get_grid_distance(pos1: Vector2i, pos2: Vector2i) -> int:
	var dx = abs(pos1.x - pos2.x)
	var dy = abs(pos1.y - pos2.y)
	return max(dx, dy)
