extends Label

func _ready():
	# Center the label on its position
	pivot_offset = size / 2
	
	var tween = create_tween()
	tween.set_parallel(true)
	
	# Float up LESS (was 50, now 30) and SLOWER (was 0.5s, now 1.0s)
	tween.tween_property(self, "position:y", position.y - 30, 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	
	# Fade out LATER (wait 0.5s, then fade over 0.5s)
	# We use a separate tween property or delay for this if we want it sequential within parallel, 
	# but simple duration increase is easier.
	# Let's make it stay fully visible for 0.7s, then fade in the last 0.3s
	tween.tween_property(self, "modulate:a", 0.0, 0.3).set_delay(0.7).set_ease(Tween.EASE_IN)
	
	# Scale up LESS (was 1.5, now 1.2) and SLOWER (matches total time)
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), 1.0)
	
	await tween.finished
	queue_free()

func set_text_and_color(text_value: String, color: Color):
	text = text_value
	modulate = color
