@tool
extends EditorPlugin


const UID_DOCK_GETTER_MODULE: String = "uid://bc0oar01igvwr"
const UID_COLOR_FOLDERS_MODULE: String = "uid://cmdfas04kc7o4"
const UID_EPIC_DEBUG_PANEL_DOCK: String = "uid://bsmjj40v7b88v"

var epic_debug_panel_dock: Control

#region modules
var dock_getter_module: EAFCDockGetterModule
var color_folders_module: EAFCColorFoldersModule
#endregion


func _enable_plugin() -> void:
	print_rich("[b][rainbow][wave]Epic Auto Folder Colors Plugin Is Enabled!1!![/wave][/rainbow][/b]")

func _disable_plugin() -> void:
	print_rich("[b]Goodbye.[b]")


func _enter_tree() -> void:
	# create debug panel dock
	epic_debug_panel_dock = preload(UID_EPIC_DEBUG_PANEL_DOCK).instantiate()
	add_control_to_bottom_panel(epic_debug_panel_dock, "Epic Debug Panel")

	# create and add important modules
	dock_getter_module = load(UID_DOCK_GETTER_MODULE).instantiate()
	add_child(dock_getter_module)
	color_folders_module = load(UID_COLOR_FOLDERS_MODULE).instantiate()
	add_child(color_folders_module)

func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	remove_control_from_bottom_panel(epic_debug_panel_dock)
	if epic_debug_panel_dock: epic_debug_panel_dock.queue_free()
	if dock_getter_module: dock_getter_module.queue_free()
	if color_folders_module: color_folders_module.queue_free()

	# refresh filesystem
	EditorInterface.get_resource_filesystem().scan()


func _ready() -> void:
	# connect signals
	var tree: Tree = dock_getter_module.get_file_system_tree()
	var file_system: EditorFileSystem = dock_getter_module.file_system

	tree.draw.connect(_update_color)
	dock_getter_module.dock.display_mode_changed.connect(_update_color)
	dock_getter_module.file_system.filesystem_changed.connect(_update_color)

	_update_color()

func _update_color() -> void:
	color_folders_module.color(dock_getter_module.get_root_path())

## prints like noramly but adds [E.A.F.C.] (Epic Auto Color Folders)
func print_plugin(debug_message) -> void:
	print_rich("[color=PINK][b][E.A.F.C.][color=#fff] %s[/b]" % debug_message)
