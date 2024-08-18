extends ColorRect


func _on_reset_transform_button_pressed() -> void:
	EventManager.reset_transform.emit()
	
func _on_clear_points_button_pressed() -> void:
	EventManager.clear_points.emit()

func _on_fill_points_button_pressed() -> void:
	EventManager.fill_points.emit()
