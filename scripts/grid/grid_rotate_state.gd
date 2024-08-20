extends GridState

@export var grid: Grid

@export var angle: float = 0.
@export var ROTATION_SENSITIVITY: int = 700

var rotate_sfx := preload("res://assets/sfx/Rotation Click Soft.wav")
var rotate_sfx_player: AudioStreamPlayer2D

func enter() -> void:
	grid._show_focus = false
	rotate_sfx_player = AudioManager.play_effect(rotate_sfx, 8, true)	

func exit() -> void:
	grid._top_ui.set_rotation_label(angle)
	rotate_sfx_player.queue_free()

func reset() -> void:
	grid._top_ui.set_rotation_label(angle)

func on_draw() -> void:
	pass

func process(delta: float) -> void:
	pass
	
func on_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		for idx in len(grid._points): 
			grid._points[idx] = _rotate(grid._points[idx], event.relative.y/ROTATION_SENSITIVITY)
		
		angle = fmod(angle + event.relative.y/ROTATION_SENSITIVITY, TAU)
		if angle < 0: angle += TAU
		
		if event.relative.y == 0: 
			rotate_sfx_player.stop()
		elif not rotate_sfx_player.playing:
			rotate_sfx_player.play()
		
	elif event.is_action_released("rotate"):
		transition_requested.emit(self, State.BASE)
		
func _rotate(vec: Vector2, angle: float) -> Vector2:
	return Vector2(cos(angle) * vec.x - sin(angle) * vec.y, sin(angle) * vec.x + cos(angle) * vec.y)
	
