extends Node2D

@onready var creature_scene: PackedScene = preload("res://scenes/shape_creature.tscn")

var holes = [
	 [Vector2(-42, -263), Vector2(-197, -88), Vector2(-28, 130), Vector2(-88, -102)]
]

func _ready() -> void:
	_spawn_creature(holes[0])
	EventManager.creature_left.connect(_on_creature_left)
	#print(generate_polygon(Vector2(0, 0), 50., 0.3, 0.6, 5))

func _spawn_creature(hole: Array) -> void:
	var creature := creature_scene.instantiate()
	creature.global_position = Vector2(2320, 550)
	creature.hole_vertices = generate_polygon(Vector2(0, -50), 150., 0.8, 0.6, 5)
	call_deferred("add_sibling", creature)
	
func _on_creature_left() -> void:
	_spawn_creature(holes[0])

func generate_polygon(center: Vector2, avg_radius: float, irregularity: float, spikiness: float, num_vertices: int) -> Array:
	# Parameter check
	irregularity = clamp(irregularity, 0., 1.)
	spikiness = clamp(spikiness, 0., 1.)

	irregularity *= TAU / num_vertices
	spikiness *= avg_radius
	var angle_steps := random_angle_steps(num_vertices, irregularity)

	# now generate the points
	var points = []
	var angle := randf_range(0, TAU)
	
	for i in num_vertices:
		var radius: float = clamp(randfn(avg_radius, spikiness), 0, 2 * avg_radius)
		var point := Vector2(center.x + radius * cos(angle), center.y + radius * sin(angle))
		points.push_back(point)
		angle += angle_steps[i]

	return points
	
func random_angle_steps(steps: int, irregularity: float) -> Array:
	# generate n angle steps
	var angles = []
	var lower := (TAU / steps) - irregularity
	var upper := (TAU / steps) + irregularity
	var cumsum := 0.
	
	for i in steps:
		var angle = randf_range(lower, upper)
		angles.push_back(angle)
		cumsum += angle

	# normalize the steps so that point 0 and point n+1 are the same
	for i in len(angles):
		angles[i] * TAU/cumsum
	
	return angles
