extends Interactable

export(String, MULTILINE) var first_text: = ""
export(String, MULTILINE) var second_text: = ""

var _first_interact: = true

onready var dialogue_player: = $"../DialoguePlayer"

func interact() -> void:
	if _first_interact:
		dialogue_player.play([{"name": "Player", "text": first_text}])
		_first_interact = false
	else:
		dialogue_player.play([{"name": "Player", "text": second_text}])

func on_exit() -> void:
	dialogue_player.stop()
