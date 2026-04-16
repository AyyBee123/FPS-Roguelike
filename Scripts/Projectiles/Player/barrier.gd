extends Node3D

@onready var collision_shape_3d = %CollisionShape3D
@onready var animation_player = %AnimationPlayer
@onready var position_node = %"Position Node"

var player: Player
var arm: Arm

var knockback_data: Dictionary = {} # {Enemy: velocity}

func _ready():
	collision_shape_3d.disabled = true

func _physics_process(delta):
	if not arm:
		queue_free()
		return
	
	for body in knockback_data.keys():
		if not is_instance_valid(body):
			knockback_data.erase(body)
			continue
		
		knockback_data[body] = knockback_data[body].move_toward(Vector3.ZERO, 50.0 * delta)
		body.move_and_collide(knockback_data[body] * delta)
		
		if knockback_data[body].length() < 0.1:
			knockback_data.erase(body)

func push():
	if not arm: return
	
	animation_player.stop()
	var anim: Animation = animation_player.get_animation("push")
	var distance: Vector3 = Vector3(0, 0, arm.range / 10.0)
	anim.track_set_key_value(1, 2, -distance)
	anim.track_set_key_value(1, 3, -distance * 1.25)
	
	animation_player.play("push", -1, arm.fire_rate)

func _on_area_3d_body_entered(body):
	if body is Enemy:
		if arm and player:
			body.hit(arm.damage, player, self)
			var direction = -player.camera.global_transform.basis.z
			knockback_data[body] = direction * arm.speed / 2.0
