extends Node
class_name PlayerInput

signal onMove(direction : float)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("move_right"):
		onMove.emit(1)
		#print("1")
	
	if event.is_action_pressed("move_left"):
		onMove.emit(-1)
		#print("-1")
