class_name GridStateMachine
extends Node

@export var initial_state: GridState

var current_state: GridState
var states := {}

func init() -> void:
	for child in get_children():
		if child is GridState:
			states[child.state] = child
			child.transition_requested.connect(_on_transition_requested)
			
	if initial_state:
		initial_state.enter()
		current_state = initial_state

func process(delta: float) -> void:
	if current_state:
		current_state.process(delta)

func on_draw() -> void:
	if current_state:
		current_state.on_draw()

func on_input(event: InputEvent) -> void:
	if current_state:
		current_state.on_input(event)
		
func on_mouse_entered() -> void:
	if current_state:
		current_state.on_mouse_entered()
		
func on_mouse_exited() -> void:
	if current_state:
		current_state.on_mouse_exited()

func _on_transition_requested(from: GridState, to: GridState.State) -> void:
	if from != current_state:
		return 
		
	var new_state: GridState = states[to]
	if not new_state:
		return
		
	if current_state:
		current_state.exit()
		
	new_state.enter()
	current_state = new_state
