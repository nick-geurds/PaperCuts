extends Node
class_name HealthComponent

@export var max_health : float = 6
var current_health : float

func _ready() -> void:
	current_health = max_health

func TakeDamage(attack : AttackData):
	current_health -= attack.damage_amount
	print(current_health)
	
	if current_health <= 0:
		Die()

func Die():
	get_parent().queue_free()
