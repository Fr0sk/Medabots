class_name Interactable extends Area3D

signal interacted(instigator: Interactor)

@export var mesh: GeometryInstance3D
@export var outline: Material


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


func focus() -> void:
	mesh.material_overlay = outline


func unfocus() -> void:
	mesh.material_overlay = null
