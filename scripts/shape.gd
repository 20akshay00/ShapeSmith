class_name CustomShape
extends Area2D

var is_dragging: bool = false
var drag_point: Vector2 = Vector2(0, 0)
var can_drag: bool = true
var _mouse_inside: bool = false
var points: Array

var draw_points: PackedVector2Array

func _process(delta: float) -> void:
	queue_redraw()
	if is_dragging:
		global_position = get_global_mouse_position() - drag_point

func _draw() -> void:
	if is_dragging: draw_polyline(draw_points, Color.WHITE, 3)

func _input(event):	
	if event is InputEventMouseButton:
		if event.is_action_pressed("draw") and can_drag and _mouse_inside:
			is_dragging = true
			drag_point = get_local_mouse_position()
			$CollisionShape2D.set_deferred("disabled", true)
			get_viewport().set_input_as_handled()
		if event.is_action_released("draw"):
			is_dragging = false
			$CollisionShape2D.set_deferred("disabled", false)

func _set_collision_polygon():
	points = $Polygon2D.polygon
	var xmin: float = points.reduce(func(res, point): return min(point.x, res), 100000)
	var xmax: float = points.reduce(func(res, point): return max(point.x, res), -100000)
	var ymin: float = points.reduce(func(res, point): return min(point.y, res), 100000)
	var ymax: float = points.reduce(func(res, point): return max(point.y, res), -100000)
	
	$CollisionShape2D.shape.size = Vector2(xmax - xmin, ymax - ymin)
	
	var tween = get_tree().create_tween()
	tween.tween_property($Polygon2D, "modulate:a", 1., 1)
	tween.tween_callback(func(): EventManager.shape_created.emit())
	tween.tween_property(self, "scale", Vector2(1.15, 1.15), 0.2)
	tween.tween_property(self, "scale", Vector2(1., 1.), 0.2)
	tween.tween_callback(func(): $CollisionShape2D.set_deferred("disabled", false))

	draw_points = _generate_outline_points()

func _generate_outline_points():
	var new_points := points.duplicate()
	new_points.append_array([points[-1], points[0]])
	return PackedVector2Array(new_points)

func _on_mouse_entered() -> void:
	_mouse_inside = true

func _on_mouse_exited() -> void:
	_mouse_inside = false

func attach(parent: Creature) -> void:
	reparent(parent)
	parent.move_child(self, 3)
