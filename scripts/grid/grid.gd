# https://forum.godotengine.org/t/drawing-an-infinite-grid-from-a-tool/27004/3
class_name Grid
extends Node2D

@export var LINE_THICKNESS: int = 2
@export var LINE_COLOR: Color = Color.WHITE

@export var POINT_SIZE: int = 2
@export var POINT_COLOR: Color = Color.AQUA

@export var POINT_SELECTED_SIZE: int = 4
@export var POINT_SELECTED_COLOR: Color = Color.WHITE

@export var grid_size: Vector2 = Vector2(8, 8)
@export var cell_size: Vector2 = Vector2(48, 48)
@export var POINT_CLICK_SENSITIVITY: float = 15.

@onready var _state_machine: GridStateMachine = $StateMachine
var _points_default: Array[Vector2]
var _points: Array[Vector2]
var _show_focus: bool = true

var _focus_idx: int
var _shape_idx: Array[int]
var _shape_complete: bool = false

func _ready() -> void:	
	for i in range(-grid_size.x/2, grid_size.x/2 + 1):
		for j in range(-grid_size.y/2, grid_size.y/2 + 1):
			_points.push_back(Vector2(i, j) * cell_size)
	
	_points_default = _points.duplicate()
	_state_machine.init()

func _draw() -> void:
	_state_machine.on_draw()
	_focus_idx = -1
	
	for idx in len(_shape_idx) - 1:
		draw_line(_points[_shape_idx[idx]], _points[_shape_idx[idx + 1]], LINE_COLOR, LINE_THICKNESS)
	if _shape_complete: draw_line(_points[_shape_idx[0]], _points[_shape_idx[-1]], LINE_COLOR, LINE_THICKNESS)

	for idx in len(_points):
		var mouse_pos: Vector2 = get_local_mouse_position()	
		if _show_focus and (mouse_pos - _points[idx]).length() < POINT_CLICK_SENSITIVITY:
			draw_circle(_points[idx], POINT_SELECTED_SIZE, POINT_SELECTED_COLOR)
			_focus_idx = idx
		else:
			draw_circle(_points[idx], POINT_SIZE, POINT_COLOR)

		if not _shape_complete and len(_shape_idx) > 0: draw_circle(_points[_shape_idx[-1]], POINT_SELECTED_SIZE, POINT_SELECTED_COLOR)

func _process(delta: float) -> void:
	queue_redraw()

func _input(event: InputEvent) -> void:
	_state_machine.on_input(event)
