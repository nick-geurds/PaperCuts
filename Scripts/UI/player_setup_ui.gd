extends CanvasLayer
class_name PlayerControllerSetupUI

@export var player_1_label : Label
@export var player_2_label : Label
@export var confirm_button : Button

func _ready() -> void:
	confirm_button.visible = false

func updateSlotUI(device_id : int, slot : int):
	var label = player_1_label if slot == 1 else player_2_label
	if device_id == -99:
		label.text = ""
	else:
		var name = "keyboard + mouse" if device_id == -1 else "controller"
		label.text = "Player " + str(slot) + ": " + name + "(" + str(device_id) + ")"

func updatePendingUI(pending_devices : Array):
	pass

func setConfirmButtonVibility(isVisible : bool):
	confirm_button.visible = isVisible
