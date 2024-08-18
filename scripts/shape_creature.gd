class_name Creature
extends Area2D

var height: float
var width: float

var hole_vertices := [Vector2(-42, -263), Vector2(-197, -88), Vector2(-28, 130), Vector2(-88, -102)]

var shape_normalized: Array
var hole_normalized: Array

var opacity_tween: Tween

func _ready() -> void:
	$Polygon2D.polygon = PackedVector2Array(hole_vertices)

func _on_area_entered(area: Area2D) -> void:
	if area is CustomShape:
		area.call_deferred("attach", self)
		area.get_node("CollisionShape2D").set_deferred("disabled", true)
		area.can_drag = false
		
		area.global_position =  global_position + hole_vertices.reduce(func(res, point): return res + point, Vector2(0, 0)) / len(hole_vertices)
		
		var shape_centre_of_mass: Vector2 = area.points.reduce(func(res, point): return res + point, Vector2(0, 0)) / len(area.points)
		shape_normalized = area.points.map(func(val): return val - shape_centre_of_mass)
		var shape_area: float = calculate_area(shape_normalized)

		var hole_centre_of_mass: Vector2 = hole_vertices.reduce(func(res, point): return res + point, Vector2(0, 0)) / len(hole_vertices)
		hole_normalized = hole_vertices.map(func(val): return val - hole_centre_of_mass)
		var hole_area: float = calculate_area(hole_normalized)

		var excluded_polygons := Geometry2D.exclude_polygons(PackedVector2Array(shape_normalized), PackedVector2Array(hole_normalized))
		var excluded_area: float = excluded_polygons.reduce(func(res, polygon): return res + calculate_area(polygon), 0.)
		
		_display_result(1 - excluded_area/(shape_area + hole_area))
		#print(excluded_area, " ", hole_area, " ", shape_area)

func calculate_area(mesh_vertices: Array) -> float:
	var result := 0.0
	var num_vertices := mesh_vertices.size()
	
	for q in range(num_vertices):
		var p = (q - 1 + num_vertices) % num_vertices
		result += mesh_vertices[q].cross(mesh_vertices[p])
	
	return abs(result) * 0.5

func _display_result(res: float) -> void:
	if opacity_tween: opacity_tween.kill()
	opacity_tween = get_tree().create_tween()
	opacity_tween.tween_property($SuccessBar, "modulate:a", 1., 1.0)
	opacity_tween.tween_property($SuccessBar/Foreground, "material:shader_parameter/percent", res, 2.0)
	opacity_tween.tween_property($SuccessBar, "scale", Vector2(1.025, 1.025), 0.25)
	opacity_tween.tween_property($SuccessBar, "scale", Vector2(1., 1.), 0.25)
