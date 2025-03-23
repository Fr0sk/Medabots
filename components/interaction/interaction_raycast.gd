class_name InteractionRaycast extends RayCast3D


@export var pickup_slot: Node3D


func can_pickup() -> bool:
	return pickup_slot.get_child_count() == 0


func interact() -> void:
	var collider := get_collider()
	var interaction_component := Interactable.get_from(collider)
	if interaction_component:
		interaction_component.perform_interaction(self)
	


func pickup(item: WorldItem) -> void:
	#var scene := item.scene.instantiate()
	item.reparent(pickup_slot, false)
