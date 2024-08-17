extends GridState

@export var grid: Grid

@export var skew_factor: Vector2 = Vector2(0., 0.)
@export var SKEW_SENSITIVITY: int = 700
var _skew_dir: int = 0

func on_draw() -> void:
	var mouse_pos: Vector2 = grid.get_local_mouse_position()
	var target_idx: int = -1
	
	for point in grid._points:
		grid.draw_circle(point, 2, Color.AQUA)

func on_input(event: InputEvent) -> void:

	if event is InputEventMouseMotion:
		if _skew_dir == 0: 
			_skew_dir = 1 if (abs(event.relative.x) > abs(event.relative.y)) else -1
		
		if _skew_dir > 0:
			var skew_factor_new: float = clamp(skew_factor.x + event.relative.x/SKEW_SENSITIVITY, -1., 1.)
			for idx in len(grid._points): 
				grid._points[idx] = _skew_x(grid._points[idx], skew_factor_new - skew_factor.x)
			skew_factor.x = skew_factor_new
		else:
			var skew_factor_new: float = clamp(skew_factor.y + event.relative.y/SKEW_SENSITIVITY, -1., 1.)
			for idx in len(grid._points): 
				grid._points[idx] = _skew_y(grid._points[idx], skew_factor_new - skew_factor.y)
			skew_factor.y = skew_factor_new

	elif event.is_action_released("drag"):
		_skew_dir = 0
		transition_requested.emit(self, State.BASE)
		
func _skew_x(vec: Vector2, factor: float) -> Vector2:
	vec.x += factor * vec.y
	return vec

func _skew_y(vec: Vector2, factor: float) -> Vector2:
	vec.y += factor * vec.x
	return vec
	
