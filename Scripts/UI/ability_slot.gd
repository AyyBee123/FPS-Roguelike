extends ColorRect

@onready var icon = %Icon
@onready var level = %Level

var ability: Ability

func _ready():
	icon.texture = ability.icon
	level.text = "LVL %s" % ability.level
