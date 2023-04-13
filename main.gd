extends Node2D

@onready var timer := $PlayPauseControl/TimerLabel
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Globals.money >= 30000:
		#win!
		get_tree().change_scene_to_file("res://success.tscn")
	elif Globals.elapsed_time > timer.count_down:
		#lose
		get_tree().change_scene_to_file("res://fail.tscn")

func _ready():
	Globals.game_started = true
