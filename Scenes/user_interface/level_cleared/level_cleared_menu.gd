extends CanvasLayer

@onready var retry_button = $RetryButton
@onready var next_button = $NextButton
@onready var menu_button = $MenuButton
@onready var score_label: Label = $ScoreLabel

func _ready() -> void:
	if retry_button:
		retry_button.pressed.connect(_on_retry_pressed)
	if next_button:
		next_button.pressed.connect(_on_next_pressed)
	if menu_button:
		menu_button.pressed.connect(_on_menu_pressed)

	GameStates.score_updated.connect(_on_score_updated)
	
	_on_score_updated(GameStates.score)

func _on_score_updated(new_score: int) -> void:
	if score_label:
		score_label.text = "Score: %d" % new_score

func _on_retry_pressed():
	get_tree().reload_current_scene()

func _on_next_pressed():
	GameStates.load_next_level()

func _on_menu_pressed():
	get_tree().change_scene_to_packed(GameStates.scene_main_menu)
