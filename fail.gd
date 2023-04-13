extends Node2D


func _on_button_restart_pressed():
	get_tree().change_scene_to_file("res://intro.tscn")
