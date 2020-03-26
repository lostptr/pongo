extends Control

onready var voice_test = $VoiceTest
onready var sound_fx_test = $SoundFXTest

onready var music_slider = $AudioContainer/MusicSlider
onready var sfx_slider = $AudioContainer/SoundFXSlider
onready var voice_slider = $AudioContainer/VoiceSlider

func _ready():
	music_slider.set_value(get_linear_audio_bus_volume("Music"))
	sfx_slider.set_value(get_linear_audio_bus_volume("SFX"))
	voice_slider.set_value(get_linear_audio_bus_volume("Voice"))

func get_linear_audio_bus_volume(bus_name: String):
	var bus_index = AudioServer.get_bus_index(bus_name)
	var bus_vol = AudioServer.get_bus_volume_db(bus_index)
	return db2linear(bus_vol) * 100

func _on_MusicSlider_value_changed(value):
	value = value / 100
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear2db(value))

func _on_VoiceSlider_value_changed(value):
	value = value / 100
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Voice"), linear2db(value))
	voice_test.play()

func _on_SoundFXSlider_value_changed(value):
	value = value / 100
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear2db(value))
	sound_fx_test.play()

func _on_BackButton_pressed():
	SaveSystem.save(1)
	SceneTransition.switch_scene(self, SceneTransition.MainMenu)

func save(preferences):
	preferences.music_vol = get_linear_audio_bus_volume("Music")
	preferences.voice_vol = get_linear_audio_bus_volume("Voice")
	preferences.sfx_vol = get_linear_audio_bus_volume("SFX")
	
"""
Audio settings are loaded in the MainMenu, as soon as the game starts.
"""
func load(_preferences):
	pass
