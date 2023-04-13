extends Label


func _ready():
	Globals.money_changed.connect(update_money)
	
func update_money():
	self.text = "$" + get_currency(Globals.money)

static func get_currency(number):

	# Place the decimal separator
	var txt_numb : String = "%d" % abs(number)

	# Place the thousands separator
	for idx in range(txt_numb.length() - 3, 0, -3):
		txt_numb = txt_numb.insert(idx, ",")
		
	if number < 0:
		txt_numb = "-" + txt_numb
		
	return(txt_numb)
