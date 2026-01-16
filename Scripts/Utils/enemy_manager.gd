extends Node

@export var enemies: Array[EnemySpawn]

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var level = get_parent() as Level

static var current_number_of_enemies: int = 0

var NUMBER_OF_ENEMIES_TO_SPAWN: int = 1
var MAX_NUMBER_OF_ENEMIES: int = 20
var MIN_AMOUNT_OF_ENEMIES: int = 100
var SPAWNING_INTERVAL: float = 2
var t: float = 0 

# distance range the enemy can spawn away from the player
const MIN_DISTANCE: float = 40
const MAX_DISTANCE: float = 100

# distance range that groups of enemies can spawn from each other
const MIN_GROUP_DISTANCE: float = 6
const MAX_GROUP_DISTANCE: float = 12

const ENEMY = preload("uid://bf7ljiiykmoi0")

func _ready():
	SignalBus.enemy_defeated.connect(_on_enemy_defeat)

func _physics_process(delta):
	t += delta
	if t >= SPAWNING_INTERVAL:
		t = 0
		# spawn enemies if the current amount on the map is less than the maximum
		if current_number_of_enemies < MAX_NUMBER_OF_ENEMIES:
			for i in range(max(NUMBER_OF_ENEMIES_TO_SPAWN, MIN_AMOUNT_OF_ENEMIES - current_number_of_enemies)):
				spawn_enemy(enemies.pick_random()) # for now
	
	if level.current_number_of_enemies != current_number_of_enemies:
		level.current_number_of_enemies = current_number_of_enemies

func spawn_enemy(spawn: EnemySpawn) -> void:
	for i in range(spawn.amount_to_spawn):
		current_number_of_enemies += 1
		var enemy = spawn.enemy.instantiate()
		enemy.position = level.find_spawn_point(player.global_position, MIN_DISTANCE, MAX_DISTANCE) \
				+ get_random_group_offset()
		level.add_child.call_deferred(enemy)

func get_random_group_offset() -> Vector3:
	var offset: Vector2 = (Vector2.ONE.normalized() * randf_range(MIN_GROUP_DISTANCE, MAX_GROUP_DISTANCE)) \
			.rotated(randf_range(0, TAU))
	return Vector3(offset.x, 0, offset.y)

func _on_enemy_defeat(_enemy) -> void:
	current_number_of_enemies -= 1
	current_number_of_enemies = max(0, current_number_of_enemies)
