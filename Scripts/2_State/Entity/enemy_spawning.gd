extends EntityState

var spawning_tween: Tween
var move_counter: int = 0
var has_player_spawned: bool = false

func enter(previous_state_path: String, data := {}) -> void:
	owner.is_active = false
	owner.current_grid_pos = owner.spawn_grid_pos
	owner.global_position = owner.world.get_screen_pos_for_cell(owner.current_grid_pos)
	
	move_counter = 0
	has_player_spawned = false
	owner.sprite.hide()
	
	GameStates.player_turn_taken.connect(_on_player_turn)

func _on_player_turn(_move_dir: Vector2i):
	if has_player_spawned:
		return

	move_counter += 1
	
	if move_counter >= owner.target_move_counter:
		GameStates.player_turn_taken.disconnect(_on_player_turn)
		_start_spawn_animation()

func _start_spawn_animation():
	owner.sprite.show()
	
	spawning_tween = create_tween()
	spawning_tween.set_loops(4)
	spawning_tween.set_parallel(false)

	spawning_tween.tween_property(
		owner.sprite, "modulate:a", 0.2, 0.15
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	spawning_tween.tween_property(
		owner.sprite, "modulate:a", 1.0, 0.15
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	
	await spawning_tween.finished
	owner.is_active = true
	
	finished.emit(IDLE)

func exit():
	if GameStates.player_turn_taken.is_connected(_on_player_turn):
		GameStates.player_turn_taken.disconnect(_on_player_turn)
	
	owner.sprite.modulate.a = 1.0
	owner.sprite.show()
	
	if spawning_tween and spawning_tween.is_running():
		spawning_tween.kill()
		
	owner.is_active = true
