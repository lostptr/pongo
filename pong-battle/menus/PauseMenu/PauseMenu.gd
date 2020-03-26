extends Control

var main_scene: Node
var enabled: bool = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and enabled:
		var new_pause_state = not get_tree().paused
		get_tree().paused = new_pause_state
		visible = new_pause_state


func _on_MainMenuButton_pressed() -> void:
	if main_scene != null:
		get_tree().paused = false
		SceneTransition.switch_scene(main_scene, SceneTransition.MainMenu)
