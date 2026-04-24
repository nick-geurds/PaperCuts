extends Area2D
class_name HurtBoxComponent

@export var health_component : HealthComponent
@export var collision_shape : CollisionShape2D #for debug

@onready var org_color : Color = collision_shape.debug_color

@export var isParrying : bool = false

func getIsParrying(current_parry_state : bool) -> bool:
	isParrying = current_parry_state
	return isParrying

func setParryState(current_state : bool):
	var parrying = getIsParrying(current_state)
	if parrying:
		collision_shape.debug_color = Color(0.0, 1.0, 0.0, 1.0)
	else:
		collision_shape.debug_color = org_color
	

func Damage(attack : AttackData):
	if health_component == null:
		return
	
	if not isParrying:
		health_component.TakeDamage(attack)
	else :
		print("attack got parried")
