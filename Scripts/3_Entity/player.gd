class_name Player extends CharacterBody2D

signal hit_by_enemy

enum Match {PERFECT, OK, MISS}

@export var world: Node2D
@export var conductor: Node
@export var floating_label: PackedScene

# Pulse Configuration
@export_group("Camera Shake Setting")
@export var pulse_up_duration: float = 0.1
@export var pulse_down_duration: float = 0.4
@export var pulse_ease_in: Tween.TransitionType = Tween.TRANS_SINE
@export var pulse_ease_out: Tween.TransitionType = Tween.TRANS_LINEAR

# Stomp Configuration
@export_group("Stomp Settings")
@export var perfect_deduction: int = 8
@export var perfect_label_text: String = "PERFECT"
@export var ok_deduction: int = 4
@export var ok_label_text: String = "OK"
@export var miss_deduction: int = 0
@export var miss_label_text: String = "MISS"

var tween: Tween = null
var facing_to: int = 3

var current_grid_pos: Vector2i
var target_grid_pos: Vector2i
var input_buffer: Vector2i = Vector2i.ZERO
var last_grid_pos: Vector2i = Vector2i.ZERO

var is_hopping: bool = false

var last_hop_beat: float = -10.0
var last_song_pos: float
var current_match = Match.MISS

var has_moved: bool = false
var has_iframe: bool = false

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var state_machine = $StateMachine
@onready var hitbox: Area2D = $Hitbox

func _ready():
	current_grid_pos = world.get_spawn_pos()
	global_position = world.get_screen_pos_for_cell(current_grid_pos)
	target_grid_pos = current_grid_pos
	
	
	GameStates.beat_hit.connect(_on_beat_hit)
	
func _on_beat_hit(_beat_num: int):
	if tween != null and tween.is_valid():
		tween.kill()
	
	var base_scale: Vector2
	var pulse_scale: Vector2
	
	if facing_to == 0 or facing_to == 3:
		base_scale = Vector2(-0.2, 0.2)
		pulse_scale = Vector2(-0.25, 0.25)
	elif facing_to == 1 or facing_to == 2:
		base_scale = Vector2(0.2, 0.2)
		pulse_scale = Vector2(0.25, 0.25)
	
	tween = create_tween()
	
	tween.tween_property(sprite, "scale", pulse_scale, pulse_up_duration)\
		.set_trans(pulse_ease_in)\
		.set_ease(Tween.EASE_OUT)
	
	tween.tween_property(sprite, "scale", base_scale, pulse_down_duration)\
		.set_trans(pulse_ease_out)\
		.set_ease(Tween.EASE_IN)
