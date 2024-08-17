extends GridState

@export var grid: Grid

func on_draw() -> void:
	var mouse_pos: Vector2 = grid.get_local_mouse_position()
	for point in grid._points:
		if (mouse_pos - point).length() < grid.POINT_CLICK_SENSITIVITY:
			grid.draw_circle(point, 4, Color.WHITE)
		else:
			grid.draw_circle(point, 2, Color.AQUA)
			
func on_input(event: InputEvent) -> void:
	if event.is_action_pressed("drag"):
		transition_requested.emit(self, State.SKEW)
