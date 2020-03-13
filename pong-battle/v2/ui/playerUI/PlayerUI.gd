extends MarginContainer

onready var name_label: Label = $Container/PlayerName/Name
onready var name_panel: Panel = $Container/PlayerName/BoxColor
onready var boost_bar: ProgressBar = $Container/Stats/BoostBar
onready var perc_label: Label = $Container/Stats/Perc
onready var perc_anim: AnimationPlayer = $Container/Stats/Perc/PercAnimation
onready var stock_container = $Container/Stats/StockContainer

var StockTextureRect: PackedScene = preload("res://v2/ui/playerUI/StockTexture.tscn")

func _on_Player_initialized(player):
	# Set UI color
	var color = player.modulate
	self.boost_bar.modulate = color
	self.name_panel.modulate = color
	self.stock_container.modulate = color
	
	# Set player name
	self.name_label.text = player.ui_name
	
	# Init boost bar
	self.boost_bar.max_value = player.boost_duration
	self.boost_bar.value = player.boost
	
	# Init perc label
	self.perc_label.text = "%1.1f%%" % player.perc
	
	# Init stock counter
	for i in range(player.stocks):
		var stock_image = StockTextureRect.instance()
		stock_container.add_child(stock_image)

func _on_Player_stat_changed(stat_name: String, stat_value):
	match stat_name:
		"boost":
			update_boost(stat_value)
		"perc":
			update_perc(stat_value)
		"stocks":
			update_stocks(stat_value)

func update_stocks(new_value: int):
	var stock_images = self.stock_container.get_children()
	stock_images.invert()
	for i in range(stock_images.size() - new_value):
		stock_images[i].modulate = Color.transparent
		

func update_boost(new_value: float):
	self.boost_bar.value = new_value
	
func update_perc(new_value: float):
	self.perc_anim.play("hit")
	self.perc_label.text = "%1.1f%%" % new_value


