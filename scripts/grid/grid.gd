# https://forum.godotengine.org/t/drawing-an-infinite-grid-from-a-tool/27004/3
class_name Grid
extends Node2D

@export var grid_size: Vector2 = Vector2(15, 15)
@export var cell_size: Vector2 = Vector2(48, 48)
@export var POINT_CLICK_SENSITIVITY: float = 15.

@onready var _state_machine: GridStateMachine = $StateMachine
var _points: Array[Vector2]

func _ready() -> void:	
	for i in range(-grid_size.x/2, grid_size.x/2 + 1):
		for j in range(-grid_size.y/2, grid_size.y/2 + 1):
			_points.push_back(Vector2(i, j) * cell_size)
			
	_state_machine.init()

func _draw() -> void:
	_state_machine.on_draw()

func _process(delta: float) -> void:
	queue_redraw()

func _input(event: InputEvent) -> void:
	_state_machine.on_input(event)
