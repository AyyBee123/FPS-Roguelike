extends DeconflictedAudioPlayerNot3D

@export var player: Player

func _ready():
	player.enemy_hit.connect(play_audio)

func play_audio(_enemy: Enemy, _source: Variant, _damage: float):
	play_deconflicted()
