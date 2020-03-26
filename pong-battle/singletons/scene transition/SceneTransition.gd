extends Control

var MainGame: PackedScene = preload("res://v2/MainScene.tscn")
var SettingsMenu: PackedScene = preload("res://menus/AudioSettings/AudioSettings.tscn")
var MainMenu: PackedScene = preload("res://menus/MainMenu/MainMenu.tscn")
var ControlsMenu: PackedScene = preload("res://menus/ControlSettings/ControlSettings.tscn")

var is_playing_music: bool = false

func stop_music():
	$GlobalMusic.playing = false
	is_playing_music = false
	
func play_music(music: AudioStream):
	$GlobalMusic.stream = music
	$GlobalMusic.play()
	is_playing_music = true

func switch_scene(old: Node, new_scene: PackedScene):
	var parent = old.get_parent()
	parent.remove_child(old)
	parent.add_child(new_scene.instance())
