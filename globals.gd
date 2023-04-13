extends Node2D

enum TIME_MODE {
	FORWARD,
	BACKWARD
}

signal time_mode_changed

signal money_changed
signal upgrade_changed

var time_mode: TIME_MODE = TIME_MODE.FORWARD
var money = 0.0
var click_increment = 1
var elapsed_time = 0.0

var game_started = false

const max_upgrade = 4

const rewind_drain_speed = 200.0

func reset():
	money = 0.0
	click_increment = 1
	elapsed_time = 0.0
	time_mode = TIME_MODE.FORWARD

#	self.process_mode = Node.PROCESS_MODE_ALWAYS

func _unhandled_input(event):
	if not game_started:
		return
		
	if event.is_action_pressed("left_mouse"):
		money += click_increment
		money_changed.emit()

func _process(delta):
	
	if not game_started:
		return
	
	match time_mode:
		TIME_MODE.FORWARD:
			elapsed_time += delta
		TIME_MODE.BACKWARD:
			elapsed_time -= delta
			if elapsed_time < -14.0:
				money -= rewind_drain_speed * 12 * delta
			if elapsed_time < -12.0:
				money -= rewind_drain_speed * 8 * delta
			if elapsed_time < -10.0:
				money -= rewind_drain_speed * 6 * delta
			if elapsed_time < -5.0:
				money -= rewind_drain_speed * 1.5 * delta
			else:
				money -= rewind_drain_speed * delta
			if (money <= 0):
#				get_tree().paused = true
				money = 0.0
				time_mode = TIME_MODE.FORWARD
				time_mode_changed.emit()
			money_changed.emit()
#				get_tree().reload_current_scene()
#	print(elapsed_time)

func is_forward():
	return time_mode == TIME_MODE.FORWARD

func set_is_foward(is_foward: bool):
	if is_foward:
		time_mode = TIME_MODE.FORWARD
	else:
		time_mode = TIME_MODE.BACKWARD
	time_mode_changed.emit()
