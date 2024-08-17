# https://forum.godotengine.org/t/drawing-an-infinite-grid-from-a-tool/27004/3
class_name Grid
extends Node2D

@export var grid_size: Vector2 = Vector2(15, 15)
@export var cell_size: Vector2 = Vector2(48, 48)
@export var POINT_CLICK_SENSITIVITY: float = 15.

@onready var _state_machine: GridStateMachine = $StateMachine
var _points: Array[Vector2]
var _show_focus: bool = true

var _focus_idx: int
var _shape_idx: Array[int]

func _ready() -> void:	
	for i in range(-grid_size.x/2, grid_size.x/2 + 1):
		for j in range(-grid_size.y/2, grid_size.y/2 + 1):
			_points.push_back(Vector2(i, j) * cell_size)
			
	_state_machine.init()

func _draw() -> void:
	_state_machine.on_draw()
	_focus_idx = -1
	
	for idx in len(_shape_idx) - 1:
		draw_line(_points[_shape_idx[idx]], _points[_shape_idx[idx + 1]], Color.WHITE, 1)

	for idx in len(_points):
		var mouse_pos: Vector2 = get_local_mouse_position()	
		if _show_focus and (mouse_pos - _points[idx]).length() < POINT_CLICK_SENSITIVITY:
			draw_circle(_points[idx], 4, Color.WHITE)
			_focus_idx = idx
		else:
			draw_circle(_points[idx], 2, Color.AQUA)
func _process(delta: float) -> void:
	queue_redraw()

func _input(event: InputEvent) -> void:
	_state_machine.on_input(event)
