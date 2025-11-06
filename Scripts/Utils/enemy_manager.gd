extends Node

@export var enemies: Array[PackedScene]

@onready var player = get_tree().get_first_node_in_group("Player")

static var current_number_of_enemies: int = 0
var NUMBER_OF_ENEMIES_TO_SPAWN: int = 1
var MAX_NUMBER_OF_ENEMIES: int = 20
var MIN_AMOUNT_OF_ENEMIES: int = 10
var SPAWNING_INTERVAL: float = 3
var t: float = 0

const MIN_DISTANCE: float = 25
const MAX_DISTANCE: float = 50

const ENEMY = preload("uid://bf7ljiiykmoi0")

func _ready():
	randomize()
	SignalBus.enemy_defeated.connect(_on_enemy_defeat)
	spawn_enemy(enemies[1])
	spawn_enemy(enemies[0])
	#var i = 0
	#while i < TAU:
		#for j in range(12):
			#var enemy = ENEMY.instantiate()
			#get_tree().current_scene.add_child.call_deferred(enemy)
			#var pos = Vector2.from_angle(i) * (j + 1) * 4
			#await get_tree().physics_frame
			#enemy.global_transform.origin = Vector3(pos.x, 20, pos.y)
			#current_number_of_enemies += 1
		#i += PI/6
	#print(current_number_of_enemies)

func _physics_process(delta):
	t += delta
	if t >= SPAWNING_INTERVAL:
		t = 0
		# spawn enemies if the current amount on the map is less than the maximum
		if current_number_of_enemies < MAX_NUMBER_OF_ENEMIES:
			for i in range(NUMBER_OF_ENEMIES_TO_SPAWN):
				spawn_enemy(enemies.pick_random()) # for now

func spawn_enemy(_enemy: PackedScene):
	var enemy = _enemy.instantiate()
	var pos: Vector3 = player.global_position
	var spawn_point: Vector2 = Vector2(pos.x, pos.z) + \
			(Vector2.ONE * randf_range(MIN_DISTANCE, MAX_DISTANCE)).rotated(randf_range(0, TAU))
	enemy.position = Vector3(spawn_point.x, 30, spawn_point.y)
	current_number_of_enemies += 1
	get_tree().current_scene.add_child.call_deferred(enemy)

func _on_enemy_defeat(_enemy):
	current_number_of_enemies -= 1
	current_number_of_enemies = max(0, current_number_of_enemies)
