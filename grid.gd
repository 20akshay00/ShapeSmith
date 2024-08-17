# https://forum.godotengine.org/t/drawing-an-infinite-grid-from-a-tool/27004/3
extends Node2D

@export var skew_factor: Vector2 = Vector2(0., 0.)
@export var SKEW_SENSITIVITY: int = 700
@export var grid_size: Vector2 = Vector2(15, 15)
@export var cell_size: Vector2 = Vector2(48, 48)
@export var POINT_CLICK_SENSITIVITY: float = 15.

var _grid_points: Array[Vector2]

var _is_skewing: bool = false
var _skew_dir: int = 0


func _ready() -> void:	
	for i in range(-grid_size.x/2, grid_size.x/2 + 1):
		for j in range(-grid_size.y/2, grid_size.y/2 + 1):
			_grid_points.push_back(Vector2(i, j) * cell_size)

func _draw() -> void:
	var mouse_pos: Vector2 = get_local_mouse_position()
	var target_idx: int = -1
	
	for point in _grid_points:
		if (mouse_pos - point).length() < POINT_CLICK_SENSITIVITY:
			draw_circle(point, 4, Color.WHITE)
		else:
			draw_circle(point, 2, Color.AQUA)

		#draw_line(Vector2(i * 64, cam.y + size.y + 100), Vector2(i * 64, cam.y - size.y - 100), "000000")
		#for i in range(int((cam.y - size.y) / 64) - 1, int((size.y + cam.y) / 64) + 1):
			#draw_line(Vector2(cam.x + size.x + 100, i * 64), Vector2(cam.x - size.x - 100, i * 64), "000000")

func _process(delta: float) -> void:
	queue_redraw()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("drag") and not _is_skewing:
		_is_skewing = true

	elif event.is_action_released("drag") and _is_skewing:
		_is_skewing = false
		_skew_dir = 0
	
	if event is InputEventMouseMotion:
		if _is_skewing:
			if _skew_dir == 0: 
				_skew_dir = 1 if (abs(event.relative.x) > abs(event.relative.y)) else -1
			
			if _skew_dir > 0:
				var skew_factor_new: float = clamp(skew_factor.x + event.relative.x/SKEW_SENSITIVITY, -1., 1.)
				for idx in len(_grid_points): 
					_grid_points[idx] = _skew_x(_grid_points[idx], skew_factor_new - skew_factor.x)
				skew_factor.x = skew_factor_new
			else:
				var skew_factor_new: float = clamp(skew_factor.y + event.relative.y/SKEW_SENSITIVITY, -1., 1.)
				for idx in len(_grid_points): 
					_grid_points[idx] = _skew_y(_grid_points[idx], skew_factor_new - skew_factor.y)
				skew_factor.y = skew_factor_new

func _skew_x(vec: Vector2, factor: float) -> Vector2:
	vec.x += factor * vec.y
	return vec

func _skew_y(vec: Vector2, factor: float) -> Vector2:
	vec.y += factor * vec.x
	return vec
	
func snap_vector(pos):
	pass
	#return Vector2(
		#int(pos.x / grid_size.x) * grid_size.x,
		#int(pos.y / grid_size.y) * grid_size.y
	#)
