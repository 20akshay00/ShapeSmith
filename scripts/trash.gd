class_name Shape
extends Area2D

var highlight_tween: Tween
var modulate_tween: Tween

func _on_mouse_entered() -> void:
	if highlight_tween: highlight_tween.kill()
	highlight_tween = get_tree().create_tween()
	highlight_tween.tween_property(self, "modulate:a", 0.8, 0.25)

func _on_mouse_exited() -> void:
	if highlight_tween: highlight_tween.kill()
	highlight_tween = get_tree().create_tween()
	highlight_tween.tween_property(self, "modulate:a", 1.0, 0.25)

func _on_area_entered(area: Area2D) -> void:
	if modulate_tween: modulate_tween.kill()
	modulate_tween = get_tree().create_tween()
	modulate_tween.tween_property(area, "modulate:a", 0., 1.)
	modulate_tween.tween_callback(func(): area.queue_free())
		
