extends Node
class_name SlotLogic


@export var main_camera : Camera2D
@export var size_padding_x : float
@export var slots_amount : int
@export var padding_per_slot : float

@export var slot_positions : Array[Vector2]

var slot_scene = preload("res://Scenes/slot.tscn")

var camera_size_x : float

func _ready() -> void:
	camera_size_x = main_camera.get_viewport_rect().end.x
	Calculate_Slots_Size()
	
func Calculate_Slots_Size() -> void:
	print(camera_size_x)
	var _new_witdh = camera_size_x - size_padding_x
	var _slot_size = (_new_witdh / slots_amount) - padding_per_slot
	var startposition = -(_new_witdh / 2) + (_slot_size / 2)
	print(_slot_size)
	
	Setup_Slots(startposition, _slot_size)
	
func Setup_Slots(startposition : float , slot_size : float ,startAmount : int = 0):
	while startAmount < slots_amount:
		var slot = slot_scene.instantiate()
		add_child(slot)
		
		var _position = Vector2(startposition + (startAmount * (slot_size + padding_per_slot)), 0)
		slot.global_position = _position
		
		var _slot_sprite : Sprite2D = slot.get_node("slot_sprite")
		_slot_sprite.region_enabled = true
		_slot_sprite.region_rect.size.x = slot_size
		_slot_sprite.modulate = Color(1,1,1,1)
		
		slot_positions.append(_position)
		
		startAmount += 1
		
	
	
	
