class_name DeconflictedAudioPlayerNot3D extends AudioStreamPlayer
## AudioStreamPlayer which ensures multiple copies of the same sound don't play simultaneously.

func play_deconflicted(from_position = 0.0) -> void:
	if SfxDeconflicter.should_play(self):
		self.play(from_position)
