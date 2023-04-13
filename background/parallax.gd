extends ParallaxBackground

@onready var parallax_l1 = $ParallaxLayer
@onready var parallax_l2 = $ParallaxLayer2
@onready var parallax_l3 = $ParallaxLayer3

@onready var castle_bg = $ParallaxLayer/CastleBg

const multiplier_l1 = 3.0
const multiplier_l2 = 6.0
const multiplier_l3 = 9.0

func _ready():
	Globals.time_mode_changed.connect(_on_time_mode_changed)

func _input(event):
	if event is InputEventMouseMotion:
		var mouse_x = event.position.x
		var mouse_y = event.position.y
		
		var viewport_size = get_viewport().size
		var relative_x = (mouse_x - (viewport_size.x/2)) / (viewport_size.x/2)
		var relative_y = (mouse_y - (viewport_size.y/2)) / (viewport_size.y/2)
		
		parallax_l1.motion_offset.x = multiplier_l1 * relative_x
		parallax_l2.motion_offset.x = multiplier_l2 * relative_x
		parallax_l3.motion_offset.x = multiplier_l3 * relative_x

func _on_time_mode_changed():
	match Globals.time_mode:
		Globals.TIME_MODE.FORWARD:
			castle_bg.modulate = Color.WHITE
		Globals.TIME_MODE.BACKWARD:
			castle_bg.modulate = Color.DIM_GRAY
