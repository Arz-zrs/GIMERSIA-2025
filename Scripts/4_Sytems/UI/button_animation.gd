extends Button

@onready var left_icon: TextureRect = $HBoxContainer/LeftIcon
@onready var right_icon: TextureRect = $HBoxContainer/RightIcon
@onready var hbox_container: HBoxContainer = $HBoxContainer

var _original_container_pos: Vector2

func _ready():
	_original_container_pos = hbox_container.position

	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	button_down.connect(_on_button_down)
	button_up.connect(_on_button_up)

func _on_mouse_entered():
	left_icon.show()
	right_icon.show()

func _on_mouse_exited():
	left_icon.hide()
	right_icon.hide()

func _on_button_down():
	hbox_container.position.y = _original_container_pos.y + 3

func _on_button_up():
	hbox_container.position.y = _original_container_pos.y
