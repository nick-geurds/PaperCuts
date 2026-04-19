extends Node2D
class_name SlotBase

@export var slot_base_sprite : Sprite2D
@export var slot_state_machine : StateMachine

var slot_width : float

func _ready() -> void:
	slot_width = slot_base_sprite.get_rect().size.x
	

func is_free() -> bool:
	return not slot_state_machine.current_state is StateSlotOccupied
