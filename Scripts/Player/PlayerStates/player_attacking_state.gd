extends PlayerState
class_name PlayerAttackingState

@export var base_attack : AttackData
@export var heavy_attack : AttackData

@export var melee_attack_hitbox : HitBoxComponent
@export var spawn_attack_handler : SpawnAttackHandler

@export var smear_frame_animation_player : AnimationPlayer
@export var stanima_component : StanimaComponent

var is_attacking : bool = false

var current_attack : AttackData
	
func Enter(data = null):
	is_attacking = true
	
	if data and "heavy" in data:
		current_attack = heavy_attack
	else:
		current_attack = base_attack
	
	var stanima_cost = current_attack.stanima_cost
	
	if stanima_component != null:
		if stanima_component.hasEnoughStanimaLeft(stanima_cost):
			stanima_component.reduceStamina(stanima_cost)
			melee_attack_hitbox.damage = current_attack
			doAttack(current_attack)
			player_state_machine.animation_player.animation_finished.connect(_on_animation_tree_animation_finished, CONNECT_ONE_SHOT)
		else:
			onAttackFinished()

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
	if not is_attacking:
		return
	is_attacking = false
	onAttackFinished()
	
func onAttackFinished():
	print("onAttackFinished called!")
	Transitioned.emit(self, "Moving")

func playSmearAnimaiton():
	smear_frame_animation_player.play(current_attack.smear_animation_name)
