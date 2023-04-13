extends AudioStreamPlayer

@export var click_sfx : Array[AudioStream]

func _unhandled_input(event):
	if event.is_action_pressed("left_mouse"):
		var item = randi_range(0, click_sfx.size() - 1)
#		print(item)
		self.stream = click_sfx[item]
		self.play()
