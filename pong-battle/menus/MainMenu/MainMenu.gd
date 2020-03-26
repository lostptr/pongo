extends Control

func _ready():
	if not SceneTransition.is_playing_music:
		SaveSystem.load(1)
		SceneTransition.play_music(preload("res://music/bossa_pause_menu.ogg"))
	$AnimationPlayer.play("init")

func _on_StartButton_pressed():
	SceneTransition.stop_music()
	SceneTransition.switch_scene(self, SceneTransition.MainGame)

func _on_SettingsButton_pressed():
	SceneTransition.switch_scene(self, SceneTransition.SettingsMenu)

func _on_ControllerButton_pressed():
	SceneTransition.switch_scene(self, SceneTransition.ControlsMenu)

func save(_preferences):
	pass

func load(preferences):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear2db(preferences.music_vol / 100)) 
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Voice"), linear2db(preferences.voice_vol / 100))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear2db(preferences.sfx_vol / 100))

	set_input_event("up_1", preferences)
	set_input_event("right_1", preferences)
	set_input_event("down_1", preferences)
	set_input_event("left_1", preferences)
	set_input_event("a_1", preferences)

	set_input_event("up_2", preferences)
	set_input_event("right_2", preferences)
	set_input_event("down_2", preferences)
	set_input_event("left_2", preferences)
	set_input_event("a_2", preferences)

func set_input_event(action: String, preferences: Resource):
	var new_event = preferences[action]
	InputMap.action_erase_events(action)
	InputMap.action_add_event(action, new_event)
