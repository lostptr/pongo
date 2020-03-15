extends Control


func _on_StartButton_pressed():
	SceneTransition.switch_scene(self, SceneTransition.MainGame)
