extends Node2D


func _ready():
	Globals.upgrade_changed.connect(update_item_slots)

func update_item_slots(
	timeline : Array[TimelineItemResource],
	purchased_index : Array[int], 
	purchased_time: Array[float]):
		
#	var children := get_children()
	
	for i in range(0,purchased_index.size()):
		var item_idx = purchased_index[i]
#		print(timeline[item_idx].res.name)
		var item_image = get_child(i).get_child(0)
#		print(item_image)
		if item_image is Sprite2D:
			item_image.texture = timeline[item_idx].res.texture
			print("Updates texture")
			print(item_image.texture)

	# Resets all other slots
	for i in range(purchased_index.size(), get_child_count()):
		var item_image = get_child(i).get_child(0)
		if item_image is Sprite2D:
			item_image.texture = null
	
	print("----------")
