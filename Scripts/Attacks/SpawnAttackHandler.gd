extends Node
class_name SpawnAttackHandler

signal attack_finished

@export var animation_player : AnimationPlayer
@export var animation_name : String
@export var object_to_spawn_scene : PackedScene

@export var player_movement : PlayerMovement
@export var slot_width : float = 120

var current_damage : AttackData

func Start():
	animation_player.play(animation_name)
	animation_player.animation_finished.connect(onAttackedFinished)

func spawn_at_slot(index : int):
	if player_movement != null:
		var object = object_to_spawn_scene.instantiate()
		object.global_position.x = player_movement.global_position.x + ((slot_width * player_movement.lastDirection) * index)
		object.global_position.y = 0
		
		get_tree().current_scene.add_child(object)
		
		var hitbox = object.find_child("HitBoxComponent") as HitBoxComponent
		
		if hitbox:
			hitbox.damage = current_damage
			
		object.Start()

func onAttackedFinished(_anim_name: StringName):
	attack_finished.emit()
