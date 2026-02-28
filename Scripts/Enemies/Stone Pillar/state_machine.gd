extends state_machine

var timer = Timer.new()
var attack_timer = Timer.new()
var random_attack: int
var num_of_attacks: int = 1

func _ready():
	create_timer()
	add_state("spawn")
	add_state("idle")
	add_state("spread")
	add_state("spin")
	add_state("dig_down")
	add_state("dig_up")
	add_state("slam")
	set_state.call_deferred(states.spawn)
	# the random attacks are set up in the get_transition function
	random_attack = randi_range(0, num_of_attacks - 1)

func _state_logic(delta):
	pass
	#if state == states.swim:
		#parent.swim()
	#if state == states.prepare:
		#parent.prepare()
	#if state == states.charge:
		#parent.charge()

func _get_transition(delta):
	match state:
		states.idle:
			pass
			#if timer.is_stopped():
				#if random_attack == 0:
					#return states.prepare
				#if random_attack == 1:
					#return states.wiggle
	return null

func _enter_state(new_state, old_state):
	match new_state:
		states.spawn:
			parent.animation_player.play_backwards("Spawn")
			set_random_time(3, 6)
		states.idle:
			parent.animation_player.play("Idle")
			attack_timer.start(3)

func _exit_state(old_state, new_state):
	match old_state:
		states.spawn:
			parent.set_spawned()

func create_timer():
	add_child(timer)
	timer.one_shot = true
	set_random_time(3, 6)
	
	add_child(attack_timer)
	attack_timer.one_shot = true

func animation_finished():
	random_attack = randi_range(0, num_of_attacks - 1)
	set_random_time(3, 6)

func set_random_time(min: float, max: float):
	timer.start(randf_range(min, max))
