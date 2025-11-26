extends Label

@export var animation_duration: float = 1.0
@export var float_intensity: float = 10

func _ready():
	# Center the label on its position
	pivot_offset = size / 2
	
	var tween = create_tween()
	tween.set_parallel(true)
	
	# Floating up effect
	tween.tween_property(self, "position:y", position.y - float_intensity, animation_duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	
	var fade_delay = animation_duration * 0.9
	var fade_time = animation_duration * 0.1
	
	# Fade animation
	tween.tween_property(self, "modulate:a", 0.0, fade_time).set_delay(fade_delay).set_ease(Tween.EASE_IN)
	
	# Scale up floating text
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), animation_duration)
	
	await tween.finished
	queue_free()

# Setting text and color of the label
func set_text_and_color(text_value: String, color: Color):
	text = text_value
	modulate = color
