extends Node

var damage: float # damage taken per tick
var tick_rate: float # the rate at which the enemy takes damage
var tick_time: float # the current time until the next tick of damage
var is_dot: bool = false # flag if this node is a DOT or a persistant effect (e.g. a pool of damaging liquid)
var lifetime: float # lifetime of the DOT effect if applicable
var t: float = 0

var player: Player
var source
var enemy: Enemy

func _ready():
	enemy = get_parent()
	tick_time = tick_rate # immediately set off a damage tick

func _physics_process(delta):
	tick_time += delta
	if tick_time >= tick_rate:
		tick_time = 0
		enemy.hit(damage, player, source)
	
	t += delta
	
	if is_dot:
		lifetime -= delta
		if lifetime <= 0:
			queue_free()
