extends Area2D

var height: float
var width: float

var hole_vertices := PackedVector2Array([Vector2(0, 0), Vector2(50, 50), Vector2(50, 25)])

func _process(delta: float) -> void:
	pass

func _on_area_entered(area: Area2D) -> void:
	print("hi")
