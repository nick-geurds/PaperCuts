extends Area2D
class_name  HitBoxComponent

var damage : AttackData

func _on_area_entered(area: Area2D) -> void:
	if not area.is_in_group("hurtbox"):
		return
	
	var hitbox = area as HurtBoxComponent
	if hitbox:
		hitbox.Damage(damage)
