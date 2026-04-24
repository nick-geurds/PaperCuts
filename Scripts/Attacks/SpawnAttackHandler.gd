extends Node
class_name SpawnAttackHandler

signal attack_finished

@export var animation_player : AnimationPlayer
@export var animation_name : String
@export var slot_data : SlotDataTransform
@export var object_to_spawn_scene : PackedScene

var current_damage : AttackData

func Start():
	animation_player.play(animation_name)
	animation_player.animation_finished.connect(onAttackedFinished)

func spawn_at_slot(index : int):
	var object = object_to_spawn_scene.instantiate()
	object.global_position.x = $"../PlayerMoveComponent".global_position.x + ((slot_data.slot_width * slot_data.last_player_direction) * index)
	object.global_position.y = 0
	
	get_tree().current_scene.add_child(object)
	
	var hitbox = object.find_child("HitBoxComponent") as HitBoxComponent
	
	if hitbox:
		hitbox.damage = current_damage
		
	object.Start()

func onAttackedFinished(_anim_name: StringName):
	attack_finished.emit()
