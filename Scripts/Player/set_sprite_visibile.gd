extends Sprite2D
class_name SetSpriteVisible

@export var isVisibleAtStart : bool

func _ready() -> void:
	setSpriteVisibility(isVisibleAtStart)

func setSpriteVisibility(isTrue : bool):
	visible = isTrue
