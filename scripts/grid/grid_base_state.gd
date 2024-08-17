extends GridState

@export var grid: Grid

func on_draw() -> void:
	pass

func on_input(event: InputEvent) -> void:
	if event.is_action_pressed("skew"):
		transition_requested.emit(self, State.SKEW)
	if event.is_action_pressed("rotate"):
		transition_requested.emit(self, State.ROTATE)
	elif event.is_action_pressed("draw") and grid._focus_idx > 0 and not grid._shape_complete:
		if (len(grid._shape_idx) == 0) or (grid._focus_idx == grid._shape_idx[-1]):
			transition_requested.emit(self, State.DRAW)

func enter() -> void:
	grid._show_focus = true

func exit() -> void:
	pass
