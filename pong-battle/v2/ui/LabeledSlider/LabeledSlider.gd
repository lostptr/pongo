extends HBoxContainer

signal value_changed(value)

onready var label: Label = $Label
onready var slider: HSlider = $Slider

func _ready():
	self.label.text = get_formatted_value(self.slider.value)

func _on_Slider_value_changed(value):
	self.label.text = get_formatted_value(value)
	emit_signal("value_changed", value)

func get_formatted_value(value: float) -> String:
	return "%d" % value
	
func set_value(value):
	slider.value = value
