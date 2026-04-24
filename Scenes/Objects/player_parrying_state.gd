extends PlayerState
class_name PlayerParryingState

signal onParryStateChange(current_state : bool)

@export var player_hurtbox : HurtBoxComponent
@export var parry_window : Timer

var isParrying : bool = false
var wait_time : float

func Enter(data = null):
	print("enterParryState")
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
	if parry_window.timeout.connect(onParryFinished):
		parry_window.timeout.disconnect(onParryFinished)
	parry_window.wait_time = wait_time
	isParrying = false

func onParryFinished():
	onParryStateChange.emit(false)
	Transitioned.emit(self, "Moving")

func onMoveInput():
	Transitioned.emit(self, "Moving")
