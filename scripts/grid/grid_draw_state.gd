extends GridState

@export var grid: Grid

var _start_point_idx: int 

func enter() -> void:
	_start_point_idx = grid._focus_idx
	grid._show_focus = true

func exit() -> void:
	pass

func on_draw() -> void:
	grid.draw_circle(grid._points[_start_point_idx], grid.POINT_SELECTED_SIZE, grid.POINT_SELECTED_COLOR)
	grid.draw_line(grid._points[_start_point_idx], grid.get_local_mouse_position(), grid.LINE_COLOR, grid.LINE_THICKNESS)

func on_input(event: InputEvent) -> void:
	if event.is_action_pressed("draw") and grid._focus_idx > 0:
		var _next_point_idx = grid._focus_idx
		
		if _start_point_idx != _next_point_idx:
			if len(grid._shape_idx) == 0: grid._shape_idx.push_back(_start_point_idx)
			
			if _next_point_idx == grid._shape_idx[0]:
				#if _is_self_intersecting(grid._shape_idx.map(func(idx): return grid._points[idx])):
					#grid._shape_idx = []
					#transition_requested.emit(self, State.BASE)
				#else:
				grid._shape_complete = true
				transition_requested.emit(self, State.BASE)
					
			elif _next_point_idx not in grid._shape_idx:
				grid._shape_idx.push_back(_next_point_idx)
				_start_point_idx = _next_point_idx

	if event.is_action_pressed("cancel"):
		transition_requested.emit(self, State.BASE)

func _is_self_intersecting(polygon: Array) -> bool:
	var s = polygon.size() - 1
	for i in range(0, s):
		var p1: Vector2 = polygon[i]
		var p2: Vector2 = polygon[(i+1) % s]
		for j in range(0, s):
			var p1a: Vector2 = polygon[j]
			var p2a: Vector2 = polygon[(j+1) % s]
			var intersect = Geometry2D.segment_intersects_segment(p1, p2, p1a, p2a)
			if intersect != null: return true
	return false
