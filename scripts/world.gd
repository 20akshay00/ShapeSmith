extends Node2D

@export var help_screen: TextureRect
@export var UI: CanvasLayer
@export var trash: Area2D

var tween: Tween 
var is_active: bool = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("help"):
		if is_active:
			is_active = false
			if tween: tween.kill()
			UI.hide()
			tween = get_tree().create_tween()
			tween.tween_property(help_screen, "modulate:a", 1, 0.5)
			tween.tween_property(trash, "modulate:a", 0, 0.5)
			tween.tween_callback(func(): trash.hide())
		else:
			is_active = true
			if tween: tween.kill()
			UI.show()
			tween = get_tree().create_tween()
			tween.tween_property(help_screen, "modulate:a", 0, 0.5)
			trash.show()
			tween.tween_property(trash, "modulate:a", 1, 0.5)		
