extends Area2D

var height: float
var width: float

var hole_vertices := [Vector2(-42, -263), Vector2(-197, -88), Vector2(-28, 130), Vector2(-88, -102)]

func _ready() -> void:
	$Polygon2D.polygon = PackedVector2Array(hole_vertices)

func _on_area_entered(area: Area2D) -> void:
	area.reparent(self)
	area.get_node("CollisionShape2D").set_deferred("disabled", true)
	area.can_drag = false
	
	area.position =  hole_vertices.reduce(func(res, point): return res + point, Vector2(0, 0)) / len(hole_vertices)
