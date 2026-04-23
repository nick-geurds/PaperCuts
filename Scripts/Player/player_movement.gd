extends Node2D
class_name PlayerMovement

signal onDirectionChange(isFacingRight : bool)
signal onPlayerPositionChanged(current_index : int, last_direction : int)
signal checkIfCanMove(ObserverName : String, index : int)
signal getPosition(ObserverName : String, index : int)

@export var player_state_machine : PlayerStateMachine
@export var moving_state : State
@export var slot_data : SlotDataTransform

var lastDirection : float
var currentIndex : int

var debug_test : int = 0

func _ready() -> void:
	#var player_input = get_parent() as PlayerInput
	var startSlot : int
	startSlot = 0
	if startSlot == 0 :
		lastDirection = 1
	position = slot_data.slot_manager.slot_index[startSlot].position
	currentIndex = startSlot
	checkIfCanMove.connect(slot_data.CheckSlotState)
	slot_data.checkedSlotState.connect(CanMove)
	getPosition.connect(slot_data.setPosition)
	slot_data.setPositionSignal.connect(Move)
	onPlayerPositionChanged.connect(slot_data.updatePlayerPositionIndex)
	
	onPlayerPositionChanged.emit(currentIndex, lastDirection)
	
	print("state machine = " + str(player_state_machine))
	

func _on_player_on_move(direction: float) -> void:
	
	if !player_state_machine.can_move():
		return
		
	if direction != lastDirection:
		if direction < 0:
			onDirectionChange.emit(true)
		else :
			onDirectionChange.emit(false)
	else:
		CheckIfCanMove()
	
	lastDirection = direction
	onPlayerPositionChanged.emit(currentIndex, lastDirection)

func CheckIfCanMove():
	#var new_index = currentIndex + direction
	var new_index = slot_data.getNextSlotIndex(1)
	checkIfCanMove.emit(name, new_index)
	

func CanMove(observer_name : String, isInRange : bool , isFree : bool, index : int):
	if observer_name != name:
		return
	
	if not isInRange:
		return
		
	if isFree:
		getPosition.emit(name, index)
	else:
		var second_index = slot_data.getNextSlotIndex(2)  
		
		if not slot_data.CheckIfInRange(second_index):
			return
		
		if slot_data.CheckIfSlotIsFree(second_index):
			getPosition.emit(name, second_index)
			
func Move(observer_name : String, current_slot_index : int, slot_position : Vector2):
	if observer_name != name:
		return
	currentIndex = current_slot_index
	global_position = slot_position
	onPlayerPositionChanged.emit(currentIndex, lastDirection)
