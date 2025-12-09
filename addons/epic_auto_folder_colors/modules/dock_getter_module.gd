@tool
extends Node
class_name EAFCDockGetterModule
## special long class name to not fucked up anyone project :pray:
## it returns all the important shit,,, dock setc


var file_system: EditorFileSystem = EditorInterface.get_resource_filesystem()
var dock: FileSystemDock = EditorInterface.get_file_system_dock()
var _tree: Tree:
	get:
		if not _tree: _set_file_system_tree(dock)
		return _tree
var _root: TreeItem:
	get:
		if not _root: _root = get_file_system_tree().get_root()
		return _root
var _root_folder: TreeItem:
	get:
		if not _root_folder: _set_root_path(_root)
		return _root_folder


## returns Tree node from... why do I even try to explain, fucking read fucntion name you morron
func get_file_system_tree() -> Tree:
	return _tree

## retrurens root from tree
func get_file_system_root() -> TreeItem:
	return _root

## returns root path tree item
func get_root_path() -> TreeItem:
	return _root_folder


## recursively qeury tree root to find "res://" shi'
func _set_root_path(item: TreeItem) -> bool:
	while item:
		var path = item.get_metadata(0)
		if path == "res://":
			_root_folder = item
			return true

		for child in item.get_children():
			if _set_root_path(child): return true

		item = item.get_next()
	return false

## recursivly search through filessytem dock to find tree and set it
func _set_file_system_tree(node: Node) -> bool:
	if node is Tree:
		_tree = node
		return true

	# if not tree then recursively query through every child
	for node_child in node.get_children():
		if _set_file_system_tree(node_child): return true
	return false
