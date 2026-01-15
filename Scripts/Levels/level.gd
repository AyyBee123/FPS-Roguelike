class_name Level extends Node3D

@onready var nav_region: NavigationRegion3D = %NavigationRegion3D

@export var NUMBER_OF_CHESTS: int = 25
@export var NUMBER_OF_ARMORY_BOXES: int = 10

const XP = preload("uid://ukgrpto2cajc")

var time_left: float = 1200.0 # time in seconds (20 minutes, in this case)
var current_number_of_enemies: int

func _physics_process(delta):
	time_left = max(time_left - delta, 0)
	if time_left <= 0: # do stuff when countdown time reaches zero
		pass

func get_time_left() -> float:
	return time_left

func find_spawn_point(player_pos: Vector3, min_distance: float, max_distance: float) -> Vector3: # enemy spawn
	for i in 50:
		var pos: Vector3 = NavigationServer3D.map_get_random_point(nav_region.get_navigation_map(), 1, false)
		
		if pos == Vector3.ZERO:
			continue
		
		var plane_distance: float = Vector2(pos.x, pos.z).distance_to(Vector2(player_pos.x, player_pos.z))
		
		if plane_distance < min_distance or plane_distance > max_distance:
			continue
		
		return pos + Vector3(0, 1000, 0) # add to the y-axis to prevent enemies from spawning under the map
	
	return Vector3.ZERO

func find_chest_spawn() -> Vector3:
	var pos: Vector3 = NavigationServer3D.map_get_random_point(nav_region.get_navigation_map(), 1, false)
	return pos + Vector3(0, 1, 0) # add to the y-axis to prevent chests from spawning under the map
