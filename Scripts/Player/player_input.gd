extends Node
class_name PlayerInput

@export var player_id = 1

signal onMove(direction : float)
signal onAttack(attack_input_name : String)


var is_right_held : bool = false
var is_left_held : bool = false

func _ready() -> void:
	print("Connected joypads: ", Input.get_connected_joypads())

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("move_right_%s" % [player_id]):
		if not is_right_held:
			is_right_held = true
			onMove.emit(1)
	if event.is_action_released("move_right_%s" % [player_id]):
		is_right_held = false
	
	if event.is_action_pressed("move_left_%s" % [player_id]):
		if not is_left_held:
			is_left_held = true
			onMove.emit(-1)
	if event.is_action_released("move_left_%s" % [player_id]):
		is_left_held = false
		#print("-1")
	
	if event.is_action_pressed("base_attack_%s" % [player_id]):
		onAttack.emit("base_attack_%s" % [player_id])
	
	if event.is_action_pressed("heavy_attack_%s" % [player_id]):
		onAttack.emit("heavy_attack_%s" % [player_id])
