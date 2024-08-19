class_name Creature
extends Area2D

var height: float
var width: float

var hole_vertices: Array

var shape_normalized: Array
var hole_normalized: Array

var opacity_tween: Tween
@onready var hop_timer := $HopTimer
@export var MAX_HOP_DELAY := 20.
@export var MIN_HOP_DELAY := 15.

func _ready() -> void:
	$Polygon2D.polygon = PackedVector2Array(hole_vertices)
	
	$AnimationPlayer.play("wobble")
	var tween := get_tree().create_tween()
	tween.tween_property(self, "global_position:x", 1480, 3.)
	tween.tween_callback(func(): $AnimationPlayer.stop())
	tween.tween_property(self, "global_position:y", global_position.y - 20, 0.2)
	tween.tween_property(self, "global_position:y", global_position.y + 20, 0.2)
	tween.tween_callback(func(): $CollisionShape2D.set_deferred("disabled", false))
	#tween.tween_callback(func(): hop_timer.start(randf_range(MIN_HOP_DELAY, MAX_HOP_DELAY)))
	$SuccessBar/Foreground.material.set("shader_parameter/percent", 0.)

func _on_area_entered(area: Area2D) -> void:
	if area is CustomShape:
		area.call_deferred("attach", self)
		area.get_node("CollisionShape2D").set_deferred("disabled", true)
		$CollisionShape2D.set_deferred("disabled", true)
		area.can_drag = false
		area.get_node("Polygon2D").modulate = Color.WHITE
		area.global_position =  global_position + hole_vertices.reduce(func(res, point): return res + point, Vector2(0, 0)) / len(hole_vertices)
		
		var shape_centre_of_mass: Vector2 = area.points.reduce(func(res, point): return res + point, Vector2(0, 0)) / len(area.points)
		shape_normalized = area.points.map(func(val): return val - shape_centre_of_mass)
		var shape_area: float = calculate_area(shape_normalized)

		var hole_centre_of_mass: Vector2 = hole_vertices.reduce(func(res, point): return res + point, Vector2(0, 0)) / len(hole_vertices)
		hole_normalized = hole_vertices.map(func(val): return val - hole_centre_of_mass)
		var hole_area: float = calculate_area(hole_normalized)

		var excluded_polygons := Geometry2D.exclude_polygons(PackedVector2Array(shape_normalized), PackedVector2Array(hole_normalized))
		var excluded_area: float = excluded_polygons.reduce(func(res, polygon): return res + calculate_area(polygon), 0.)
		
		var score := 1 - excluded_area/(shape_area + hole_area)
		_display_result(score)

func calculate_area(mesh_vertices: Array) -> float:
	var result := 0.0
	var num_vertices := mesh_vertices.size()
	
	for q in range(num_vertices):
		var p = (q - 1 + num_vertices) % num_vertices
		result += mesh_vertices[q].cross(mesh_vertices[p])
	
	return abs(result) * 0.5

func _display_result(res: float) -> void:
	$SuccessBar/ScoreLabel.text = "%2.0f" % (res * 100) + "%"
	if opacity_tween: opacity_tween.kill()
	opacity_tween = get_tree().create_tween()
	opacity_tween.tween_property($SuccessBar, "modulate:a", 1., 1.0)
	opacity_tween.tween_property($SuccessBar/Foreground, "material:shader_parameter/percent", res, 1.5)
	opacity_tween.tween_property($SuccessBar, "scale", Vector2(1.025, 1.025), 0.25)
	opacity_tween.tween_property($SuccessBar, "scale", Vector2(1., 1.), 0.25)
	opacity_tween.tween_property($SuccessBar/ScoreLabel, "modulate:a", 1, 0.2).set_delay(0.3)
	opacity_tween.tween_property($SuccessBar, "modulate:a", 0., 0.45).set_delay(1.5)
	
	if res > 0.85:
		opacity_tween.tween_callback(func(): $SadFace.hide())
		opacity_tween.tween_callback(func(): $HappyFace.show())
		opacity_tween.tween_property($HappyFace, "scale", Vector2(0.6, 0.6), 0.25)
		opacity_tween.tween_property($HappyFace, "scale", Vector2(0.5, 0.5), 0.25)
	
	opacity_tween.tween_callback(func(): _exit_scene()).set_delay(0.5)
		
func _exit_scene() -> void:
	hop_timer.stop()
	var tween := get_tree().create_tween()
	tween.tween_property(self, "scale:x", -1, 0.5)
	$AnimationPlayer.play("wobble")
	tween.tween_property(self, "global_position:x", 2320, 3.)
	tween.tween_callback(func(): EventManager.creature_left.emit())
	tween.tween_callback(func(): $AnimationPlayer.stop())
	tween.tween_callback(func(): call_deferred("queue_free"))

func _on_hop_timer_timeout() -> void:
	var tween := get_tree().create_tween()
	tween.tween_property(self, "global_position:y", global_position.y - 20, 0.2)
	tween.tween_property(self, "global_position:y", global_position.y + 20, 0.2)
