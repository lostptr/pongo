extends Control

var MainGame: PackedScene = preload("res://v2/MainScene.tscn")

func switch_scene(old: Node, new_scene: PackedScene):
	var parent = old.get_parent()
	parent.remove_child(old)
	parent.add_child(new_scene.instance())
