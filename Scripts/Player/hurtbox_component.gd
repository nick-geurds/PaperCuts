extends Area2D
class_name HurtBoxComponent

@export var health_component : HealthComponent

func Damage(attack : AttackData):
	if health_component == null:
		return
	
	health_component.TakeDamage(attack)
