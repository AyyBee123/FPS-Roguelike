extends Node3D

@export var tick_rate: float = 0.1

@onready var area_3d = %Area3D

var damage: float

var player: Player

var enemies: Array[Enemy]
var damage_timer: float = INF

func _physics_process(delta):
	damage_timer += delta
	if damage_timer >= tick_rate and enemies.size() > 0:
		damage_timer = 0.0
		for enemy in enemies:
			enemy.hit(damage, player, self)

func _on_area_3d_body_entered(body):
	if not body is Enemy:
		return
	if not body.has_meta("circle_of_light_overlap"):
		body.set_meta("circle_of_light_overlap", [])
	body.get_meta("circle_of_light_overlap").append(self)
	enemies.append(body)

func _on_area_3d_body_exited(body):
	if not body is Enemy:
		return
	if body.has_meta("circle_of_light_overlap"):
		body.get_meta("circle_of_light_overlap", []).erase(self)
	enemies.erase(body)
