extends HBoxContainer

@export var boss_health_bar: PackedScene

func _ready():
	SignalBus.boss_spawned.connect(create_health_bar)

func create_health_bar(boss: Enemy):
	var bar = boss_health_bar.instantiate()
	bar.boss = boss
	add_child(bar)
