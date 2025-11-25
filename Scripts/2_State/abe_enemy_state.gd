class_name AbeState extends EntityState

const SPAWNING = "Spawning"

var abe: Abe
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	abe = owner as Abe
	assert(abe != null, "The AbeState state type must be used only in the abe scene. It needs the owner to be a Abe node.")
