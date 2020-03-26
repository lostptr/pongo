extends Control

func _on_ChangeKey_event_action_changed(button, action, event: InputEvent):
	print(button.name + " changed '" + action + "' to " + event.as_text())

func _on_BackButton_pressed():
	SaveSystem.save(1)
	SceneTransition.switch_scene(self, SceneTransition.MainMenu)
