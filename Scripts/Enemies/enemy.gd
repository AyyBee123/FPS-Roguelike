extends CharacterBody3D

var health = 25

func hit(_damage):
	health -= _damage
	print(health)
	
	if health <= 0:
		queue_free()
