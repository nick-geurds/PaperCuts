extends PlayerState
class_name PlayerParryingState

signal onParryStateChange(current_state : bool)

@export var player_hurtbox : HurtBoxComponent
@export var parry_window : Timer
@export var parry_anim_name : String

@export var stanima_cost : int = 1
@export var stanima_component : StanimaComponent

var isParrying : bool = false
var wait_time : float

func Enter(data = null):
	isParrying = true
	
	if stanima_component != null:
		if stanima_component.hasEnoughStanimaLeft(stanima_cost):
			stanima_component.reduceStamina(stanima_cost)
			player_state_machine.travel(parry_anim_name)
			wait_time = parry_window.wait_time
			setParryState()
		else:
			onParryFinished()

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
	if not isParrying:
		return
	onParryStateChange.emit(false)
	Transitioned.emit(self, "Moving")
