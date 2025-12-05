@tool
extends Control

const IGNORE_PATHS: Array = [
	"res://addons"
] 

const COLOR_NAMES: Array = [
	"gray", # special, 0 
	"red",
	"orange",
	"green",
	"teal",
	"blue",
	"purple",
	"pink",
]

var folder_colors_config: Dictionary = {}

var check_for_sub_folders: bool = false
var color_by_layers: bool = false
var merge_with_old_config: bool = true

var _is_searching: Array = []

func _enter_tree() -> void:
	%ManualChangeColorsButton.pressed.connect(_on_change_colors_button)
	%RefreshFilesystemButton.pressed.connect(_on_refresh_file_system_button)

	%NotSubFoldersCheck.button_pressed = not check_for_sub_folders
	%SubFoldersColorLayersCheck.button_pressed = color_by_layers
	%MergeOldConfigCheck.button_pressed = merge_with_old_config

	%NotSubFoldersCheck.toggled.connect(func(on): check_for_sub_folders = not on)
	%SubFoldersColorLayersCheck.toggled.connect(func(on): color_by_layers = on)
	%MergeOldConfigCheck.toggled.connect(func(on): merge_with_old_config = on)

## checks if DirAccess is still searching for folders
func is_done_searching_folders() -> bool:
	return _is_searching.is_empty()

func set_is_searching(done_searching: bool = false) -> void:
	if done_searching:
		_is_searching.pop_back()

		if is_done_searching_folders():
			update_project_godot_file()

		return
	
	_is_searching.append("meow")

func get_next_color_index(current_index: int) -> int: 
	return current_index + 1 if current_index < COLOR_NAMES.size() - 1 else 1


func update_project_godot_file() -> void:
	# test change color
	const PATH_PROJECT_GODOT: String = "res://project.godot"
	var config_file : ConfigFile = ConfigFile.new()

	# use file if it exists
	# if FileAccess.file_exists(PATH_PROJECT_GODOT):
	config_file.load(PATH_PROJECT_GODOT) #! check for fatal error, #brutal


	var current_config: Dictionary = folder_colors_config

	# if (...) then merge color settings rather than overwriting sub folders
	if merge_with_old_config:
		current_config = config_file.get_value("file_customization", "folder_colors")
		current_config.merge(folder_colors_config)

	config_file.set_value("file_customization", "folder_colors", current_config)
	folder_colors_config = {}
	
	# save file
	if not config_file.save(PATH_PROJECT_GODOT) == OK:
		printerr("kms")

## creates config file entry
func color_folders(start_from_folder: String = "", color_offset: int = 1) -> void:
	set_is_searching()

	var path: String = "res://%s" % start_from_folder
	var dir: = DirAccess.open(path)

	var color_index: int = color_offset

	if dir:
		var directory_list: Array = []

		dir.list_dir_begin()
		var file_name = dir.get_next()

		# query through every folder/file
		while file_name != "":
			if dir.current_is_dir():
				directory_list.append(file_name)
			file_name = dir.get_next()

		# query through sorted directories
		directory_list.sort()
		for dir_name in directory_list:
			if "%s%s" % [path, dir_name] in IGNORE_PATHS:
				folder_colors_config["%s%s/" % [path + "/" if start_from_folder else path, dir_name]] = COLOR_NAMES[0]
				continue

			folder_colors_config["%s%s/" % [path + "/" if start_from_folder else path, dir_name]] = COLOR_NAMES[color_index]

			# check for sub folders
			if check_for_sub_folders:
				color_folders("%s%s" % [start_from_folder + "/" if start_from_folder else "", dir_name], get_next_color_index(color_offset if color_by_layers else color_index))


			color_index = get_next_color_index(color_index)


	else:
		printerr("An error occurred when trying to access the path.")

	set_is_searching(true)


func _on_change_colors_button() -> void:
	color_folders()

func _on_refresh_file_system_button() -> void:
	# re-scan for changes
	ProjectSettings.notify_property_list_changed() #? does nothing
	EditorInterface.get_resource_filesystem().scan()
