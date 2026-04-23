extends Node
class_name PlayerStateMachine

@export var initial_state : PlayerState
@export var animation_tree : AnimationTree

@export var state_debug : Label

@onready var state_machine_playback = animation_tree.get("parameters/playback")
var player_current_state : PlayerState
var states : Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if child is PlayerState:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(onChildStateTransitioned)
			
	if initial_state:
		initial_state.Enter()
		state_debug.text = "state = " + str(initial_state)
		player_current_state = initial_state
	
	animation_tree.active = true
	

func _process(delta: float):
	if player_current_state:
		player_current_state.Update(delta)

func _physics_process(delta: float):
	if player_current_state:
		player_current_state.Physics_Update(delta)

func onChildStateTransitioned(state, new_state_name, data = null):
	if state != player_current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if player_current_state:
		player_current_state.Exit()
	
	new_state.Enter(data)
	
	player_current_state = new_state
	
	state_debug.text = "state = " + str(player_current_state)

func can_move() -> bool:
	return player_current_state.can_move

func travel(anim_name: String) -> void:
	state_machine_playback.travel(anim_name)

func onAttackInput(attack_name: String) -> void:
	if player_current_state:
		player_current_state.onAttackInput(attack_name)
