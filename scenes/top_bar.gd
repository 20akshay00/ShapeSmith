extends ColorRect

@export var rotation_label: Label
@export var skew_x_label: Label
@export var skew_y_label: Label

var rotation_tween: Tween
var skewx_tween: Tween 
var skewy_tween: Tween

func set_rotation_label(angle: float) -> void:
	if rotation_tween: rotation_tween.kill()
	rotation_tween = get_tree().create_tween()
	rotation_tween.tween_property(rotation_label, "scale", Vector2(1.2, 1.2), 0.15)
	rotation_tween.tween_callback(func(): rotation_label.text = str(round(angle / PI * 180)) + "°")
	#tween.tween_property(rotation_label, "text", str(round(angle / PI * 180)) + "°", 1)
	rotation_tween.tween_property(rotation_label, "scale", Vector2(1., 1.), 0.15)

func set_skew_x_label(val: float) -> void:
	var is_invalid: bool = is_equal_approx(abs(val), 1)
	
	if skewx_tween: skewx_tween.kill()
	skewx_tween = get_tree().create_tween()
	skewx_tween.tween_property(skew_x_label, "scale", Vector2(1.2, 1.2), 0.15)
	if is_invalid: skewx_tween.parallel().tween_property(skew_x_label, "modulate", Color.RED, 0.15)
	
	skewx_tween.tween_callback(func():	skew_x_label.text = "%*.*f" % [0, 2, val])
	
	skewx_tween.tween_property(skew_x_label, "scale", Vector2(1., 1.), 0.15)
	if is_invalid: skewx_tween.parallel().tween_property(skew_x_label, "modulate", Color.WHITE, 0.15)
	
func set_skew_y_label(val: float) -> void:
	var is_invalid: bool = is_equal_approx(abs(val), 1)

	if skewy_tween: skewy_tween.kill()
	skewy_tween = get_tree().create_tween()
	skewy_tween.tween_property(skew_y_label, "scale", Vector2(1.2, 1.2), 0.15)
	if is_invalid: skewy_tween.parallel().tween_property(skew_y_label, "modulate", Color.RED, 0.15)

	skewy_tween.tween_callback(func():	skew_y_label.text = "%*.*f" % [0, 2, val])

	skewy_tween.tween_property(skew_y_label, "scale", Vector2(1., 1.), 0.15)
	if is_invalid: skewy_tween.parallel().tween_property(skew_y_label, "modulate", Color.WHITE, 0.15)
