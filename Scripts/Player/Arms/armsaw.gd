extends Arm

@onready var saw = %Saw

func _physics_process(delta):
	super._physics_process(delta)
	saw.rotation.x -= PI/2 * delta
