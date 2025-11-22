extends PlayerState

var respawing_tween: Tween

func enter(previous_state_path: String, data := {}) -> void:
	if respawing_tween and respawing_tween.is_running():
		respawing_tween.kill()
	
	_on_respawning()

func _on_respawning():
	player.has_iframe = true
	player.current_grid_pos = player.world.get_spawn_pos()
	player.global_position = player.world.get_screen_pos_for_cell(player.current_grid_pos)
	
	respawing_tween = player.create_tween()
	
	respawing_tween.set_loops(4)
	
	respawing_tween.tween_property(
		player.sprite, 
		"modulate:a", 
		0.2, 
		0.15
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	respawing_tween.tween_property(
		player.sprite, 
		"modulate:a", 
		1.0, 
		0.15
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	
	await respawing_tween.finished
	GameStates.player_spawn_finished.emit()
	get_tree().create_timer(1.0).timeout.connect(_on_iframe_ended)
	finished.emit(IDLE)

func _on_iframe_ended():
	player.has_iframe = false
	print("iframe end")

func exit():
	player.sprite.modulate.a = 1.0
	
	if respawing_tween and respawing_tween.is_running():
		respawing_tween.kill()
