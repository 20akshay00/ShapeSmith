extends Area2D

var is_dragging: bool = false
var drag_point: Vector2 = Vector2(0, 0)

func _process(delta: float) -> void:
	if is_dragging:
		global_position = get_global_mouse_position() - drag_point

func _input(event):
	if event is InputEventMouseButton:
		if event.is_action_pressed("draw"):
			is_dragging = true
			drag_point = get_local_mouse_position()
			$CollisionShape2D.set_deferred("disabled", true)
			get_viewport().set_input_as_handled()
		elif event.is_action_released("draw"):
			is_dragging = false
			$CollisionShape2D.set_deferred("disabled", false)

func _set_collision_polygon():
	$CollisionShape2D.shape.segments = $Polygon2D.polygon
