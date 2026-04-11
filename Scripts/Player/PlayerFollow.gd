extends Node2D
class_name PlayerVisual

@export var object_to_follow : Node2D
@export var follow_speed : float
@export var max_rotate_amount : float = 15

func _physics_process(delta: float) -> void:
	var target_position = object_to_follow.position
	position = position.lerp(target_position, delta * follow_speed)
	
	var distance_to_target_pos_x : float =  position.x - target_position.x
	rotation_degrees = clamp(distance_to_target_pos_x, -max_rotate_amount, max_rotate_amount)
	
