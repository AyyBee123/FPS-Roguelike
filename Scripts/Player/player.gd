class_name Player extends CharacterBody3D

signal enemy_hit(enemy, source, damage)
signal weapon_fired(projectile, damage)
signal weapon_spawned(projectile, damage)

@onready var camera = %Camera
@onready var camera_controller_anchor = %"Camera Controller Anchor"
@onready var animation_player = %AnimationPlayer
@onready var weapons_manager = %"Weapons Manager"
@onready var passives = %Passives
@onready var abilities = %Abilities
@onready var upgrade = %Upgrade
@onready var arm = %Arm
@onready var ability_slots = %"Ability Slots"
@onready var i_frames = $IFrames

const Stats = preload("uid://d0a7frb8gvg68")
const PASSIVE_MENU = preload("uid://clamkav36kau4")
const ABILITY_SLOT = preload("uid://y78kmes1pij6")

var stats: Stats
var XP_NEEDED: float = 5
var current_xp: float = 0
var current_level: int = 1
var upgrade_queue_count: int = 0 # the amount of level up choices that are in queue

var MAX_HEALTH: float:
	get:
		return stats.get_stat("Max_Health")
var SPEED: float:
	get:
		return stats.get_stat("Move_Speed")
var JUMP_HEIGHT: float:
	get:
		return stats.get_stat("Jump_Height")
var FALL_SPEED: float:
	get:
		return stats.get_stat("Fall_Speed")
var NUMBER_OF_EXTRA_JUMPS: int:
	get:
		return stats.get_stat("Extra_Jumps")
var XP_MULTIPLIER: float:
	get:
		return stats.get_stat("XP_Gained")
var LUCK_MULTIPLIER: float:
	get:
		return stats.get_stat("Luck")

var current_health: float
var current_jumps: int = 0 # the current number of extra jumps that can be used
var pickup = null
var nearby_pickups: Array = []
var number_of_abilities: int:
	get:
		return abilities.get_child_count()

func _init():
	stats = Stats.new()

func _ready():
	current_health = MAX_HEALTH
	update_ability_slots()

func _physics_process(delta):
	# add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta * FALL_SPEED
	# recharge extra jumps
	if is_on_floor():
		current_jumps = NUMBER_OF_EXTRA_JUMPS
	
	# jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_HEIGHT
	if Input.is_action_just_pressed("jump") and not is_on_floor() and current_jumps > 0:
		velocity.y = JUMP_HEIGHT
		current_jumps -= 1
	
	# input direction and movement/deceleration
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()
	
	if nearby_pickups.size() > 0:
		pickup = get_pickup_collision()
	
	get_tree().call_group("Enemy", "target_position", global_position)
	
	# check for level ups
	if upgrade_queue_count > 0 and upgrade.get_child_count() == 0:
		level_up()

func _input(event):
	if event.is_action_pressed("pickup") and pickup:
		pickup.pick_up(self)

func get_pickup_collision():
	var camera = get_viewport().get_camera_3d()
	var viewport = get_viewport().size
	
	var ray_origin = camera.project_ray_origin(viewport / 2)
	var ray_end = ray_origin + camera.project_ray_normal(viewport / 2) * 3.0
	
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	query.collision_mask = CollisionLayers.get_mask(["Pickup"])
	
	var result = get_world_3d().direct_space_state.intersect_ray(query)
	
	if not result.is_empty():
		return result.collider
	else:
		return null

func hit(amount):
	if not i_frames.is_stopped():
		return
	
	if amount > 0.0:
		i_frames.start()
	
	current_health = clamp(0, current_health - amount, MAX_HEALTH)
	
	if current_health <= 0:
		die()

func die():
	pass

func heal(amount):
	current_health = clamp(0, current_health + amount, MAX_HEALTH)

func gain_xp(amount: int):
	current_xp += amount * XP_MULTIPLIER
	if current_xp >= XP_NEEDED:
		current_xp -= XP_NEEDED
		if current_level == 1: # increases xp required to reach level 2 by 5 (from 5 XP to 10 XP)
			XP_NEEDED += 5
		else:
			XP_NEEDED += 10 # increases xp required to reach the next level by 10
		upgrade_queue_count += 1
		# if the amount of xp still reaches or exceeds the xp needed, recall the function to level up again
		if current_xp >= XP_NEEDED:
			gain_xp(0)

func level_up():
	upgrade_queue_count -= 1
	var passive_menu = PASSIVE_MENU.instantiate()
	passive_menu.upgrade_selected.connect(get_upgrade)
	passive_menu.player = self
	upgrade.add_child(passive_menu)
	current_level += 1

func get_upgrade(_upgrade):
	if _upgrade is Array[Passive]:
		for i in _upgrade:
			i.add_stats(self)
			i.queue_free()
	elif _upgrade is Ability:
		if not _upgrade.ability_exists: # add a new instance of the ability if the player doesn't have it
			abilities.add_child(_upgrade.duplicate())
		else: # upgrade the ability if the player already has an instance in their "Abiliies" node
			for ability in abilities.get_children():
				if _upgrade.ability_name == ability.ability_name:
					ability.add_stats(_upgrade.upgrades_to_add) # add the stats to the existing ability
					ability.level += 1 # level up ability after it recieves the upgrade
					break
		update_ability_slots()

func update_ability_slots():
	for slot in ability_slots.get_children():
		slot.queue_free()
	
	for ability in abilities.get_children():
		var slot = ABILITY_SLOT.instantiate()
		slot.ability = ability
		ability_slots.add_child(slot)

func _on_pickup_detect_body_entered(body):
	nearby_pickups.append(body)

func _on_pickup_detect_body_exited(body):
	nearby_pickups.erase(body)

func _on_enemy_hit(enemy: Enemy, source: Variant, damage: float):
	enemy_hit.emit(enemy, source, damage)

func _on_arm_fired(projectile: Variant, damage: float):
	weapon_fired.emit(projectile, damage)

func _on_weapon_spawned(projectile: Variant, damage: float):
	weapon_spawned.emit(projectile, damage)

func get_arm():
	return arm.get_child(0)
