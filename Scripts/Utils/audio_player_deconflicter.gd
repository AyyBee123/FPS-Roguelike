class_name DeconflictedAudioPlayer extends AudioStreamPlayer3D
## AudioStreamPlayer which ensures multiple copies of the same sound don't play simultaneously.

func _ready():
	# in case the bus has not been set in the inspector
	if get_bus() != "SFX":
		set_bus("SFX")
