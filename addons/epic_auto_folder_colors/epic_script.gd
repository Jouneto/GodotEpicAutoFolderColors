@tool
extends EditorPlugin

const EPIC_DEBUG_PANEL_DOCK_UID: String = "uid://bsmjj40v7b88v"
const PATH_CONFIG_FILE: String = "res://EpicAutoFolderColors/config/meow.dat"

var epic_debug_panel_dock: Control

## dictionary that contains paths and colors
var path_colors: Dictionary = {}

func _enable_plugin() -> void:
	print_rich("[b][rainbow][wave]Epic Auto Folder Colors Plugin Is Enabled!1!![/wave][/rainbow][/b]")

func _disable_plugin() -> void:
	print_rich("[b]Goodbye.[b]")

func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	epic_debug_panel_dock = preload(EPIC_DEBUG_PANEL_DOCK_UID).instantiate()
	add_control_to_bottom_panel(epic_debug_panel_dock, "Epic Debug Panel")

func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	remove_control_from_bottom_panel(epic_debug_panel_dock)
	if not epic_debug_panel_dock == null: epic_debug_panel_dock.free()


## saves config file containing all collored pahts w/ csolors
func save_config_file() -> void:
	var config_file : ConfigFile = ConfigFile.new()
	
	# use file if it exists
	if FileAccess.file_exists(PATH_CONFIG_FILE):
		config_file.load(PATH_CONFIG_FILE)

	config_file.set_value("MEOW", "PATH", path_colors)
	
	# save file
	if not config_file.save(PATH_CONFIG_FILE) == OK:
		print_plugin("[color=red]ERROR WHILE SAVING CONFIG FILE!!![color=#fff]")

## prints like noramly but adds [E.A.F.C.] (Epic Auto Color Folders)
func print_plugin(debug_message) -> void:
	print_rich("[color=PINK][b][E.A.F.C.][color=#fff] %s[/b]" % debug_message)
