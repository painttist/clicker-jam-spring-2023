extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.upgrade_changed.connect(update_effect_calculation)

func update_effect_calculation(
	timeline : Array[TimelineItemResource],
	purchased_index : Array[int], 
	purchased_time: Array[float]):
		
	var effect = 1
	
	var line1 = str(purchased_index.size()) + '/4 items\n'
	
	var line2 = "1"
	for i in purchased_index:
#		var item_idx = purchased_index[i]
#		print(timeline[item_idx].res.name)
		var res := timeline[i].res
		if res.name == "Watch":
			continue
		match res.effect_forward:
			ShopItemResource.EFFECT.ADD:
				line2 = "(" + line2 + "+" + str(res.amount_forward) +")"
			ShopItemResource.EFFECT.MULTI:
				line2 = "(" + line2 + "x" + str(res.amount_forward) +")"
	
	if line2 == "1":
		line2 = ""
		
	self.text = line1 + line2
