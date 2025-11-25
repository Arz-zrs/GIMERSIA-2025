class_name Tutorial1 extends Stage

func _on_next_button_pressed() -> void:
	get_tree().change_scene_to_packed(preload("res://Scenes/Stages/tutorial_2.tscn"))
