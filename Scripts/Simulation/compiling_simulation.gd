extends Level

@export var player: Player

@onready var arm_pickup_spawn_point = %"Arm Pickup Spawn".global_position
@onready var enemy_spawn_point = %"Enemy Spawn".global_position
@onready var level_spawn_point = %"Level Spawn".global_position

const ARM_PICKUP = preload("uid://ba7erkb81ks3u")
const DUMMY = preload("uid://dg3j4d78oaqdx")

var arm_list: Array[PackedScene]
var level_list: Array[PackedScene]
var enemy_list: Array[PackedScene]
var item_list: Array[PackedScene]

var arms_done: bool = false
var enemies_done: bool = false
var levels_done: bool = false
var final_enemy_spawned: bool = false

func _ready():
	enemy_handler.player = player
	GameState.current_level = self
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	Engine.set_time_scale(10.0)
	
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
	
	spawn_arms()
	
	load_from_folder("res://Scenes/Levels/", level_list)
	spawn_levels()
	
	load_from_folder("res://Scenes/Enemies/", enemy_list)
	spawn_enemies()

func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	elif event is InputEventJoypadMotion and abs(event.axis_value) > Settings.deadzone:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	elif event is InputEventMouseMotion:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _physics_process(delta):
	%Icon.rotation += 2.0 * delta / Engine.get_time_scale()
	
	if arms_done and levels_done and enemies_done and not final_enemy_spawned:
		final_enemy_spawned = true
		spawn_enemy()
	
	GameState.current_level = self

func spawn_arms():
	for arm in arm_pool.common_pool:
		arm_list.append(arm)
	for arm in arm_pool.uncommon_pool:
		arm_list.append(arm)
	for arm in arm_pool.legendary_pool:
		arm_list.append(arm)
	
	for arm in arm_list:
		# spawn the arm pickup
		var pickup: ArmPickup = ARM_PICKUP.instantiate()
		pickup.arm_scene = arm
		add_child(pickup)
		pickup.global_position = arm_pickup_spawn_point
		
		await get_tree().create_timer(1.0).timeout
		
		# make the simulation player pick up the arm
		pickup.pick_up(player)
		
		# make the player fire the arm for one second
		await get_tree().create_timer(1.0).timeout
	
	# spawn the spark plug arm pickup
	var pickup: ArmPickup = ARM_PICKUP.instantiate()
	pickup.arm_scene = preload("uid://coqndvgnv7fvf")
	add_child(pickup)
	pickup.global_position = arm_pickup_spawn_point
	
	await get_tree().physics_frame
	await get_tree().physics_frame
	
	# make the simulation player pick up the arm
	pickup.pick_up(player)
	
	give_abilities()
	give_items()

func give_abilities():
	for ability in ability_pool.abilities:
		var a = ability.instantiate()
		player.get_upgrade(a)

func give_items():
	for item in item_pool.common_pool:
		item_list.append(item)
	for item in item_pool.uncommon_pool:
		item_list.append(item)
	for item in item_pool.legendary_pool:
		item_list.append(item)
	
	for item in item_list:
		var i = item.instantiate()
		i.on_pick_up(player)
	
	arms_done = true

func spawn_levels():
	for level in level_list:
		var lvl = level.instantiate()
		add_child(lvl)
		lvl.global_position = level_spawn_point
		await get_tree().create_timer(2.0).timeout
		lvl.queue_free()
	
	levels_done = true

func spawn_enemies():
	for enemy in enemy_list:
		var e: Enemy = enemy.instantiate()
		enemy_handler.spawn_enemy(e)
		await get_tree().create_timer(5.0).timeout
	
	enemies_done = true

func spawn_enemy():
	var dummy: Enemy = DUMMY.instantiate()
	add_child(dummy)
	dummy.global_position = enemy_spawn_point
	%"Scene Timer".start()

func find_chest_spawn() -> Vector3:
	return Vector3.ONE

func get_time_left() -> float:
	return 0.0

func load_from_folder(path: String, array: Array) -> void:
	var dir = DirAccess.open(path)
	if dir == null:
		push_error("Could not open directory: " + path)
		return
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".tscn"):
			var full_path = path + file_name
			var scene = load(full_path) as PackedScene
			if scene:
				array.append(scene)
		file_name = dir.get_next()
	
	dir.list_dir_end()

func change_scene():
	get_tree().change_scene_to_packed(preload("uid://bhk4jon3yjyso"))

func _exit_tree():
	GameState.current_level = null
	GameState.selected_character = null
	GameState.selected_level = null
	Engine.set_time_scale(1.0)

func _on_scene_timer_timeout():
	change_scene()
