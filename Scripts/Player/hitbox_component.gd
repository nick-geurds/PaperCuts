extends Area2D
class_name HitBox

@export var health_component : HealthComponent

func Damage(attack : Attack):
	if health_component:
		health_component.TakeDamage(attack)
