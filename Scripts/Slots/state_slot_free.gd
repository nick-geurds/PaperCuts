extends State
class_name SlotFreeState

@export var slot_border_panel : Panel
@export var slot_border_color : Color

func SetColor():
	slot_border_panel.self_modulate = slot_border_color

func Enter():
	SetColor()

func _on_slot_area_2d_area_entered(area: Area2D) -> void:
	Transitioned.emit(self, "Occupied")
