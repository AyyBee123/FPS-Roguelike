extends Node

var number_of_enemies: int = 0
var MAX_NUMBER_OF_ENEMIES: int = 20
var MIN_AMOUNT_OF_ENEMIES: int = 10

const ENEMY = preload("uid://cynxew1ppvmlf")

var amount: int = 0

func _ready():
	pass
	#var i = 0
	#while i < TAU:
		#for j in range(16):
			#var enemy = ENEMY.instantiate()
			#get_tree().current_scene.add_child.call_deferred(enemy)
			#var pos = Vector2.from_angle(i) * (j + 10) * 4
			#await get_tree().physics_frame
			#enemy.global_transform.origin = Vector3(pos.x, 1, pos.y)
			#amount += 1
		#i += PI/6
	#print(amount)

func spawn_enemy():
	pass
