extends Control

@onready var level1 = $VBoxContainer/HBoxContainer/Stage1
@onready var level2 = $VBoxContainer/HBoxContainer/Stage2
@onready var level3 = $VBoxContainer/HBoxContainer/Stage3
@onready var level4 = $VBoxContainer/HBoxContainer2/Stage4
@onready var level5 = $VBoxContainer/HBoxContainer2/Stage5
@onready var level6 = $VBoxContainer/HBoxContainer2/Stage6


func _ready() -> void:
	level1.pressed.connect(_on_stage_1_pressed)
	level2.pressed.connect(_on_stage_2_pressed)
	level3.pressed.connect(_on_stage_3_pressed)
	level4.pressed.connect(_on_stage_4_pressed)
	level5.pressed.connect(_on_stage_5_pressed)
	level6.pressed.connect(_on_stage_6_pressed)

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_packed(GameStates.scene_main_menu)

func _on_stage_1_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Stages/1_Tutorial/tutorial_1.tscn")


func _on_stage_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Stages/2_Tutorial/tutorial_2.tscn")


func _on_stage_3_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Stages/3_Tutorial/tutorial_3.tscn")


func _on_stage_4_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Stages/1_Stage/stage_1.tscn")


func _on_stage_5_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Stages/2_Stage/stage_2.tscn")


func _on_stage_6_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Stages/3_Stage/stage_3.tscn")
