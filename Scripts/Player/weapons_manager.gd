extends Node3D

@onready var animation_player = %AnimationPlayer
@onready var arm = %Arm
@onready var player = get_parent().get_parent()

const ARM_PICKUP = preload("uid://ba7erkb81ks3u")

var is_shoot_button_held := false
var current_arm = null
var pickup = null

func _ready():
	initialize()

func _physics_process(delta):
	if is_shoot_button_held and \
		(not animation_player.is_playing() or animation_player.current_animation == current_arm.shoot_animation):
		shoot()

func _input(event):
	if Input.is_action_pressed("shoot"):
		is_shoot_button_held = true
	else:
		is_shoot_button_held = false

func initialize():
	current_arm = arm.get_child(0) # get child of the arm node as the active arm (there should only be one child)
	enter()

func enter(): # call when weapon has been equipped after swapping the previous weapon out
	current_arm.player = player
	animation_player.play("Activate")

func swap_arm(_new_arm, pos): # swaps out the old weapon for a new one
	var pickup = ARM_PICKUP.instantiate()
	var scene = PackedScene.new()
	scene.pack(current_arm)
	pickup.arm = scene
	get_tree().current_scene.add_child(pickup)
	
	for child in arm.get_children(): # in case there are somehow multiple
		arm.remove_child(child)
	current_arm.queue_free()
	
	arm.add_child(_new_arm)
	current_arm = _new_arm
	enter()
	
	pickup.global_transform.origin = pos

func shoot():
	if current_arm:
		current_arm.shoot()
