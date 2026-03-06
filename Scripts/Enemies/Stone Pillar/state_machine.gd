extends state_machine

var timer = Timer.new()
var random_attack: int
var num_of_attacks: int = 2
var is_slamming: bool = false

func _ready():
	create_timer()
	add_state("spawn")
	add_state("idle")
	add_state("idle_from_dig")
	add_state("spread")
	add_state("spin")
	add_state("contract")
	add_state("dig_down")
	add_state("dig_up")
	add_state("slam")
	set_state.call_deferred(states.spawn)
	# the random attacks are set up in the get_transition function
	random_attack = randi_range(0, num_of_attacks - 1)

func _state_logic(delta):
	pass
	if state == states.idle:
		parent.idle()
	if state == states.dig_up:
		parent.dig_up()
	if state == states.dig_down:
		parent.dig_down()
	if state == states.idle_from_dig:
		parent.idle()

func _get_transition(delta):
	match state:
		states.idle:
			if timer.is_stopped():
				if random_attack == 0:
					return states.dig_down
				if random_attack == 1:
					return states.spread
	return null

func _enter_state(new_state, old_state):
	match new_state:
		states.spawn:
			parent.animation_player.play_backwards("Spawn")
		states.idle:
			parent.animation_player.play("Idle")
			set_random_time(2, 5)
			set_random_attack()
		states.idle_from_dig:
			parent.animation_player.play("Idle")
			await get_tree().create_timer(0.3).timeout
			set_state(states.slam)
		states.dig_down:
			parent.animation_player.play("Dig Down")
			await get_tree().create_timer(1.5 + parent.animation_player.current_animation_length).timeout
			set_state(states.dig_up)
		states.dig_up:
			parent.set_dig_pos()
			parent.animation_player.play_backwards("Dig Down")
			await get_tree().create_timer(parent.animation_player.current_animation_length).timeout
			set_state(states.idle_from_dig)
		states.slam:
			parent.animation_player.play("Slam")
		states.spread:
			parent.animation_player.play("Spread")
		states.spin:
			parent.animation_player.play("Spin")
		states.contract:
			parent.animation_player.play_backwards("Spread")

func _exit_state(old_state, new_state):
	match old_state:
		states.spawn:
			parent.set_spawned()

func create_timer():
	add_child(timer)
	timer.one_shot = true
	set_random_time(2, 5)

func set_random_attack():
	random_attack = randi_range(0, num_of_attacks - 1)

func set_random_time(min: float, max: float):
	timer.start(randf_range(min, max))
