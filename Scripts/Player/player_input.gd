extends Node
class_name PlayerInput

var start_slot : int

signal onMove(direction : float)
signal onMoveInput()
signal onAttackInput(attack_input_name : String)
signal onParryInput()

var isPlayerOne : bool

var is_right_held : bool = false
var is_left_held : bool = false
var assigned_device : int = -1

func _ready() -> void:
	if isPlayerOne:
		assigned_device = GameManager.assigned_controllers.get(1, -99)
	else:
		assigned_device = GameManager.assigned_controllers.get(2, -99)

func _unhandled_input(event: InputEvent) -> void:
	if not isMyDevice(event):
		return
		
	var is_left = false
	var is_right = false
	var is_left_released = false
	var is_right_released = false
	
	if event is InputEventKey:
		is_left = event.is_action_pressed("move_left")
		is_right = event.is_action_pressed("move_right")
		is_left_released = event.is_action_released("move_left")
		is_right_released = event.is_action_released("move_right")
	elif event is InputEventJoypadButton:
		is_left = event.button_index == JOY_BUTTON_DPAD_LEFT and event.pressed
		is_right = event.button_index == JOY_BUTTON_DPAD_RIGHT and event.pressed
		is_left_released = event.button_index == JOY_BUTTON_DPAD_LEFT and not event.pressed
		is_right_released = event.button_index == JOY_BUTTON_DPAD_RIGHT and not event.pressed
	elif event is InputEventJoypadMotion and event.axis == JOY_AXIS_LEFT_X:
		if abs(event.axis_value) < 0.2:
			is_left_released = true
			is_right_released = true
		else:
			is_left = event.axis_value < -0.5
			is_right = event.axis_value > 0.5
	
	if is_right and not is_right_held:
		is_right_held = true
		onMove.emit(1)
		onMoveInput.emit()
	if is_right_released:
		is_right_held = false
	
	if is_left and not is_left_held:
		is_left_held = true
		onMove.emit(-1)
		onMoveInput.emit()
	if is_left_released:
		is_left_held = false
	
	if event is InputEventKey or event is InputEventJoypadButton:
		if event.is_action_pressed("base_attack"):
			onAttackInput.emit("base_attack")
		if event.is_action_pressed("heavy_attack"):
			onAttackInput.emit("heavy_attack")
		if event.is_action_pressed("parry"):
			onParryInput.emit()

func isMyDevice(event: InputEvent) -> bool:
	if assigned_device == -1:
		return event is InputEventKey
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		return event.device == assigned_device
	return false
