extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.upgrade_changed.connect(update_effect)

func update_effect(
	timeline : Array[TimelineItemResource],
	purchased_index : Array[int], 
	purchased_time: Array[float]):
		
	var effect = 1
	
	for i in purchased_index:
#		var item_idx = purchased_index[i]
#		print(timeline[item_idx].res.name)
		var res := timeline[i].res
		match res.effect_forward:
			ShopItemResource.EFFECT.ADD:
				effect += res.amount_forward
			ShopItemResource.EFFECT.MULTI:
				effect *= res.amount_forward
				
	Globals.click_increment = effect
	self.text = "$" + str(effect) + " /click"
