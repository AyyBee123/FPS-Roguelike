extends MeshInstance3D
 
var player: Player = null
 
func _physics_process(_delta: float) -> void:
	if not player:
		var nodes = get_tree().get_nodes_in_group("Player")
		if nodes.is_empty():
			return
		player = nodes[0]
	set_instance_shader_parameter("player_position", player.global_position)
