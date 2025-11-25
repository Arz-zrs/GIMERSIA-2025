extends CedeState

var _last_moved_turn: int = -1
var _planned_move_dir: Vector2i = Vector2i.ZERO

func enter(previous_state_path: String, data := {}) -> void:
	if not GameStates.player_turn_taken.is_connected(_on_player_turn):
		GameStates.player_turn_taken.connect(_on_player_turn)
	_calculate_and_show_intent()

func exit() -> void:
	cede.move_highlighter.hide()
	if GameStates.player_turn_taken.is_connected(_on_player_turn):
		GameStates.player_turn_taken.disconnect(_on_player_turn)

func _on_player_turn(player_move_dir: Vector2i):
	var current_turn = GameStates.game_turn
	
	if current_turn % 2 != 0:
		_calculate_and_show_intent()
		return

	cede.move_highlighter.hide()
	finished.emit(HOPPING, {"move_direction": _planned_move_dir})

func _calculate_and_show_intent():
	if GameStates.game_turn == _last_moved_turn:
		return 

	var best_move = _calculate_best_move()
	_planned_move_dir = best_move
	_last_moved_turn = GameStates.game_turn

	var target_grid_pos = cede.current_grid_pos + best_move
	var target_screen_pos = cede.world.get_screen_pos_for_cell(target_grid_pos)
	cede.move_highlighter.global_position = target_screen_pos
	cede.move_highlighter.show()

func _update_highlighter():
	if GameStates.game_turn % 2 != 0:
		_calculate_and_show_intent()
	else:
		cede.move_highlighter.hide()

func _calculate_best_move() -> Vector2i:
	var player_node = _get_player_from_group()
	if not player_node:
		return Vector2i.ZERO

	var cede_pos: Vector2i = cede.current_grid_pos
	var player_current_pos: Vector2i = player_node.current_grid_pos
	var player_target_pos: Vector2i = player_current_pos	
	var possible_moves = [
		Vector2i(2, -1), # Up
		Vector2i(-1, 2),  # Right
		Vector2i(1, -2), # Left
		Vector2i(-2, 1)  # Down
	]

	var best_move: Vector2i = Vector2i.ZERO
	var min_distance: float = _get_grid_distance(cede_pos, player_target_pos)
	
	for move_dir in possible_moves:
		var new_pos: Vector2i = cede_pos + move_dir
		var new_distance: int = _get_grid_distance(new_pos, player_target_pos)
		if new_distance < min_distance:
			min_distance = new_distance
			best_move = move_dir
	return best_move

func _get_grid_distance(pos1: Vector2i, pos2: Vector2i) -> int:
	var dx = pos2.x - pos1.x
	var dy = pos2.y - pos1.y
	var a = (2 * dx + dy) / 3
	var b = (dx + 2 * dy) / 3
	return abs(a) + abs(b)

func _get_player_from_group() -> Node2D:
	var nodes = get_tree().get_nodes_in_group("player")
	if nodes.size() > 0:
		return nodes[0]
	return null
