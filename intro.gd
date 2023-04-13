extends Node2D

#@onready var main_scene = preload("res://main.tscn").instantiate()

func _unhandled_input(event):
	if event.is_action_pressed("left_mouse"):
		await get_tree().change_scene_to_file("res://main.tscn")
		Globals.reset()
