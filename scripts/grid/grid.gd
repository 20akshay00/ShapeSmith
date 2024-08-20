# https://forum.godotengine.org/t/drawing-an-infinite-grid-from-a-tool/27004/3
class_name Grid
extends Node2D

@export var LINE_THICKNESS: int = 2
@export var LINE_COLOR: Color = Color.WHITE

@export var POINT_SIZE: int = 3
@export var POINT_COLOR: Color = Color.AQUA

@export var POINT_SELECTED_SIZE: int = 5
@export var POINT_SELECTED_COLOR: Color = Color.WHITE

@export var grid_size: Vector2 = Vector2(8, 8)
@export var cell_size: Vector2 = Vector2(48, 48)
@export var POINT_CLICK_SENSITIVITY: float = 15.

@export var x_grid_line_idx: Array
@export var y_grid_line_idx: Array
@export var GRID_LINE_THICKNESS: float = 3
@export var GRID_LINE_COLOR: Color = Color(49, 122, 139, 0.2)

@onready var _state_machine: GridStateMachine = $StateMachine
@export var _top_ui: ColorRect
@onready var shape_scene: PackedScene = preload("res://scenes/shape.tscn")

var _points_default: Array[Vector2]
var _points: Array[Vector2]
var _show_focus: bool = true

var _focus_idx: int
var _shape_idx: Array[int]
var _shape_complete: bool = false
var _block_shape_spawn: bool = false # some spagetti to disallow spamming the create shape button between tween duration
var reset_tween: Tween

var shape_filled_sfx := preload("res://assets/sfx/Shape Forge.wav")
var reset_transform_sfx := preload("res://assets/sfx/Reset Grid.wav")

func _ready() -> void:	
	for i in Vector3(-(grid_size.x - 1)/2, grid_size.x/2, 1):
		for j in Vector3(-(grid_size.y - 1)/2, grid_size.y/2, 1):
			_points.push_back(Vector2(i, j) * cell_size)
	
	_points_default = _points.duplicate()
	_state_machine.init()
	
	for i in grid_size.x: x_grid_line_idx.push_back([i, i + (grid_size.y - 1) * grid_size.x])
	for idx in grid_size.y: y_grid_line_idx.push_back([idx * grid_size.x, (idx + 1) * grid_size.x - 1])
		
	EventManager.reset_transform.connect(_on_reset_transform)
	EventManager.clear_points.connect(_on_clear_points)
	EventManager.fill_points.connect(_on_fill_points)
	
	EventManager.shape_created.connect(_on_shape_created)

func _draw() -> void:
	_state_machine.on_draw()
	_focus_idx = -1
	
	# draw gridlines
	for coords in x_grid_line_idx: draw_line(_points[coords[0]], _points[coords[1]], GRID_LINE_COLOR, GRID_LINE_THICKNESS)
	for coords in y_grid_line_idx: draw_line(_points[coords[0]], _points[coords[1]], GRID_LINE_COLOR, GRID_LINE_THICKNESS)
		
	# draw lines connecting the shape
	for idx in len(_shape_idx) - 1:
		draw_line(_points[_shape_idx[idx]], _points[_shape_idx[idx + 1]], LINE_COLOR, LINE_THICKNESS)
	if _shape_complete: draw_line(_points[_shape_idx[0]], _points[_shape_idx[-1]], LINE_COLOR, LINE_THICKNESS)

	# draw grid points
	for idx in len(_points):
		var mouse_pos: Vector2 = get_local_mouse_position()	
		if _show_focus and (mouse_pos - _points[idx]).length() < POINT_CLICK_SENSITIVITY:
			draw_circle(_points[idx], POINT_SELECTED_SIZE, POINT_SELECTED_COLOR)
			_focus_idx = idx
		else:
			draw_circle(_points[idx], POINT_SIZE, POINT_COLOR)

		# draw open point if shape is incomplete
		if not _shape_complete and len(_shape_idx) > 0: draw_circle(_points[_shape_idx[-1]], POINT_SELECTED_SIZE, POINT_SELECTED_COLOR)

func _process(delta: float) -> void:
	queue_redraw()
	_state_machine.process(delta)

func _input(event: InputEvent) -> void:
	_state_machine.on_input(event)

func _on_reset_transform() -> void:
	if (_state_machine.get_child(1).skew_factor == Vector2.ZERO) and (_state_machine.get_child(3).angle == 0):
		AudioManager.play_effect(AudioManager.invalid_placement_sfx)
	else:
		_state_machine.get_child(1).skew_factor = Vector2(0, 0)
		_state_machine.get_child(1).reset()
		_state_machine.get_child(3).angle = 0.
		_state_machine.get_child(3).reset()
		
		if reset_tween and reset_tween.is_running(): 
			AudioManager.play_effect(AudioManager.invalid_placement_sfx)
		else:
			if reset_tween: reset_tween.kill()
			AudioManager.play_effect(reset_transform_sfx)
			reset_tween = get_tree().create_tween()
			reset_tween.set_parallel()
			for idx in len(_points): 
				reset_tween.tween_method(
					func (new_points: Array[Vector2]): _points = new_points.duplicate(),
					_points,
					_points_default,
					1.
				)
		
func _on_clear_points() -> void:
	_shape_idx = []
	_shape_complete = false
	AudioManager.play_effect(AudioManager.invalid_placement_sfx_1)

func _on_fill_points() -> void:
	if _shape_complete and not _block_shape_spawn:
		_block_shape_spawn = true
		var shape = shape_scene.instantiate()
		var centre_of_mass: Vector2 = _shape_idx.reduce(func(res, idx): return res + _points[idx], Vector2(0, 0)) / len(_shape_idx)
		
		shape.get_node("Polygon2D").polygon = PackedVector2Array(_shape_idx.map(func(idx): return _points[idx] - centre_of_mass))
		shape.call_deferred("_set_collision_polygon")
		get_parent().add_child(shape)
		shape.position = global_position + centre_of_mass
		AudioManager.play_effect(shape_filled_sfx)
	else:
		AudioManager.play_effect(AudioManager.invalid_placement_sfx)
		

func _on_shape_created() -> void:
	_shape_idx = []
	_shape_complete = false
	_block_shape_spawn = false
