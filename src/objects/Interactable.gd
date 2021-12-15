extends Area2D
class_name Interactable

func interact() -> void:
	print("interact with object")
	queue_free()

func on_exit() -> void:
	pass
