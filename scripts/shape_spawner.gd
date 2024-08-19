extends Node2D

@onready var creature_scene: PackedScene = preload("res://scenes/shape_creature.tscn")

var holes = [
	 [Vector2(-42, -263), Vector2(-197, -88), Vector2(-28, 130), Vector2(-88, -102)]
]

func _ready() -> void:
	_spawn_creature(holes[0])
	EventManager.creature_left.connect(_on_creature_left)

func _spawn_creature(hole: Array) -> void:
	var creature := creature_scene.instantiate()
	creature.global_position = Vector2(2320, 550)
	creature.hole_vertices = hole.duplicate()
	call_deferred("add_sibling", creature)
	
func _on_creature_left() -> void:
	_spawn_creature(holes[0])
