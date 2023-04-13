extends TextureButton

@onready var progress_bar = $ProgressBar
@onready var label_effect = $LabelEffect
@onready var label_price = $LabelPrice
@onready var label_per_click = $LabelPerClick
@onready var item_icon = $ShopItemIcon

@onready var sfx = $SFX

var item_duration = 2.0; #s
var item_dur_timer = item_duration;

@export var timeline : Array[TimelineItemResource]

var timeline_item_index = 0

var item_start_time : float
var item_end_time : float

var purchased_time : Array[float]
var purchased_index: Array[int]

var enough_money = false
var max_upgrade = false

@export var button_rewind : TextureButton

func _ready():
	Globals.money_changed.connect(check_enough_money)
	update_display()
	Globals.time_mode_changed.connect(update_display)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if index_out_of_bounds():
		timeline_item_index = clamp(timeline_item_index, 0, timeline.size() - 1)
		
	match Globals.time_mode:
		Globals.TIME_MODE.FORWARD:
			
			item_start_time = timeline[timeline_item_index].time
			var item_dur = timeline[timeline_item_index].duration
			item_end_time = item_start_time + item_dur

			if Globals.elapsed_time >= item_start_time:
				if Globals.elapsed_time < item_end_time:
					if purchased_index.size() > 0:
						if purchased_index[-1] == timeline_item_index:
							# Item is purchased
							self.hide()
							return
					update_item_content()
					self.show()
				else:
					self.hide()
					timeline_item_index += 1
			else:
				self.hide()

#			item_dur_timer -= delta
			progress_bar.value = 100 - (Globals.elapsed_time - item_start_time) / item_dur * 100
		Globals.TIME_MODE.BACKWARD:
			
			process_return_item()
			
			item_start_time = timeline[timeline_item_index].time
			var item_dur = timeline[timeline_item_index].duration
			item_end_time = item_start_time + item_dur
			
			var item_available_time = item_end_time
			
			if purchased_index.size() > 0:
				if purchased_index[-1] == timeline_item_index:
					# Item is purchased
					item_available_time = purchased_time[-1]
			
			if Globals.elapsed_time < item_available_time:
				if Globals.elapsed_time >= item_start_time:
					update_item_content()
					self.show()
				else:
					self.hide()
					timeline_item_index -= 1
			else:
				self.hide()
			
			progress_bar.value = 100 - (Globals.elapsed_time - item_start_time) / item_dur * 100
#			item_dur_timer += delta
#			progress_bar.value = item_dur_timer / item_duration * 100
#	if item_dur_timer > item_duration || item_dur_timer <= 0:
#		self.hide()
#	else:
#		self.show()

func process_return_item():
	if purchased_time.size() <= 0:
		return
		
	if Globals.elapsed_time < purchased_time[-1]:
		purchased_time.pop_back()
		var idx = purchased_index.pop_back()
		Globals.upgrade_changed.emit(timeline, purchased_index, purchased_time)
		Globals.money += timeline[idx].res.price
		Globals.money_changed.emit()
		
		if (timeline[idx].res.name == "Watch"):
			button_rewind.visible = false
		
		if purchased_index.size() >= Globals.max_upgrade:
			max_upgrade = true
		else:
			max_upgrade = false
		
func index_out_of_bounds():
	return timeline_item_index >= timeline.size() || timeline_item_index < 0

func check_enough_money():
	if index_out_of_bounds():
		return
		
	if Globals.money >= timeline[timeline_item_index].res.price:
		enough_money = true
	else:
		enough_money = false
		
	update_display()

func update_item_content():
	check_enough_money()
	update_display()
	var item_info = timeline[timeline_item_index].res
	if item_info.name == "Watch":
		label_per_click.text = "Rewind"
		label_effect.text = "??"
	else:
		label_per_click.text = "/click"
		match item_info.effect_forward:
			item_info.EFFECT.ADD:
				label_effect.text = "+" + str(item_info.amount_forward)
			item_info.EFFECT.MULTI:
				label_effect.text = "x" + str(item_info.amount_forward)
	
	item_icon.texture = item_info.texture

	label_price.text = "$" + str(item_info.price)
	
func _on_pressed():
	# record time pressed somewhere
	# make update to global item
	
	if not enough_money or max_upgrade or not Globals.is_forward():
		return
	
	sfx.play()
	purchased_index.push_back(timeline_item_index)
	purchased_time.push_back(Globals.elapsed_time)
	Globals.upgrade_changed.emit(timeline, purchased_index, purchased_time)
	Globals.money -= timeline[timeline_item_index].res.price
	Globals.money_changed.emit()
	
	if (timeline[timeline_item_index].res.name == "Watch"):
		button_rewind.visible = true
	
	self.hide()
	timeline_item_index += 1
	
	if purchased_index.size() >= Globals.max_upgrade:
		max_upgrade = true
	else:
		max_upgrade = false

func can_purchase():
#	print("Can purchase? ", enough_money and not max_upgrade and Globals.is_forward())
	return enough_money and not max_upgrade and Globals.is_forward()

func update_display():
	if can_purchase():
		modulate = Color.WHITE
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	else:
		modulate = Color.DARK_GRAY
		mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN
		
