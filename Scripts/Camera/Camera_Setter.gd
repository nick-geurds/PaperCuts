extends Camera2D
class_name CameraSetter

@export var camera_padding_width : float 
@export var animation_curve : Curve
@export var animation_time : float = 0.5

var visible_width : float
var start_zoom : Vector2

var target_zoom : Vector2

func _on_slot_manager_on_total_width_set(target_width : float) -> void:
	visible_width = get_viewport_rect().size.x
	start_zoom = zoom
	
	var padding : float = (visible_width * camera_padding_width) / 100
	
	target_zoom.x = visible_width / (target_width + padding)
	target_zoom.y = target_zoom.x
	print(target_zoom)
	
	var tween = create_tween()
	tween.tween_method(
		func(progress):
			var curve_value = animation_curve.sample(progress)
			zoom = lerp(start_zoom, target_zoom, curve_value),0.0, 1.0, animation_time)
