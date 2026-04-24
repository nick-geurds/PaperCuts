extends Node2D
class_name HitBoxSetter

@export var offset : float = 120

func setHitboxPosition(isFacingRight : bool):
	var direction = -1 if isFacingRight else 1
	position.x = offset * direction
	
