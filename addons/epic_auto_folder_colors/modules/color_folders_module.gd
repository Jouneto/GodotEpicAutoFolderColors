@tool
extends Node
class_name EAFCColorFoldersModule
## special long class name to not fucked up anyone project :pray: streak: 2
## it returns all the important shit,,, dock setc

## paths that will not be colored at all
var ultra_ignore_paths: Array = [
	"res://",

	# "res://ignoreme/",
	# "res://ignoreme/*",
	# "res://testpath/",
	# "res://testpath/*",
]
## paths that will be "ignore" AKA colored by [member hex_ignore_path_colors]
var ignore_paths: Array = [ # TODO
	# "res://addons/",
	# "res://addons/*",
	# "res://builds/",
	# "res://builds/*",
] 
## colors of paths that are in [member ignore_paths]
var hex_ignore_path_colors: Array = [ # TODO
	"#8a8a8a",
]
## colors of all paths (that are not ignored/ultra ignored)
var hex_path_colors: Array = [ # TODO
	"#e03d3d",
	"#e07e3d",
	"#e0c73d",
	"#70e03d",
	"#3de08e",
	"#3dbde0",
	"#703de0",
	"#e03d84",
]

## contains all paths that were already colored so they will not be colored again
var _checked_paths: Array = []

## will color all the paths, heck yeag
func color(root_folder_item: TreeItem) -> void:
	_checked_paths = [] # clear last buffer
	_color_paths(root_folder_item)
	# return true

## recursively query through every folder and color it according to what woods wishper
func _color_paths(item: TreeItem) -> void:
	var current_color_index: int = 0
	var folder_color: Color

	while item:
		var path: String = item.get_metadata(0)

		var path_already_checked: bool = path in _checked_paths
		var path_is_ultra_ignored: bool = path in ultra_ignore_paths
		var path_is_ignored: bool = path in ignore_paths# or ignore_mode_enabled

		if not path_already_checked and not path_is_ultra_ignored:
			# print("coloring: %s" % item.get_metadata(0))
			_checked_paths.append(path)

			# get color
			folder_color = Color(hex_ignore_path_colors[current_color_index]) if path_is_ignored\
				else Color(hex_path_colors[current_color_index])

			# color folder
			item.set_icon_modulate(0, folder_color)
			folder_color.a = 0.1
			item.set_custom_bg_color(0, folder_color)

			# set next color id
			current_color_index += 1

			var max_color_index: int = hex_path_colors.size()
			if current_color_index >= max_color_index:
				current_color_index = 0

		var ultra_ignore_sub_folders: bool = "%s*" % path in ultra_ignore_paths
		# if not ignore_mode_enabled:
		# 	ignore_mode_enabled = "%s*" % path in ignore_paths

		if not ultra_ignore_sub_folders:
			# query sub folders
			for child in item.get_children():
				_color_paths(child)#, ignore_mode_enabled)
		
		item = item.get_next()


