extends AutoDial

func interact() -> void:
	_game_controller.start_dialogue(_dialogues, self, true)
