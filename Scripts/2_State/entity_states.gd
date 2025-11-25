class_name EntityState extends BaseState

const IDLE = "Idle"
const HOPPING = "Hopping"
const LANDING = "Landing"
const FALLING = "Falling"
const DEAD = "Dead"
const RESPAWNING = "Respawning"

const DEFAULT_SCALE: Vector2 = Vector2(0.2, 0.2)

const moves = [
	Vector2i(2, -1), # Up
	Vector2i(-1, 2),  # Right
	Vector2i(1, -2), # Left
	Vector2i(-2, 1)  # Down
]

func _ready() -> void:
	await owner.ready
