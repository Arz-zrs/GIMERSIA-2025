class_name AbeState extends BaseState

const SPAWNING = "Spawning"
const IDLE = "Idle"
const HOPPING = "Hopping"
const LANDING = "Landing"
const FALLING = "Falling"

const DEFAULT_SCALE = Vector2(0.2, 0.2)

var abe: Abe
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await owner.ready
	abe = owner as Abe
	assert(abe != null, "The AbeState state type must be used only in the abe scene. It needs the owner to be a Abe node.")
