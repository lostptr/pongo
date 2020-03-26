extends Button

signal event_action_changed(button, action, event)

export (String) var action_name: String

onready var label_event: Label = $Label
var action_event: InputEvent setget set_action_event
var listening: bool = false

func _ready():
	var events = InputMap.get_action_list(action_name)
	self.action_event = events[0]

func _unhandled_input(event):
	if listening and event is InputEventKey and event.pressed:
		listening = false
		change_input_event(action_name, event)

func _on_ChangeKeyInput_pressed():
	self.label_event.text = "[...]"
	listening = true
	
func change_input_event(action: String, new_event: InputEvent):
	InputMap.action_erase_events(action)
	InputMap.action_add_event(action, new_event)
	self.action_event = new_event
	emit_signal("event_action_changed", self, action, new_event)
	
func set_action_event(value: InputEvent):
	action_event = value
	if value != null:
		label_event.text = value.as_text()
	else:
		label_event.text = ""

func reset():
	action_event = null
	
func save(preferences):
	preferences[self.action_name] = self.action_event

"""
	Control settings are loaded in the MainMenu, 
	as soon as the game starts.
"""
func load(_preferences):
	pass
