extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.time_mode_changed.connect(_on_change_mode)

func _on_change_mode():
	if Globals.is_forward():
		self.stop()
	else:
		self.play()
