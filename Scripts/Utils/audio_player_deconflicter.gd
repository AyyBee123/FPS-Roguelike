class_name DeconflictedAudioPlayer extends AudioStreamPlayer3D
## AudioStreamPlayer which ensures multiple copies of the same sound don't play simultaneously.

func _ready():
	# in case the bus has not been set in the inspector
	if get_bus() != "SFX":
		set_bus("SFX")

func play_deconflicted(from_position = 0.0) -> void:
	if volume_db <= -40: return
	if SfxDeconflicter.should_play(self):
		self.play(from_position)
