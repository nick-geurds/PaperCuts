extends PlayerState
class_name PlayerMoveState

@export var player_state_machine : PlayerStateMachine
@export var move_anim : String = "Null_state"

func Enter(data = null):
	player_state_machine.travel(move_anim)

func onAttackInput(attack_name: String):
	Transitioned.emit(self, "Attacking", attack_name) 
