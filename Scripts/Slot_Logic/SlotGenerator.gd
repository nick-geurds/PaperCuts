extends Node
class_name SlotLogic

signal onPlayerMove(last_index : int, new_index : int)

@export var main_camera : Camera2D
@export var size_padding_x : float
@export var slots_amount : int
@export var padding_per_slot : float

@export var slot_positions : Array[Vector2]
@export var slot_state : Array[bool]

@export var slots_index : Array = []

var slot_scene = preload("res://Scenes/slot.tscn")

var camera_size_x : float

func _ready() -> void:
	onPlayerMove.connect(SetOccupied)
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
		
		
		slot_positions.append(_position)
		slots_index.append({"position" : Vector2(_position), "occupied" : false, "sprite" : _slot_sprite})
		
		if startAmount not in [3, slots_amount - 2,slots_amount - 1]:
			slots_index[startAmount]["occupied"] = false
		else :
			slots_index[startAmount]["occupied"] = true
		
		#if slots_index[startAmount]["occupied"] == true:
			#_slot_sprite.modulate = Color(1,0,0,1)
		#else:
			#_slot_sprite.modulate = Color(0,0,1,1)
		
		onPlayerMove.emit(0,0)
		
		print(slots_index[startAmount])
		startAmount += 1
		

func SetOccupied(last_index : int, new_index : int):
	for i in slots_index.size():
		if i == new_index:
			slots_index[i]["occupied"] = true
		elif i == last_index:
			slots_index[i]["occupied"] = false
		
		SetVisual(i)
	
func SetVisual(index : int):
	if slots_index[index]["occupied"] == true:
		slots_index[index]["sprite"].modulate = Color(1,0,0,1)
	else:
		slots_index[index]["sprite"].modulate = Color(0.0, 1.0, 0.0, 1.0)
