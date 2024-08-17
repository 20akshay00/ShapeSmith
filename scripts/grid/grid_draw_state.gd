extends GridState

@export var grid: Grid

var _start_point_idx: int 

func enter() -> void:
	#grid._shape_idx.push_back(grid._focus_idx)
	_start_point_idx = grid._focus_idx
	grid._show_focus = true

func exit() -> void:
	pass

func on_draw() -> void:
	grid.draw_circle(grid._points[_start_point_idx], 4, Color.WHITE)
	grid.draw_line(grid._points[_start_point_idx], grid.get_local_mouse_position(), Color.WHITE, 1)

func on_input(event: InputEvent) -> void:
	if event.is_action_pressed("draw") and grid._focus_idx > 0:
		if _start_point_idx != grid._focus_idx:
			if len(grid._shape_idx) == 0: grid._shape_idx.push_back(_start_point_idx)
			grid._shape_idx.push_back(grid._focus_idx)
			transition_requested.emit(self, State.BASE)

	if event.is_action_pressed("cancel"):
		transition_requested.emit(self, State.BASE)
