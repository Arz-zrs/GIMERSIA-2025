extends CanvasLayer

@onready var resume_button = $CanvasLayer/VBoxContainer/ResumeButton
@onready var quit_button = $CanvasLayer/VBoxContainer/QuitButton
@onready var menu_button = $CanvasLayer/VBoxContainer/MenuButton

func _ready():
	if resume_button:
		resume_button.pressed.connect(_on_resume_pressed)
	if quit_button:
		quit_button.pressed.connect(_on_quit_pressed)
	if menu_button:
		menu_button.pressed.connect(_on_menu_pressed)

func _on_pause_pressed() -> void:
	get_tree().paused = true
	$CanvasLayer.visible = true
	$PauseButton.visible = false

func _on_resume_pressed():
	get_tree().paused = false
	$CanvasLayer.visible = false
	$PauseButton.visible = true

func _on_quit_pressed():
	get_tree().quit()

func _on_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_packed(GameStates.scene_main_menu)
