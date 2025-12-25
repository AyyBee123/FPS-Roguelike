class_name Enemy extends CharacterBody3D

signal enemy_hit(source, enemy, damage_taken)

@onready var nav_agent: NavigationAgent3D = %NavigationAgent3D
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var on_screen_notifier: VisibleOnScreenNotifier3D = %VisibleOnScreenNotifier3D
@onready var ray_cast: RayCast3D = %RayCast
@onready var XP = get_tree().current_scene.XP

@export var mesh: Array[MeshInstance3D]
@export var raycast_offset: float = 0
@export var health: float = 25
@export var speed: float = 5
@export var xp_amount: int = 1

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var angular_acceleration: float = 5
var is_on_screen: bool = true
var object: RID
var tween: Tween

@onready var player = get_tree().get_first_node_in_group("Player")

func _ready():
	ray_cast.global_transform = Transform3D(Basis(), ray_cast.global_position) # lock the ray cast's rotation
	ray_cast.force_raycast_update() # detect the ground immediately
	position.y = ray_cast.get_collision_point().y + raycast_offset # snap the enemy to the ground (with offset)
	
	on_screen_notifier.screen_entered.connect(_on_screen_entered)
	on_screen_notifier.screen_exited.connect(_on_screen_exited)

func _physics_process(delta):
	pass

func target_position(target):
	pass

func hit(_damage: float, source_player: Player, source: Variant):
	health -= _damage
	player._on_enemy_hit(self, source, _damage)
	
	tween = get_tree().create_tween().set_parallel(true)
	for m in mesh:
		var mat: ShaderMaterial = m.material_overlay
		if mat and mat is ShaderMaterial:
			tween.tween_callback(func(): mat.set_shader_parameter("fade", 1.0))
			tween.tween_interval(0.05)
			tween.tween_method(func(v):
				mat.set_shader_parameter("fade", v),
				1.0, 0.0, 0.1
			)
	
	if health <= 0:
		die()

func die():
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

func _exit_tree():
	SignalBus.enemy_defeated.emit(self)
