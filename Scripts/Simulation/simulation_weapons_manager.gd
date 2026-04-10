extends Node3D

@onready var animation_player = %AnimationPlayer
@onready var arm = %Arm
@export var player: Player

var is_shoot_button_held := false
var current_arm = null
var pickup = null

func _ready():
	initialize()

func _physics_process(_delta):
	shoot()

func initialize():
	current_arm = arm.get_child(0) # get child of the arm node as the active arm (there should only be one child)

func swap_arm(_new_arm): # swaps out the old weapon for a new one
	for child in arm.get_children(): # in case there are somehow multiple
		arm.remove_child(child)
		child.queue_free()
	if is_instance_valid(current_arm):
		current_arm.queue_free()
	
	if _new_arm.get_parent():
		_new_arm.get_parent().remove_child(_new_arm)
	_new_arm.player = player
	current_arm = _new_arm
	arm.add_child(_new_arm)

func shoot():
	if current_arm.player == null:
		current_arm.player = player
	if current_arm:
		current_arm.shoot()

func release():
	if current_arm.player == null:
		current_arm.player = player
	if current_arm:
		current_arm.release()
