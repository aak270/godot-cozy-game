extends Interactable
class_name AutoDial

export(String, FILE, "*.json") var dialogue_file

var _dialogues: = []

onready var _game_controller: = get_tree().get_root().get_node("Level1/GameController")

func _ready() -> void:
	var file = File.new()
	if file.file_exists(dialogue_file):
		file.open(dialogue_file, file.READ)
		_dialogues = parse_json(file.get_as_text())

func interact() -> void:
	_game_controller.start_dialogue(_dialogues)
	
func on_exit() -> void:
	queue_free()
