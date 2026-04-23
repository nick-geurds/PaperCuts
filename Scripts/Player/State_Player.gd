extends Node
class_name PlayerState

@export var can_move : bool

signal Transitioned(state, new_state_name, data)

func Enter(data = null):
	pass

func Exit():
	pass
	
func Update(delta : float):
	pass

func Physics_Update(delta : float):
	pass

func doAttackInput(new_attack_name: String):
	pass
