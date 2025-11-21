extends CedeState

var _last_moved_turn: int = -1

func enter(previous_state_path: String, data := {}) -> void:
	if not GameStates.player_turn_taken.is_connected(_on_player_turn):
		GameStates.player_turn_taken.connect(_on_player_turn)

func exit() -> void:
	if GameStates.player_turn_taken.is_connected(_on_player_turn):
		GameStates.player_turn_taken.disconnect(_on_player_turn)

func _on_player_turn(player_move_dir: Vector2i):
	var current_turn = GameStates.game_turn
	if current_turn == _last_moved_turn:
		return
	if current_turn % 2 != 0:
		return
	_last_moved_turn = current_turn
	
	var player_node = _get_player_from_group()
	if not player_node:
		printerr("CedeEnemy: Could not find node in group 'player'!")
		return
	var my_pos: Vector2i = cede.current_grid_pos
	var player_current_pos: Vector2i = player_node.current_grid_pos
	var player_target_pos: Vector2i = player_current_pos + player_move_dir
	
	var possible_moves = [
		Vector2i(2, -1), # Up
		Vector2i(-1, 2),  # Right
		Vector2i(1, -2), # Left
		Vector2i(-2, 1)  # Down
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
	return dx + dy

func _get_player_from_group() -> Node2D:
	var nodes = get_tree().get_nodes_in_group("player")
	if nodes.size() > 0:
		return nodes[0]
	return null
