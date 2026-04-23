extends PlayerState
class_name PlayerAttackingState

@export var player_state_machine : PlayerStateMachine
@export var base_attack : AttackData
@export var heavy_attack : AttackData

@export var spawn_attack_handler : SpawnAttackHandler

func Enter(data = null):
	var current_attack : AttackData
	if data and "heavy" in data:
		current_attack = heavy_attack
	else:
		current_attack = base_attack
		
	doAttack(current_attack)
	
func doAttack(attack_data : AttackData):
	player_state_machine.travel(attack_data.animation_name)

func doSpawnAttack():
	if spawn_attack_handler != null:
		var spawn_attack = spawn_attack_handler
		spawn_attack.Start()
		spawn_attack.attack_finished.connect(onAttackFinished)
		
func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	onAttackFinished()
	
func onAttackFinished():
	Transitioned.emit(self, "Moving")
