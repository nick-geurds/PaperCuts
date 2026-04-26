extends CanvasLayer
class_name controllerTest

@export var label : Label

func _input(event: InputEvent) -> void:
	if event is InputEventJoypadMotion and not event.is_echo():
		var device_index : int = event.device
		setLabelText(device_index)


func setLabelText(index : int):
	label.text = "Player 1 = device " + str(index)
