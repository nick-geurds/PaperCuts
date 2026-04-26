extends PlayerState
class_name PlayerParryingState

signal onParryStateChange(current_state : bool)

@export var player_hurtbox : HurtBoxComponent
@export var parry_window : Timer
@export var parry_anim_name : String

var isParrying : bool = false
var wait_time : float

func Enter(data = null):
	player_state_machine.travel(parry_anim_name)
	wait_time = parry_window.wait_time
	if isParrying:
		return
	isParrying = true
	setParryState()

func setParryState():
	onParryStateChange.emit(true)
	parry_window.timeout.connect(onParryFinished, CONNECT_ONE_SHOT)
	parry_window.start()

func Exit(data = null):
	isParrying = false
	if parry_window.timeout.is_connected(onParryFinished):
		parry_window.timeout.disconnect(onParryFinished)
	parry_window.wait_time = wait_time

func onParryFinished():
	onParryStateChange.emit(false)
	Transitioned.emit(self, "Moving")

func onMoveInput():
	onParryStateChange.emit(false)
	Transitioned.emit(self, "Moving")
