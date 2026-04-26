extends Node
class_name PlayerControllerSetup

signal updatePlayerSlotUI(device_index : int, player_selected : int)
signal updatePendingDevices(pending_devices : Array)
signal playersAssigned(assigned : bool)

var set_devices : Dictionary = {}
var pending_devices : Array = []

var axis_used : Dictionary = {}

func _input(event: InputEvent) -> void:
	var device_id : int = getDeviceId(event)
	if device_id == -99:
		return
		
	var is_left = false
	var is_right = false

	if event is InputEventKey:
		is_left = event.is_action_pressed("move_left")
		is_right =	event.is_action_pressed("move_right")
	elif event is InputEventJoypadButton:
		is_left = event.button_index == JOY_BUTTON_DPAD_LEFT
		is_right = event.button_index == JOY_BUTTON_DPAD_RIGHT
	elif event is InputEventJoypadMotion:
		if event.axis == JOY_AXIS_LEFT_X:
			if abs(event.axis_value) < 0.2:
				axis_used[event.device] = false
				return
			elif axis_used.get(event.device, false):
				return
			is_left = event.axis_value < -0.5
			is_right = event.axis_value > 0.5
			if is_left or is_right:
				axis_used[event.device] = true
	
	if set_devices.values().has(device_id):
		var slot = set_devices.find_key(device_id)
		if slot == 1 and is_right:
			unassignSlot(device_id)
		elif slot == 2 and is_left:
			unassignSlot(device_id)
		return
		
	if pending_devices.has(device_id):
		if is_left:
			assignSlot(device_id, 1)
		elif is_right:
			assignSlot(device_id, 2)
		return
	
	if not set_devices.values().has(device_id):
		if set_devices.size() + pending_devices.size() < 2:
			pending_devices.append(device_id)
			updatePendingDevices.emit(pending_devices)#update pending device UI

func getDeviceId(event: InputEvent) -> int:
	if event is InputEventKey and event.pressed and not event.echo:
		return -1
	if event is InputEventJoypadButton and event.pressed:
		return event.device
	if event is InputEventJoypadMotion:
		return event.device 
	return -99

func assignSlot(device_id : int, slot : int):
	if set_devices.has(slot):
		return
	set_devices[slot] = device_id
	pending_devices.erase(device_id)
	updatePlayerSlotUI.emit(device_id, slot)#update slot en pending UI
	
	if set_devices.size() >= 2:
		playersAssigned.emit(true)

func unassignSlot(device_id : int):
	for slot in set_devices.keys():
		if set_devices[slot] == device_id:
			set_devices.erase(slot)
			pending_devices.append(device_id)
			updatePendingDevices.emit(pending_devices)
			updatePlayerSlotUI.emit(-99, slot)
			playersAssigned.emit(false)
			return
		
func confirmAssignedController():
	for player in set_devices.keys():
		GameManager.assigned_controllers[player] = set_devices[player]
	print(GameManager.assigned_controllers)
	get_tree().change_scene_to_file("res://Scenes/Gameplay/TestGym.tscn")
