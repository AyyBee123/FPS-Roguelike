extends Node3D

@export var current_arm: ArmResource = preload("uid://7oq3l5eppvcq")

@onready var animation_player = %AnimationPlayer
@onready var fire_rate_timer = %"Fire Rate Timer"

var is_shoot_button_held := false

func _ready():
	initialize()

func _physics_process(delta):
	if is_shoot_button_held and fire_rate_timer.is_stopped() and \
		(not animation_player.is_playing() or animation_player.current_animation == current_arm.shoot_animation):
		shoot()

func _input(event):
	if Input.is_action_pressed("shoot"):
		is_shoot_button_held = true
	else:
		is_shoot_button_held = false

func initialize():
	enter()

func enter(): # call when weapon has been equipped after swapping the previous weapon out
	fire_rate_timer.stop()
	fire_rate_timer.wait_time = 1.0 / current_arm.fire_rate
	
	animation_player.queue(current_arm.equip_animation)

func swap_arm(_new_arm: ArmResource): # swaps out the old weapon for a new one
	current_arm = _new_arm
	enter()

func shoot():
	fire_rate_timer.start()
	animation_player.stop()
	animation_player.play(current_arm.shoot_animation)
