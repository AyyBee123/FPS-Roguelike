extends Control

@onready var health_bar = %"Health Bar"
@onready var health_text = %"Health Text"
@onready var boss_name = %Name

var boss: Enemy

func _ready():
	boss_name.text = boss.boss_name

func _physics_process(delta):
	if not boss:
		queue_free()
		return
	
	health_bar.value = lerp(health_bar.value, boss.health / boss.INITIAL_HEALTH, 0.25)
	health_text.text = "%d / %d" % [boss.health, boss.INITIAL_HEALTH]
