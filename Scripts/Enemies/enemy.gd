extends CharacterBody3D

@onready var nav_agent: NavigationAgent3D = %NavigationAgent3D
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var on_screen_notifier: VisibleOnScreenNotifier3D = %VisibleOnScreenNotifier3D
@onready var ray_cast: RayCast3D = %RayCast
@onready var XP = get_tree().current_scene.XP

@export var raycast_offset: float = 0
@export var health: float = 25
@export var speed: float = 5
@export var xp_amount: int = 1

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var angular_acceleration: float = 5
var is_on_screen: bool = true
var object: RID

@onready var player = get_tree().get_first_node_in_group("Player")

func _ready():
	position.y = ray_cast.get_collision_point().y + raycast_offset
	on_screen_notifier.screen_entered.connect(_on_screen_entered)
	on_screen_notifier.screen_exited.connect(_on_screen_exited)

func _physics_process(delta):
	pass

func target_position(target):
	pass

func hit(_damage):
	health -= _damage
	
	if health <= 0:
		die()

func die():
	SignalBus.enemy_defeated.emit(self)
	drop_xp()
	queue_free()

func drop_xp():
	var xp = XP.instantiate()
	xp.xp_amount = xp_amount
	xp.position = position
	xp.position.y = 1000
	get_tree().current_scene.add_child(xp)

func _on_screen_entered():
	animation_player.active = true
	is_on_screen = true

func _on_screen_exited():
	animation_player.active = false
	is_on_screen = false
