extends Node
class_name StanimaComponent

@export var max_stanima : int
@export var stanima_recovery : float

var current_stanima : int

var stanima_recovery_timer = 0

func _ready() -> void:
	current_stanima = max_stanima

func hasEnoughStanimaLeft(stanima_cost : int) -> bool :
	var test = current_stanima - stanima_cost >= 0
	print(test)
	return current_stanima - stanima_cost >= 0
	

func reduceStamina(stanima_cost : int):
	current_stanima -= stanima_cost
	print(current_stanima)

func _process(delta: float) -> void:
	if current_stanima == max_stanima:
		return
	
	stanima_recovery_timer += delta
	
	if stanima_recovery_timer > stanima_recovery:
		stanima_recovery_timer = 0
		current_stanima += 1
