extends CanvasLayer


@onready var btn_play = $Control/ButtonPlay
@onready var btn_pause = $Control/ButtonPause
@onready var btn_rewind = $Control/ButtonRewind

@onready var sfx = $Control/ButtonPause/SFX

@onready var pause_menu = $PauseMenu

func _ready():
	Globals.time_mode_changed.connect(func (): 
		if not Globals.is_forward():
			btn_rewind.visible = false
		)

func _on_button_pause_pressed():
	get_tree().paused = true
	btn_pause.visible = false
	btn_play.visible = true
	pause_menu.show()
	sfx.play()

func _on_button_play_pressed():
	get_tree().paused = false
	btn_pause.visible = true
	btn_play.visible = false
	pause_menu.hide()

func _on_button_rewind_pressed():
	if Globals.is_forward():
		Globals.set_is_foward(false)
	else:	
		Globals.set_is_foward(true)

func _on_button_restart_pressed():
	Globals.reset()
	await get_tree().reload_current_scene()
	get_tree().paused = false
