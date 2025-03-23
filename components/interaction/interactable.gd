class_name Interactable extends Node3D

signal interacted(instigator: Node)

## Will recursivelly search for parent nodes to find the closes Interactable.
## Returns null if no Interactable found.
static func get_from(node: Node) -> Interactable:
	if node == null:
		return
	
	var parent := node.get_parent()
	if parent == null || parent is Interactable:
		return parent
	return get_from(parent)


func perform_interaction(instigator: Node) -> void:
	interacted.emit(instigator)
