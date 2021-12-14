extends Interactable

export var npc_name: = ""
export(Array, String) var npc_dialogues

var _player: Node

func interact() -> void:
	_player.update_interactable(null)
	EventHandler.emit_signal("dialogue_started", npc_name, npc_dialogues)
	
func _on_body_entered(body: Node) -> void:
	_player = body
	_player.update_interactable(self)

func _on_body_exited(_body: Node) -> void:
	_player.update_interactable(null)
	EventHandler.emit_signal("dialogue_ended")
