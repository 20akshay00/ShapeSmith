class_name GridState
extends Node

enum State {BASE, SKEW, ROTATE, DRAW}

signal transition_requested(from: GridState, to: State)
@export var state: State

func enter() -> void:
	pass

func exit() -> void:
	pass
	
func on_input(_event: InputEvent) -> void:
	pass

func on_mouse_entered() -> void:
	pass

func on_mouse_exited() -> void:
	pass
