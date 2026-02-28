extends Enemy

@export var pillar: Boss

func _ready():
	pass

func _physics_process(delta):
	super._physics_process(delta)
	global_position = get_parent().global_position

func hit(_damage: float, source_player: Player, source: Variant):
	pillar.hit(_damage, source_player, source)
