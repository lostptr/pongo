extends Node


const Preferences = preload("res://v2/core/saving/Preferences.gd")
"""
In some devices (for example, mobile and consoles) 
ating systems, the engine uses the typical ~/.Name 
(check the project name under the settings) in OSX and Linux, 
and APPDATA/Name for Windows.
"""
var SAVE_FOLDER: String = "user://debug/save"
var SAVE_NAME_TEMPLATE: String = "save_%03d.tres"

var current_save_id: int
var last_saved: Preferences

func save(id: int):
	
	var pref := last_saved if last_saved != null else Preferences.new()
	
	for node in get_tree().get_nodes_in_group("save"):
		node.save(pref)
	
	var dir: Directory = Directory.new()
	if not dir.dir_exists(SAVE_FOLDER):
		dir.make_dir_recursive(SAVE_FOLDER)
	
	var save_path = SAVE_FOLDER.plus_file(SAVE_NAME_TEMPLATE % id)
	var err: int = ResourceSaver.save(save_path, pref)
	if err != OK:
		print("There was an issue writing the save %s to %s" % [id, save_path])
	
	print("Successfully saved to '%s'" % save_path)
	
func load(id: int):
	
	var save_file_path: String = SAVE_FOLDER.plus_file(SAVE_NAME_TEMPLATE % id)
	var file: File = File.new()
	
	if not file.file_exists(save_file_path):
		print("Save file %s doesn't exist." % save_file_path)
		return
	
	var pref: Resource = load(save_file_path)
	
	for node in get_tree().get_nodes_in_group("save"):
		node.load(pref)
		
	self.last_saved = pref
	print("Loaded save file '%s' successfully" % save_file_path)
