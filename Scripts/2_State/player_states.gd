class_name PlayerState extends EntityState

const ON_DISC = "OnDisc"

var player: Player
var disc_node

## Assign owner as Player for easier autocomplete and Connect owner to hit_by_enemy signal
func _ready() -> void:
	super._ready()
	owner.hit_by_enemy.connect(_on_owner_hit)
	player = owner as Player
	assert(player != null, "The PlayerState state type must be used only in the player scene. It needs the owner to be a Player node.")

func _on_owner_hit():
	finished.emit(FALLING)
