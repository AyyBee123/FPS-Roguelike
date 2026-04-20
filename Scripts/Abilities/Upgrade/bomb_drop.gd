extends Ability

@export var BOMB: PackedScene

func _on_jump(_from_ground: bool):
	if _from_ground: return
	
	var bomb: RigidBody3D = BOMB.instantiate()
	bomb.player = player
	bomb.damage = get_stat_value("Damage")
	bomb.radius = get_stat_value("Range")
	get_tree().current_scene.add_child(bomb)
	player._on_weapon_spawned(bomb, bomb.damage)
	bomb.global_position = player.global_position - Vector3(0, 1, 0)
	bomb.linear_velocity = Vector3(0, -get_stat_value("Speed"), 0)
	var audio: DeconflictedAudioPlayer = DeconflictedAudioPlayer.new()
	audio.stream = preload("uid://ctyjwhsln6bqv")
	audio.pitch_scale = 1.5
	audio.max_db = 0
	audio.panning_strength = 0
	get_tree().current_scene.add_child(audio)
	audio.play_deconflicted()
	audio.global_position = player.global_position
	audio.finished.connect(audio.queue_free)

func give_initial_player_stats():
	player.stats.add_flat_stat("Extra_Jumps", 2)
