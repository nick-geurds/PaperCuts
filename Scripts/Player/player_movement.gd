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

var player_name : String

func _ready() -> void:
	player_name = get_parent().name
	print("player_name: ", player_name)
	var player_id = get_parent() as PlayerInput
	var startSlot = player_id.start_slot
	lastDirection = 1
	position = slot_data.getStartPosition(startSlot)
	currentIndex = startSlot
	
	slot_data.checkedSlotState.connect(CanMove)
	slot_data.setPositionSignal.connect(Move)
	onPlayerPositionChanged.connect(slot_data.updatePlayerPositionIndex)
	
	setDirection.emit(false)
	onPlayerPositionChanged.emit(player_name, currentIndex, lastDirection)

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
	onPlayerPositionChanged.emit(player_name ,currentIndex, lastDirection)

func CheckIfCanMove():
	slot_data.reqeustMove(player_name, 1)
	

func CanMove(observer_name: String, isInRange: bool, isFree: bool, index: int):
	if observer_name != player_name:
		return
	if not isInRange:
		return
	if isFree:
		slot_data.setPosition(player_name, index)
	else:
		var next = slot_data.getNextSlotIndex(player_name, 2)
		if slot_data.CheckIfInRange(next) and slot_data.CheckIfSlotIsFree(next):
			slot_data.setPosition(player_name, next)

func Move(observer_name : String, current_slot_index : int, slot_position : Vector2):
	if observer_name != player_name:
		return
	currentIndex = current_slot_index
	global_position = slot_position
	onPlayerPositionChanged.emit(player_name, currentIndex, lastDirection)
