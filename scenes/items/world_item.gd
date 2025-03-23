class_name WorldItem extends Interactable


@export var item: Item


func _ready() -> void:
	var scene := item.scene.instantiate()
	add_child(scene)
	interacted.connect(_on_interacted)


func _on_interacted(instigator: InteractionRaycast) -> void:
	if instigator.can_pickup():
		instigator.pickup(self)
		#queue_free()


func get_collision_object() -> CollisionObject3D:
	for child in get_children():
		if child is CollisionObject3D:
			return child
	return null
