extends "res://Scripts/Enemies/enemy.gd"

@onready var skull = %Skull
@onready var fire = %Fire
@onready var shoot_time = %"Shoot Time"

const STONE_SKULL = preload("uid://crn3ys871kjtr")

var height: float = 6
var player_pos: Vector3
var can_shoot: bool = false

func _ready():
	super._ready()
	position.y = height
	for lib_name in animation_player.get_animation_library_list():
		animation_player.remove_animation_library(lib_name)
	
	animation_player.add_animation_library("default", STONE_SKULL)

func _physics_process(delta):
	super._physics_process(delta)
	move(delta)
	
	if can_shoot and shoot_time.is_stopped():
		shoot()

func move(delta):
	if position.distance_to(player_pos) > 15:
		position.x += (player_pos.x - position.x) * delta * speed
		position.z += (player_pos.z - position.z) * delta * speed
		position.y = lerp_angle(position.y, height, 0.2)
		can_shoot = false
	elif position.distance_to(player_pos) > 12:
		position.x += (player_pos.x - position.x) * delta * speed * 0.1
		position.z += (player_pos.z - position.z) * delta * speed * 0.1
		position.y = lerp_angle(position.y, height, 0.2)
		can_shoot = true
	else:
		can_shoot = true
	
	skull.look_at(player.global_transform.origin, Vector3.UP)

func shoot():
	print("shoot")
	shoot_time.start()

func target_position(target):
	player_pos = target
