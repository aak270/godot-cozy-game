extends Area2D

func _on_body_entered(body: Node) -> void:
	EventHandler.emit_signal("battle_started")
