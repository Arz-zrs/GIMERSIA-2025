extends CanvasLayer

@onready var retry_button = $RetryButton
@onready var menu_button = $MenuButton

func _ready() -> void:
	if retry_button:
		retry_button.pressed.connect(_on_retry_pressed)
	if menu_button:
		menu_button.pressed.connect(_on_menu_pressed)

func _on_retry_pressed():
	get_tree().reload_current_scene()

func _on_menu_pressed():
	get_tree().change_scene_to_packed(GameStates.scene_main_menu)
