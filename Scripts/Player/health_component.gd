extends Node2D
class_name HealthComponent

@export var max_health : float = 6
var current_health : float

func _ready() -> void:
	current_health = max_health

func TakeDamage(amount : float):
	current_health -= amount
	
	if current_health <= 0:
		Die()

func Die():
	get_parent().queue_free()
