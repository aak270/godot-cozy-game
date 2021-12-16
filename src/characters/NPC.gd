extends Interactable
class_name NPC

export(String, FILE, "*.json") var dialogue_file

var _dialogues: = []

onready var dialogue_player: = $"../DialoguePlayer"

func _ready() -> void:
	var file = File.new()
	if file.file_exists(dialogue_file):
		file.open(dialogue_file, file.READ)
		_dialogues = parse_json(file.get_as_text())

func interact() -> void:
	dialogue_player.play(_dialogues)

func on_exit() -> void:
	dialogue_player.stop()
