class_name Interactor extends RayCast3D


@export var pickup_slot: Node3D
var interactable_focused: Interactable


func _physics_process(_delta: float) -> void:
	var collider := get_collider()
	if not collider is Interactable:
		if interactable_focused:
			interactable_focused.unfocus()
			interactable_focused = null
		return
	
	var interactable := (collider as Interactable)
	if interactable != interactable_focused:
		if interactable_focused:
			interactable_focused.unfocus()
		interactable_focused = interactable
		interactable.focus()


func can_pickup() -> bool:
	return pickup_slot.get_child_count() == 0


func interact() -> void:
	if interactable_focused:
		interactable_focused.perform_interaction(self)
