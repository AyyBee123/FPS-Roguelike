extends Arm

@onready var bullet_point_2 = %"Bullet Point 2"

func shoot():
	super.shoot()
	
	if t < fire_rate_timer: return
	
	if muzzle:
		var m = muzzle.instantiate()
		m.set_color(muzzle_color)
		bullet_point_2.add_child(m)
