extends PlayerState
class_name PlayerAttackingState

@export var player_state_machine : PlayerStateMachine
@export var base_attack : AttackData
@export var heavy_attack : AttackData

@export var melee_attack_hitbox : HitBoxComponent

@export var spawn_attack_handler : SpawnAttackHandler

var is_attacking : bool = false

var current_attack : AttackData
	
func Enter(data = null):
	if is_attacking:
		return
	is_attacking = true
	
	if data and "heavy" in data:
		current_attack = heavy_attack
	else:
		current_attack = base_attack
	
	melee_attack_hitbox.damage = current_attack
	doAttack(current_attack)
	player_state_machine.animation_player.animation_finished.connect(_on_animation_tree_animation_finished, CONNECT_ONE_SHOT)

func doSpawnAttack():
	if spawn_attack_handler != null:
		var spawn_attack = spawn_attack_handler
		spawn_attack.current_damage = current_attack
		print(spawn_attack.current_damage)
		spawn_attack.Start()
		spawn_attack.attack_finished.connect(onAttackFinished)
		

func Exit(data = null):
	is_attacking = false
	if player_state_machine.animation_player.animation_finished.is_connected(_on_animation_tree_animation_finished):
		player_state_machine.animation_player.animation_finished.disconnect(_on_animation_tree_animation_finished)


func doAttack(attack_data : AttackData):
	player_state_machine.travel(attack_data.animation_name)
	
func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	is_attacking = false
	onAttackFinished()
	
func onAttackFinished():
	Transitioned.emit(self, "Moving")
