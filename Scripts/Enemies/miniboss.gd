class_name Miniboss extends Enemy

@export var boss_name: String

const MINIBOSS_SPAWN_VFX = preload("uid://3t4q01uo2ubp")

func _ready():
	all.append(self)
	
	ray_cast.global_transform = Transform3D(Basis(), ray_cast.global_position) # lock the ray cast's rotation
	ray_cast.force_raycast_update() # detect the ground immediately
	position.y = ray_cast.get_collision_point().y + raycast_offset # snap the enemy to the ground (with offset)
	
	on_screen_notifier.screen_entered.connect(_on_screen_entered)
	on_screen_notifier.screen_exited.connect(_on_screen_exited)
	
	SignalBus.boss_spawned.emit(self)
	
	var spawn_vfx = MINIBOSS_SPAWN_VFX.instantiate()
	spawn_vfx.position = position
	get_tree().current_scene.add_child(spawn_vfx)
