extends Node2D
class_name PlayerMovement

signal onDirectionChange(isFacingRight : bool)

@onready var slot_manager : SlotManager = get_tree().root.get_node("Main").get_node("SlotManager")

var lastDirection : float
var currentIndex : int

func _ready() -> void:
	position = slot_manager.slot_index[0].position
	currentIndex = 0
	lastDirection = 1

func _on_player_on_move(direction: float) -> void:
	if direction != lastDirection:
		if direction < 0:
			onDirectionChange.emit(false)
			print("Direction has changed, new direction = left" )
		else :
			onDirectionChange.emit(true)
			print("Direction has changed, new direction = right" )
	else:
		CheckIfCanMove(direction)
	
	lastDirection = direction

func CheckIfCanMove(direction : float):
	var new_index = currentIndex + direction
	
	currentIndex = new_index
	
	currentIndex = clamp(currentIndex,0, slot_manager.slot_amount - 1)
	global_position = slot_manager.slot_index[currentIndex].position
