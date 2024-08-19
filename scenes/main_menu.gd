extends Node2D

@onready var creature_scene: PackedScene = preload("res://scenes/shape_creature.tscn")

var holes = [Vector2(-42, -263), Vector2(-197, -88), Vector2(-28, 130), Vector2(-88, -102)]
var creature: Creature

var can_start: bool = false

func _ready() -> void:
	_spawn_creature(holes)
	get_tree().create_timer(3).timeout.connect(_play_scene)

func _spawn_creature(hole: Array) -> void:
	creature = creature_scene.instantiate()
	creature.global_position = Vector2(2320, 550)
	creature.hole_vertices = hole
	add_child(creature)

func _play_scene():
	var tween = self.create_tween()
	for label in $Dialogues.get_children():
		tween.tween_property(label, "modulate:a", 1, 1.5).set_delay(2)
	
	tween.tween_callback(_main_screen).set_delay(3)

func _main_screen():
	var tween = self.create_tween()
	tween.set_parallel()
	tween.tween_property($Dialogues, "modulate:a", 0., 1.)
	tween.tween_property(creature, "modulate:a", 0., 1.)
	tween.tween_property($Title, "modulate:a", 1., 4.).set_delay(1.)		
	tween.tween_property($Help, "modulate:a", 1., 3.).set_delay(4.)		
	tween.tween_property($Start, "modulate:a", 1., 3.).set_delay(7.)
	tween.tween_callback(_start_blinking).set_delay(10.)
	tween.tween_callback(func(): can_start = true)
	
func _input(event: InputEvent) -> void:
	if can_start and event.is_action_pressed("start"):
		TransitionManager._change_scene("res://scenes/world.tscn")

func _start_blinking() -> void:
	var tween = self.create_tween()
	tween.set_loops()
	tween.tween_property($Start, "modulate:a", 0.3, 1.).set_delay(0.25)
	tween.tween_property($Start, "modulate:a", 1., 1.)
