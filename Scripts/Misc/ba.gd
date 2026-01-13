extends Node3D

@onready var armature = %Armature

var marker: Node3D
var tween: Tween
var lifetime: float

func _ready():
	var direction = (marker.position - position).normalized()
	rotation.x = atan2(direction.y, direction.z) + PI
	rotation.y = atan2(direction.x, direction.z)
	
	var size = armature.scale
	armature.scale = Vector3.ONE
	
	tween = get_tree().create_tween()
	tween.tween_property(armature, "scale", size, 0.1)
	tween.parallel().tween_property(self, "position", marker.position, lifetime)
