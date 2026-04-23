extends Node
class_name SpawnAttackHandler

signal attack_finished

@export var animation_player : AnimationPlayer
@export var animation_name : String
@export var slot_data : SlotDataTransform
@export var object_to_spawn_scene : PackedScene

func Start():
	animation_player.play(animation_name)
	animation_player.animation_finished.connect(onAttackedFinished)

func spawn_at_slot(index : int):
	var next_slot = slot_data.getNextSlotIndex(index)
	if not slot_data.CheckIfInRange(next_slot):
		return
	
	var position = slot_data.getPosition(next_slot)
	var object = object_to_spawn_scene.instantiate()
	object.Start()
	get_tree().current_scene.add_child(object)
	object.global_position = position

func onAttackedFinished():
	attack_finished.emit()
