extends Node

@export var enemies: Array[EnemySpawn]
@export var bosses: Array[EndBossSpawn]
@export var MAX_NUMBER_OF_ENEMIES: int = 20
@export var MIN_NUMBER_OF_ENEMIES: int = 10
# distance range the enemy can spawn away from the player
@export var MIN_DISTANCE: float = 20
@export var MAX_DISTANCE: float = 100

@onready var level: Level = get_parent()

static var current_number_of_enemies: int = 0

var player: Player
var current_enemy_id: int = 0
var NUMBER_OF_ENEMIES_TO_SPAWN: int = 1
var SPAWNING_INTERVAL: float = 2
var boss_spawned: bool = false
var t: float = 0
var has_won: bool = false

@onready var INITIAL_MAX_ENEMIES: int = MAX_NUMBER_OF_ENEMIES
@onready var INITIAL_MIN_ENEMIES: int = MIN_NUMBER_OF_ENEMIES

const ENEMY = preload("uid://bf7ljiiykmoi0")

func _ready():
	current_number_of_enemies = 0
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta):
	if not boss_spawned: spawn_horde(delta)
	if not player: player = get_tree().get_first_node_in_group("Player")

func spawn_horde(delta):
	MAX_NUMBER_OF_ENEMIES = min(floori(INITIAL_MAX_ENEMIES * exp(level.enemy_tier * 0.1)), 100)
	MIN_NUMBER_OF_ENEMIES = min(floori(INITIAL_MIN_ENEMIES * exp(level.enemy_tier * 0.12)), 80)
	
	t += delta
	if t >= SPAWNING_INTERVAL:
		t = 0
		# spawn enemies if the current amount on the map is less than the maximum
		if current_number_of_enemies < MAX_NUMBER_OF_ENEMIES:
			for i in range(max(NUMBER_OF_ENEMIES_TO_SPAWN, MIN_NUMBER_OF_ENEMIES - current_number_of_enemies)):
				spawn_enemy(enemies.pick_random().enemy.instantiate()) # for now
	
	if level.current_number_of_enemies != current_number_of_enemies:
		level.current_number_of_enemies = current_number_of_enemies

func spawn_enemy(enemy: Enemy) -> void:
	current_number_of_enemies += 1
	enemy.id = current_enemy_id
	current_enemy_id += 1
	var pos: Vector3
	if player:
		pos = player.global_position
	enemy.position = level.find_spawn_point(pos, MIN_DISTANCE, MAX_DISTANCE)
	enemy.tier = level.enemy_tier
	enemy.died.connect(func(_enemy): current_number_of_enemies = current_number_of_enemies - 1)
	level.add_child.call_deferred(enemy)

func spawn_boss(spawn: BossSpawn):
	current_number_of_enemies += 1
	var boss = spawn.boss.instantiate()
	var pos: Vector3
	if player:
		pos = player.global_position
	boss.position = level.find_spawn_point(pos, MIN_DISTANCE * 2, MAX_DISTANCE)
	boss.died.connect(func(_enemy): current_number_of_enemies = current_number_of_enemies - 1)
	level.add_child(boss)

func spawn_end_boss():
	for spawn: EndBossSpawn in bosses:
		current_number_of_enemies += 1
		var boss: Boss = spawn.boss.instantiate()
		boss.is_end_boss = true
		var pos: Vector3
		if player:
			pos = player.global_position
		if spawn.is_random_position:
			boss.position = level.find_spawn_point(pos, MIN_DISTANCE * 2, MAX_DISTANCE)
		else:
			boss.position = spawn.spawn_position
		boss.died.connect(func(_enemy): current_number_of_enemies = current_number_of_enemies - 1)
		boss.end_boss_defeat.connect(func(_boss): check_for_boss())
		level.add_child(boss)

func check_for_boss():
	await get_tree().physics_frame
	for node in level.get_children():
		if node is Boss:
			return
	kill_enemies()
	level.set_win()

func kill_enemies():
	for node in level.get_children():
		if node is Enemy:
			node.queue_free()
	current_number_of_enemies = 0
