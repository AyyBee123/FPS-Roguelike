class_name Miniboss extends Enemy

@export var boss_name: String

func _ready():
	super._ready()
	SignalBus.boss_spawned.emit(self)
