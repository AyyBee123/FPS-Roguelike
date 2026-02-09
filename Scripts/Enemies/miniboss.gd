class_name Miniboss extends Enemy

@export var boss_name: String

const MINIBOSS_SPAWN_VFX = preload("uid://3t4q01uo2ubp")

func _ready():
	super._ready()
	SignalBus.boss_spawned.emit(self)
	
	var spawn_vfx = MINIBOSS_SPAWN_VFX.instantiate()
	spawn_vfx.position = position
	get_tree().current_scene.add_child(spawn_vfx)
