extends GridState

@export var grid: Grid

var _start_point_idx: int 
var is_valid_placement: bool = true

var LINE_COLOR_INVALID: Color = Color.RED

var valid_placement_sfx := preload("res://assets/sfx/Point Place 2.wav")

func enter() -> void:
	_start_point_idx = grid._focus_idx
	grid._show_focus = true
	AudioManager.play_effect(valid_placement_sfx)

func exit() -> void:
	pass

func on_draw() -> void:
	is_valid_placement = not _is_self_intersecting()
	grid.draw_circle(grid._points[_start_point_idx], grid.POINT_SELECTED_SIZE, grid.POINT_SELECTED_COLOR)
	
	if is_valid_placement:
		grid.draw_line(grid._points[_start_point_idx], grid.get_local_mouse_position(), grid.LINE_COLOR, grid.LINE_THICKNESS)
	else:
		grid.draw_line(grid._points[_start_point_idx], grid.get_local_mouse_position(), LINE_COLOR_INVALID, grid.LINE_THICKNESS)
			
func on_input(event: InputEvent) -> void:
	if event.is_action_pressed("draw") and grid._focus_idx >= 0:
		var _next_point_idx = grid._focus_idx
		
		if _start_point_idx != _next_point_idx:
			if len(grid._shape_idx) == 0: grid._shape_idx.push_back(_start_point_idx)
			
			if _next_point_idx == grid._shape_idx[0] and len(grid._shape_idx) > 2 and is_valid_placement:
				grid._shape_complete = true
				transition_requested.emit(self, State.BASE)
				AudioManager.play_effect(valid_placement_sfx)
			elif _next_point_idx not in grid._shape_idx and is_valid_placement:
				grid._shape_idx.push_back(_next_point_idx)
				_start_point_idx = _next_point_idx
				AudioManager.play_effect(valid_placement_sfx)
			else:
				AudioManager.play_effect(AudioManager.invalid_placement_sfx)

	if event.is_action_pressed("cancel"):
		transition_requested.emit(self, State.BASE)

func _is_self_intersecting() -> bool:
	var mouse_pos: Vector2 =  grid.get_local_mouse_position()
	for i in len(grid._shape_idx) - 2:
		var res = Geometry2D.segment_intersects_segment(grid._points[grid._shape_idx[i]], grid._points[grid._shape_idx[i + 1]], grid._points[_start_point_idx], mouse_pos)
		if res != null: return true
	#if len(grid._shape_idx) > 1 and is_equal_approx((grid._points[grid._shape_idx[-2]] - grid._points[grid._shape_idx[-1]]).dot(grid._points[grid._shape_idx[-1]] - mouse_pos), -1):
		#return true
	return false
