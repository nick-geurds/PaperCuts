extends Node2D
class_name SpecialAttack

signal onAnimationFinished

@export var animation_player : AnimationPlayer
@export var animation_name : String

func Start():
	animation_player.active = true
	animation_player.play(animation_name)
	animation_player.animation_finished.connect(onFinished)
	
func onFinished(anim_name : StringName):
	queue_free()
