extends Node2D
class_name PlayerMovement

var _slot_manager : SlotLogic

var currentIndex : int

func _ready() -> void:
	_slot_manager = get_node("/root/MainScene/SlotManager")
	if _slot_manager != null:
		global_position = _slot_manager.slots_index[0]["position"]
		currentIndex = 0
	else:
		print("slotManager = null")

func _process(delta: float):
	if Input.is_action_just_pressed("move_right"):
		Handle_Input(1)
	
	if Input.is_action_just_pressed("move_left"):
		Handle_Input(-1)

func Handle_Input(direction : int):
	Check_Sots(direction)
	#currentIndex += direction
	#currentIndex = clamp(currentIndex, 0, _slot_manager.slots_amount - 1)
	
func Check_Sots(direction : int):
	var last_index = currentIndex
	var new_index = last_index + direction
	var second_check = last_index + (direction * 2)
	
	if _slot_manager.slots_index[new_index]["occupied"] == true:
		if second_check < _slot_manager.slots_amount and second_check >= 0:
			if _slot_manager.slots_index[second_check]["occupied"] == true:
				return
			else:
				currentIndex += (direction * 2)
		else:
			return
	else:
		currentIndex += direction
	
	currentIndex = clamp(currentIndex, 0 , _slot_manager.slots_amount - 1)
	global_position = _slot_manager.slots_index[currentIndex]["position"]
	_slot_manager.onPlayerMove.emit(last_index, currentIndex)
