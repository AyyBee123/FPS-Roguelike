class_name Player extends CharacterBody3D

signal enemy_hit(enemy, source, damage) # called when the player hits an enemy with a weapon or ability
signal enemy_killed(enemy, source, damage) # called when the player kills an enemy with a weapon or ability
signal weapon_fired(projectile, damage) # called for each projectile of the weapon
signal weapon_shot(weapon, source) # called for each instance of the weapon (for adding recoil mainly)
signal weapon_spawned(projectile, damage) # called mainly for weapon after-effects (e.g. oil pool)
signal on_landing(impact_speed) # called when the player lands on the ground from the air
signal hit_taken(pos) # called when the player takes a hit
signal item_hovered(item) # called when an item is looked at with the crosshair and is within pickup range
signal item_picked(item) # called when an item is picked up (called from the item script)
signal arm_picked(_arm) # called when an arm is picked up

signal kill_count_changed(amount)
signal coin_count_changed(amount)
signal meta_coin_count_changed(amount)

@onready var camera = %Camera
@onready var animation_player = %AnimationPlayer
@onready var weapons_manager = %"Weapons Manager"
@onready var crosshair = %Crosshair
@onready var passives = %Passives
@onready var abilities = %Abilities
@onready var upgrade = %Upgrade
@onready var arm = %Arm
@onready var ability_slots = %"Ability Slots"
@onready var i_frames = %IFrames
@onready var pick_up_label = %"Pick Up Label"
@onready var xp_audio = %Xp
@onready var damage_taken_audio = %DamageTaken
@onready var jump = %Jump
@onready var land = %Land
@onready var pick_up = %"Pick Up"
@onready var buffs = %Buffs

const Stats = preload("uid://d0a7frb8gvg68")
const PASSIVE_MENU = preload("uid://clamkav36kau4")
const ABILITY_SLOT = preload("uid://y78kmes1pij6")
const DAMAGE_INDICATOR = preload("uid://cmwgutqrbavj5")

var stats: Stats
var XP_NEEDED: float = 5
var current_xp: float = 0
var current_level: int = 1
var upgrade_queue_count: int = 0 # the amount of level up choices that are in queue

var was_on_floor: bool = false
var speed_before_landing: float = 0.0
var friction: float = 50.0

var is_dead: bool = false

var kill_count: int = 0:
	set(value):
		kill_count = value
		kill_count_changed.emit(value)
var coin_count: int = 0:
	set(value):
		coin_count = value
		coin_count_changed.emit(value)
var meta_coin_count: int = 0:
	set(value):
		meta_coin_count = value
		meta_coin_count_changed.emit(value)

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
var PICKUP_RADIUS: float:
	get:
		return stats.get_stat("Pickup_Radius")

var current_health: float
var current_jumps: int = 0 # the current number of extra jumps that can be used
var pickup = null
var hovered_item = null
var number_of_abilities: int:
	get:
		return abilities.get_child_count()

func _init():
	stats = Stats.new()

func _ready():
	current_health = MAX_HEALTH
	stats.stat_changed.connect(get_health_difference)
	enemy_killed.connect(func(_enemy, _source, _damage): kill_count += 1)
	update_ability_slots()

func _physics_process(delta):
	# add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta * FALL_SPEED
	
	# get previous velocity
	var previous_velocity = velocity
	
	# recharge extra jumps
	if is_on_floor():
		current_jumps = NUMBER_OF_EXTRA_JUMPS
	
	# jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y += JUMP_HEIGHT
		jump.play_deconflicted()
	if Input.is_action_just_pressed("jump") and not is_on_floor() and current_jumps > 0:
		velocity.y += JUMP_HEIGHT
		current_jumps -= 1
		jump.play_deconflicted()
	
	# input direction and movement/deceleration
	var input_dir: Vector2 = Input.get_vector("left", "right", "up", "down")
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = velocity.lerp(direction * SPEED, delta * friction).x
		velocity.z = velocity.lerp(direction * SPEED, delta * friction).z
	else:
		velocity.x = velocity.lerp(Vector3.ZERO, delta * friction).x
		velocity.z = velocity.lerp(Vector3.ZERO, delta * friction).z
	
	move_and_slide()
	
	# check for landing
	if not was_on_floor and is_on_floor():
		land.play_deconflicted()
		speed_before_landing = previous_velocity.y
		on_landing.emit(speed_before_landing)
	was_on_floor = is_on_floor()
	
	pickup = get_pickup_collision()
	if pickup and pickup.has_method("highlight"):
		if pickup is Chest or pickup is ArmoryBox:
			if coin_count >= pickup.cost:
				pickup.highlight()
		else:
			pickup.highlight()
	if hovered_item and hovered_item.has_method("unhighlight") and not pickup:
		hovered_item.unhighlight()
	hovered_item = pickup
	item_hovered.emit(pickup)
	
	# check for level ups
	if upgrade_queue_count > 0 and upgrade.get_child_count() == 0:
		level_up()

func _input(event):
	if event.is_action_pressed("pickup") and pickup:
		if pickup is Chest or pickup is ArmoryBox:
			if coin_count >= pickup.cost:
				update_coins(-pickup.cost)
				pickup.open(self)
		else:
			pick_up.play_deconflicted()
			pickup.pick_up(self)

func get_pickup_collision():
	var viewport = get_viewport().get_visible_rect().size
	
	var ray_origin = camera.project_ray_origin(viewport / 2)
	var ray_end = ray_origin + camera.project_ray_normal(viewport / 2) * 4.0 # pickup range
	
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	query.collision_mask = CollisionLayers.get_layer(["Pickup"])
	
	var result = get_world_3d().direct_space_state.intersect_ray(query)
	
	if not result.is_empty():
		return result.collider
	else:
		return null

func hit(amount, pos):
	if not i_frames.is_stopped():
		return
	
	damage_taken_audio.play_deconflicted()
	
	if amount > 0.0:
		i_frames.start()
	
	current_health = clamp(0, current_health - amount, MAX_HEALTH)
	
	var dir = (pos - global_position).normalized()
	var forward = camera.global_transform.basis.z
	var right = camera.global_transform.basis.x
	
	var x = dir.dot(right)
	var y = dir.dot(forward)
	hit_taken.emit(Vector2(x, y))
	
	if current_health <= 0:
		die()

func die():
	if is_dead: return
	is_dead = true
	
	print("L")

func get_health_difference(stat, old_value, new_value):
	if stat != "Max_Health": return
	heal(new_value - old_value)

func heal(amount):
	current_health = clamp(0, current_health + amount, MAX_HEALTH)

func gain_xp(amount: int):
	xp_audio.play_deconflicted()
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

func update_coins(amount: int):
	coin_count += amount

func update_meta_coins(amount: int):
	meta_coin_count += amount

func _on_enemy_hit(enemy: Enemy, source: Variant, damage: float):
	enemy_hit.emit(enemy, source, damage)

func _on_enemy_killed(enemy: Enemy, source: Variant, damage: float):
	enemy_killed.emit(enemy, source, damage)

func _on_arm_fired(projectile: Variant, damage: float):
	weapon_fired.emit(projectile, damage)

func _on_arm_shot(_arm: Arm, _source: Variant):
	weapon_shot.emit(_arm, _source)

func _on_weapon_spawned(projectile: Variant, damage: float):
	weapon_spawned.emit(projectile, damage)

func get_arm():
	arm_picked.emit(arm.get_child(0))
	return arm.get_child(0)
