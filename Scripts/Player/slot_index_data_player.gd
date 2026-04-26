extends Node
class_name SlotDataTransform

signal checkedSlotState (observer_name : String, isInRange : bool, isFree : bool, index : int)
signal setPositionSignal(observer_name : String, current_slot_index : int,slot_position : Vector2)

@export var slot_manager : SlotManager

var player_data : Dictionary = {}

var slot_width : float

var current_player_postion_index : int
var last_player_direction

#-----------------------------------------------------------------
#-----------------------------------------------------------------
func _ready() -> void:
	await slot_manager.slot_width
	slot_width = slot_manager.slot_width
#-----------------------------------------------------------------
#-----------------------------------------------------------------
func getStartPosition(start_index : int) -> Vector2:
	return slot_manager.slot_index[start_index].position

func reqeustMove(obeserver_name : String, steps : int):
	var index = getNextSlotIndex(obeserver_name, steps)
	CheckSlotState(obeserver_name, index)

func reqeustSecondMove(obeserver_name : String, steps : int):
	var index = getNextSlotIndex(obeserver_name, steps)
	CheckSlotState(obeserver_name, index)
#-----------------------------------------------------------------
#-----------------------------------------------------------------

func updatePlayerPositionIndex(observer_name : String ,slot_index : int, player_direction : int):
	player_data[observer_name] = {
		"index": slot_index,
		"direction": player_direction
	}

#-----------------------------------------------------------------
#-----------------------------------------------------------------
func CheckSlotState(observer_name : String, index : int):
	var isInRange = CheckIfInRange(index)
	var isFree = false
	if isInRange:
		isFree = CheckIfSlotIsFree(index)
	checkedSlotState.emit(observer_name, isInRange, isFree, index)

func CheckIfInRange(index : int) -> bool:
	return index < slot_manager.slot_index.size() and index >= 0
	
func CheckIfSlotIsFree(index : int) -> bool:
	var target_slot = slot_manager.slot_index[index] as SlotBase
	return target_slot.is_free()
	
func getNextSlotIndex(observer_name : String ,steps: int) -> int:
	var data = player_data.get(observer_name, {"index": 0, "direction": 1})
	return data["index"] + (data["direction"] * steps)
#-----------------------------------------------------------------
#-----------------------------------------------------------------
func setPosition(observer_name: String ,index : int):
	var target_position : Vector2 = getPosition(index)
	setPositionSignal.emit(observer_name, index ,target_position)
	
func getPosition(index : int) -> Vector2:
	var target_slot : Vector2 = slot_manager.slot_index[index].position
	return target_slot
