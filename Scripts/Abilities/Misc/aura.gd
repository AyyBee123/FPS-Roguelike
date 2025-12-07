extends Node3D

@onready var tick_rate: Timer = $"Tick Rate"

var damage: float

var player: Player
var enemies: Array[Enemy]

func _physics_process(delta):
	if tick_rate.is_stopped():
		for enemy in enemies:
			if enemy is Enemy:
				enemy.hit(damage, player, self)
		tick_rate.start()

func _on_area_3d_body_entered(body):
	if body is Enemy:
		enemies.append(body)

func _on_area_3d_body_exited(body):
	if enemies.has(body):
		enemies.remove_at(enemies.find(body))
