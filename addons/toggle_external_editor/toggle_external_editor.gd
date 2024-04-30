@tool
extends EditorPlugin

var dock

func _enter_tree():
    dock = preload("toggle_external_editor_dock.tscn").instantiate()
    add_control_to_container(CONTAINER_TOOLBAR, dock)

func _exit_tree():
    remove_control_from_docks(dock)
    dock.free()
