class_name Boss extends Enemy

signal boss_spawned(boss)
signal end_boss_defeat(boss)

@export var boss_name: String

var is_end_boss: bool = false

func _ready():
	ray_cast.global_transform = Transform3D(Basis(), ray_cast.global_position) # lock the ray cast's rotation
	ray_cast.force_raycast_update() # detect the ground immediately
	position.y = ray_cast.get_collision_point().y + raycast_offset # snap the enemy to the ground (with offset)
	
	on_screen_notifier.screen_entered.connect(_on_screen_entered)
	on_screen_notifier.screen_exited.connect(_on_screen_exited)

func set_spawned():
	boss_spawned.emit(self)

func die(_damage: float, source_player: Player, source: Variant):
	if is_dead: return
	is_dead = true
	
	source_player._on_enemy_killed(self, source, _damage)
	# probably play an animation first and queue when the animation is done
	queue_free()

func _exit_tree():
	super._exit_tree()
	if is_end_boss:
		end_boss_defeat.emit(self)
