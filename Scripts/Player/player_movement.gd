extends Node2D
class_name PlayerMovement

signal onDirectionChange(isFacingRight : bool)
signal onPlayerPositionChanged(observer_name : String, current_index : int, last_direction : int)
signal checkIfCanMove(ObserverName : String, index : int)
signal getPosition(ObserverName : String, index : int)

signal setDirection(isFacingRight : bool)

@export var player_state_machine : PlayerStateMachine
@export var moving_state : State
@onready var slot_data : SlotDataTransform = get_tree().current_scene.get_node("Slot_Data")

var lastDirection : float
var currentIndex : int

var debug_test : int = 0

func _ready() -> void:
	var player_id = get_parent() as PlayerInput
	#var startSlot : int = player_id.player_id
	var startSlot = player_id.start_slot #voor te testen
	lastDirection = 1
	position = slot_data.getStartPosition(startSlot)  # ← via slot_data ipv slot_manager direct
	currentIndex = startSlot
	
	slot_data.checkedSlotState.connect(CanMove)
	slot_data.setPositionSignal.connect(Move)
	onPlayerPositionChanged.connect(slot_data.updatePlayerPositionIndex)
	
	setDirection.emit(false)
	onPlayerPositionChanged.emit(name, currentIndex, lastDirection)

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
	onPlayerPositionChanged.emit(name ,currentIndex, lastDirection)

func CheckIfCanMove():
	#var new_index = currentIndex + direction
	#var new_index = slot_data.getNextSlotIndex(name ,1)
	#checkIfCanMove.emit(name, new_index)
	slot_data.reqeustMove(name, 1)
	

func CanMove(observer_name: String, isInRange: bool, isFree: bool, index: int):
	#if observer_name != name:
		#return
	#if not isInRange:
		#return
	#if isFree:
		#getPosition.emit(name, index)
	#else:
		#var second_index = slot_data.getNextSlotIndex(name ,2)  
		#if not slot_data.CheckIfInRange(second_index):
			#return
		#if slot_data.CheckIfSlotIsFree(second_index):
			#getPosition.emit(name, second_index)
	
	if observer_name != name:
		return
	if not isInRange:
		return
	if isFree:
		slot_data.setPosition(name, index)
	else:
		slot_data.reqeustSecondMove(name, 2)

func Move(observer_name : String, current_slot_index : int, slot_position : Vector2):
	if observer_name != name:
		return
	currentIndex = current_slot_index
	global_position = slot_position
	onPlayerPositionChanged.emit(name, currentIndex, lastDirection)
