extends Node2D

signal ride_finished(final_world_position)

@export var target_marker: NodePath

var target_position: Vector2
var original_position: Vector2

func _ready():
	original_position = global_position
	
	if not target_marker.is_empty():
		target_position = get_node(target_marker).global_position

func start_ride(player):
	var original_parent = player.get_parent()
	player.reparent(self)
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE) 
	
	var lift_position = global_position + Vector2(0, -400)
	tween.tween_property(self, "global_position", lift_position, 1.0)
	tween.tween_property(self, "global_position", target_position, 1.5)
	tween.tween_callback(_on_ride_complete.bind(player, original_parent))

func _on_ride_complete(player, original_parent):
	player.reparent(original_parent)
	player.global_position = target_position
	emit_signal("ride_finished", target_position)
	global_position = original_position
