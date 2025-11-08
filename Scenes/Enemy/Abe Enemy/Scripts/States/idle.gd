extends AbeState

func enter(previous_state_path: String, data := {}) -> void:
	TurnManager.player_turn_taken.connect(_on_player_turn)

func exit() -> void:
	TurnManager.player_turn_taken.disconnect(_on_player_turn)

func _on_player_turn(player_move_dir: Vector2i):
	var all_moves = [
		Vector2i(-1, -1), 
		Vector2i(1, -1), 
		Vector2i(-1, 1), 
		Vector2i(1, 1)
		]
	var enemy_move_dir: Vector2i = all_moves.pick_random()
	
	finished.emit(HOPPING, {"move_direction": enemy_move_dir})
