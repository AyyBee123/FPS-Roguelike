extends Enemy

@export var pillar: Boss

func _ready():
	weight = 0.0

func _physics_process(delta):
	super._physics_process(delta)
	global_position = get_parent().global_position
	contact_damage = pillar.contact_damage

func hit(_damage: float, source_player: Player, source: Variant):
	if not pillar.is_spawned: return
	pillar.hit(_damage, source_player, source)
