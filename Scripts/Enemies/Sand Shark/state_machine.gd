extends state_machine

var timer = Timer.new()
var attack_timer = Timer.new()
var random_attack: int
var num_of_attacks: int = 1

func _ready():
	create_timer()
	add_state("swim")
	add_state("prepare")
	add_state("charge")
	add_state("bite")
	add_state("wiggle")
	set_state.call_deferred(states.swim)
	# the random attacks are set up in the get_transition function
	random_attack = randi_range(0, num_of_attacks - 1)

func _state_logic(delta):
	if state == states.swim:
		parent.swim()
	if state == states.prepare:
		parent.prepare()
	if state == states.charge:
		parent.charge()

func _get_transition(delta):
	match state:
		states.swim:
			if timer.is_stopped():
				if random_attack == 0:
					return states.prepare
				#if random_attack == 1:
					#return states.wiggle
		states.prepare:
			if attack_timer.is_stopped():
				return states.charge
	return null

func _enter_state(new_state, old_state):
	match new_state:
		states.swim:
			parent.animation_player.play("Swim", -1, 0.5)
			set_random_time(3, 6)
		states.prepare:
			parent.animation_player.play("Swim", -1, 2)
			attack_timer.start(3)
		states.charge:
			parent.animation_player.play("Swim", -1, 3)
			parent.target = parent.player.global_position
		states.bite:
			parent.animation_player.play("Bite")
			parent.speed = parent.BASE_SPEED * 8
			parent.jump()

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
