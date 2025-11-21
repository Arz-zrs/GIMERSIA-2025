extends CanvasLayer

@onready var score_label: Label = $ScoreLabel
@onready var multiplier_label: Label = $MultiplierLabel

func _ready() -> void:
	GameStates.score_updated.connect(_on_score_updated)
	GameStates.multiplier_updated.connect(_on_multiplier_updated)
	
	_on_score_updated(GameStates.score)
	_on_multiplier_updated(GameStates.multiplier)

func _on_score_updated(new_score: int) -> void:
	score_label.text = "Score: %d" % new_score

func _on_multiplier_updated(new_multiplier: int) -> void:
	multiplier_label.text = "x%d" % new_multiplier
	if new_multiplier > 1:
		multiplier_label.show()
	else:
		multiplier_label.hide()
