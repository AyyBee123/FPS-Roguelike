class_name state_machine extends Node

var state = null: set = set_state
var previous_state = null
var states = {}

@onready var parent = get_parent()

func _physics_process(delta):
	if state != null:
		_state_logic(delta)
		var transition = _get_transition(delta)
		if transition != null:
			set_state(transition)

## get the state's functionality from the entity 
## (ex: get idle functionality from the idle function in the enemy's script)
func _state_logic(_delta):
	pass

## gets the next transisition from the previous state (ex: from idle to jumping) after a certain condition 
## like a timer timeout or the player getting close to the enemy
func _get_transition(_delta):
	return null

## this is mainly for animations and transitions. It pretty much does something when entering a state
## (ex: play "shoot" animation and shoot function when entering the shoot state)
func _enter_state(_new_state, _old_state):
	pass

## similar to _enter_state, but for exiting instead of entering
## (ex: play "tired" animation state after a strong attack, or start a timer after exiting a state)
func _exit_state(_old_state, _new_state):
	pass

func set_state(new_state):
	previous_state = state
	state = new_state
	
	if previous_state != null:
		_exit_state(previous_state, new_state)
	if state != null:
		_enter_state(new_state, previous_state)

func add_state(state_name):
	states[state_name] = states.size()
