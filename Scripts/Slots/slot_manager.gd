extends Node
class_name SlotManager

signal onTotalWidthSet(target_width : float)

@export var padding_per_slot : float
@export var slot_amount : int

var slot_index : Array = []

var slot_scene : PackedScene
var scene_camera : Camera2D

var total_slots_width : float
var startpos_offset : float

func _ready() -> void:
	slot_scene = preload("res://Scenes/Objects/Slot.tscn")
	scene_camera = get_parent().get_node("MainCamera")
	Setup_Slots()

func Setup_Slots():
	for i in slot_amount:
		var slot = slot_scene.instantiate()
		add_child(slot)
		
		slot_index.append(slot)
		
		var slot_width = slot.get_rect().size.x
		
		if i == 0:
			total_slots_width = (slot_amount - 1) * (slot_width + padding_per_slot)
			startpos_offset = total_slots_width / 2
			onTotalWidthSet.emit(total_slots_width)
		
		var  startpos_x = i * (slot_width + padding_per_slot) - startpos_offset
		
		slot.global_position = Vector2(startpos_x,0)
