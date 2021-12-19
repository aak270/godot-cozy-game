extends Interactable

export(String, MULTILINE) var first_text: = ""
export(String, MULTILINE) var second_text: = ""

var _first_interact: = true

onready var _game_controller: = $"../GameController"

func interact() -> void:
	if _first_interact:
		_game_controller.start_dialogue([{"name": "Player", "text": first_text}])
		_first_interact = false
	else:
		_game_controller.start_dialogue([{"name": "Player", "text": second_text}])

func on_exit() -> void:
	_game_controller.end_dialogue()
