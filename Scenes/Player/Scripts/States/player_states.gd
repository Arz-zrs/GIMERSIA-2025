class_name PlayerState extends BaseState

const IDLE = "Idle"
const HOPPING = "Hopping"
const LANDING = "Landing"
const FALLING = "Falling"
const DEAD = "Dead"
const RESPAWNING = "Respawning"
const ON_DISC = "OnDisc"

const DEFAULT_SCALE: Vector2 = Vector2(0.2, 0.2)



const moves = [
	Vector2i(2, -1), # Up
	Vector2i(-1, 2),  # Right
	Vector2i(1, -2), # Left
	Vector2i(-2, 1)  # Down
]

var player: Player
var disc_node

func _ready() -> void:
	await owner.ready
	owner.hit_by_enemy.connect(_on_owner_hit)
	player = owner as Player
	assert(player != null, "The PlayerState state type must be used only in the player scene. It needs the owner to be a Player node.")

func _on_owner_hit():
	finished.emit(FALLING)
