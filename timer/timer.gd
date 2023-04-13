extends Label

class_name TimerLabel

@export var count_down : float = 105.0

var delta_time = 0

var count_up = 0

# Called when the node enters the scene tree for the first time.
#func _ready():
#	update_label_color()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_label(count_down - Globals.elapsed_time)
	update_label_color()

func update_label(time : float):
	var min = ceil(time) / 60.0
	var sec = int(ceil(time)) % 60
	self.text = "%02d:%02d" % [min, sec]

func update_label_color():
	if Globals.is_forward():
		modulate = Color.WHITE
	elif (Globals.elapsed_time < 0):
		modulate = Color.DEEP_SKY_BLUE
	else:
		modulate = Color.LIGHT_GREEN
