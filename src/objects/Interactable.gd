extends Area2D
class_name Interactable

func interact() -> void:
	print("interact with object")
	queue_free()

func _on_body_entered(body: Node) -> void:
	body.update_interactable(self)

func _on_body_exited(body: Node) -> void:
	body.update_interactable(null)
