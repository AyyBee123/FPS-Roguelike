class_name Level extends Node3D

signal cost_increased

@onready var enemy_handler = %"Enemy Handler"
@onready var chest_manager = %"Chest Manager"
@onready var arm_pool = %"Arm Pool"
@onready var item_pool = %"Item Pool"
@onready var ability_pool = %"Ability Pool"
@onready var passive_pool = %"Passive Pool"
@onready var nav_region: NavigationRegion3D = %NavigationRegion3D

@export var NUMBER_OF_CHESTS: int = 25
@export var NUMBER_OF_ARMORY_BOXES: int = 10

@export var chest_cost: int = 20
@export var box_cost: int = 30

@export var boss_spawns: Array[BossSpawn]

const XP = preload("uid://ukgrpto2cajc")

var INITIAL_CHEST_COST: int
var INITIAL_BOX_COST: int

var number_of_chests_opened: int = 0

var time: float = 1200.0 # time in seconds (20 minutes, in this case)
var time_left: float = time
var elapsed_time: float = 0.0
var current_number_of_enemies: int = 0
var enemy_tier: int = 0:
	get:
		return floori(elapsed_time / 60)
var timeup: bool = false:
	get:
		return time_left <= 0

func _ready():
	INITIAL_CHEST_COST = chest_cost
	INITIAL_BOX_COST = box_cost

func _physics_process(delta):
	elapsed_time += delta
	time_left = max(time - elapsed_time, 0)
	# kill all remaining enemies and spawn the end boss when countdown time reaches zero
	if timeup and not enemy_handler.boss_spawned:
		enemy_handler.boss_spawned = true
		enemy_handler.kill_enemies()
		await get_tree().create_timer(1).timeout
		enemy_handler.spawn_end_boss()
	
	for spawn in boss_spawns:
		if spawn.time <= elapsed_time + 1:
			boss_spawns.erase(spawn)
			enemy_handler.spawn_boss(spawn)

func get_time_left() -> float:
	return time_left

func find_spawn_point(player_pos: Vector3, min_distance: float, max_distance: float) -> Vector3: # enemy spawn
	for i in 100:
		var pos: Vector3 = NavigationServer3D.map_get_random_point(nav_region.get_navigation_map(), 1, false)
		
		if pos == Vector3.ZERO:
			continue
		
		var plane_distance: float = Vector2(pos.x, pos.z).distance_to(Vector2(player_pos.x, player_pos.z))
		
		if plane_distance < min_distance or plane_distance > max_distance:
			continue
		
		return pos + Vector3(0, 1000, 0) # add to the y-axis to prevent enemies from spawning under the map
	
	return Vector3.ZERO

func find_chest_spawn() -> Vector3:
	var pos: Vector3 = NavigationServer3D.map_get_random_point(nav_region.get_navigation_map(), 1, false)
	return pos + Vector3(0, 1, 0) # add to the y-axis to prevent chests from spawning under the map

func increase_costs():
	number_of_chests_opened += 1
	box_cost = scale_cost(INITIAL_BOX_COST)
	chest_cost = scale_cost(INITIAL_CHEST_COST)
	cost_increased.emit()

func scale_cost(cost: int) -> int:
	return roundi(cost * exp(0.5 + (number_of_chests_opened - 1) * 0.1))

func set_win():
	print("You Win!")
