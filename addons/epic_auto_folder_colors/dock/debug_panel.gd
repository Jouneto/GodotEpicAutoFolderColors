@tool
extends Control

const PLUGIN_PATH: String = "epic_auto_folder_colors"
const UID_DOCK_GETTER_MODULE: String = "uid://bc0oar01igvwr"
const UID_COLOR_FOLDERS_MODULE: String = "uid://cmdfas04kc7o4"

var check_for_sub_folders: bool = false
var color_by_layers: bool = false
var merge_with_old_config: bool = true

#region modules
var dock_getter_module: EAFCDockGetterModule
var color_folders_module: EAFCColorFoldersModule
#endregion

func _enter_tree() -> void:
	# create and add important modules
	dock_getter_module = load(UID_DOCK_GETTER_MODULE).instantiate()
	add_child(dock_getter_module)

	color_folders_module = load(UID_COLOR_FOLDERS_MODULE).instantiate()
	add_child(color_folders_module)

	# connect signals
	%RefreshFilesystemButton.pressed.connect(_on_refresh_file_system_button)
	%ReloadPluginButton.pressed.connect(_on_reload_plugin_button_pressed)
	%DebugButton.pressed.connect(_on_debug_button_pressed)

	%NotSubFoldersCheck.button_pressed = not check_for_sub_folders
	%SubFoldersColorLayersCheck.button_pressed = color_by_layers
	%MergeOldConfigCheck.button_pressed = merge_with_old_config

	%NotSubFoldersCheck.toggled.connect(func(on): check_for_sub_folders = not on)
	%SubFoldersColorLayersCheck.toggled.connect(func(on): color_by_layers = on)
	%MergeOldConfigCheck.toggled.connect(func(on): merge_with_old_config = on)


#region oldshit
func _on_refresh_file_system_button() -> void:
	# re-scan for changes
	ProjectSettings.notify_property_list_changed() #? does nothing
	EditorInterface.get_resource_filesystem().scan()
#endregion


func _on_reload_plugin_button_pressed() -> void:
	EditorInterface.set_plugin_enabled(PLUGIN_PATH, false)
	EditorInterface.set_plugin_enabled(PLUGIN_PATH, true)


func _on_debug_button_pressed() -> void:
	# color shit
	color_folders_module.color(dock_getter_module.get_root_path())
