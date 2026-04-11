extends Node2D
class_name PlayerMovement

var _slot_manager : SlotLogic

var currentIndex : int

func _ready() -> void:
	_slot_manager = get_node("/root/MainScene/SlotManager")
	if _slot_manager != null:
		global_position = _slot_manager.slot_positions[0]
		currentIndex = 0
	else:
		print("slotManager = null")

func _process(delta: float):
	if Input.is_action_just_pressed("move_right"):
		Handle_Input(1)
	
	if Input.is_action_just_pressed("move_left"):
		Handle_Input(-1)

func Handle_Input(direction : int):
	currentIndex += direction
	currentIndex = clamp(currentIndex, 0, _slot_manager.slots_amount - 1)
	global_position = _slot_manager.slot_positions[currentIndex]
	
