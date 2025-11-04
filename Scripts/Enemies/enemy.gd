extends CharacterBody3D

@onready var nav_agent: NavigationAgent3D = %NavigationAgent3D
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var on_screen_notifier: VisibleOnScreenNotifier3D = %VisibleOnScreenNotifier3D

@export var health: float = 25
@export var speed: float = 5

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var angular_acceleration: float = 5
var is_on_screen: bool = true

@onready var player = get_tree().get_first_node_in_group("Player")

func _ready():
	on_screen_notifier.screen_entered.connect(_on_screen_entered)
	on_screen_notifier.screen_exited.connect(_on_screen_exited)

func _physics_process(delta):
	rotation = Vector3.ZERO

func target_position(target):
	pass

func hit(_damage):
	health -= _damage
	
	if health <= 0:
		queue_free()

func _on_screen_entered():
	animation_player.active = true
	is_on_screen = true

func _on_screen_exited():
	animation_player.active = false
	is_on_screen = false
