extends Sprite2D
class_name EntitieVisualFollower

@export var follow_speed : float = 15
@export var max_rotation : float = 15

@export var object_to_follow : Node2D

func _physics_process(delta: float) -> void:
	var target_position = object_to_follow.position
	position = position.lerp(target_position, delta * follow_speed)
	
	var distance_to_target_pos_x : float =  position.x - target_position.x
	rotation_degrees = clamp(distance_to_target_pos_x, -max_rotation, max_rotation)
	

#flip het karakter (puur visueel) in deze functie
func _on_player_holder_on_direction_change(isFacingRight: bool) -> void:
	if isFacingRight:
		flip_h = true
	else:
		flip_h = false
	
