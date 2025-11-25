class_name Player extends CharacterBody2D

signal hit_by_enemy

enum Match {PERFECT, OK, MISS}

@export var world: Node2D
@export var conductor: Node

var current_grid_pos: Vector2i
var target_grid_pos: Vector2i
var input_buffer: Vector2i = Vector2i.ZERO
var last_grid_pos: Vector2i = Vector2i.ZERO

var is_hopping: bool = false

var last_hop_beat: float = -10.0
var last_song_pos: float
var current_match = Match.MISS

var has_iframe: bool = false

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var state_machine = $StateMachine
@onready var hitbox: Area2D = $Hitbox
@onready var camera: Camera2D = $Camera2D

func _ready():
	current_grid_pos = world.get_spawn_pos()
	global_position = world.get_screen_pos_for_cell(current_grid_pos)
	target_grid_pos = current_grid_pos
