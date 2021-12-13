extends Control

var _on_dialogue: = false
var _dialogues: = []
var _index: = 0

onready var dialogue_name: = $ColorRect/Name
onready var dialogue_message: = $ColorRect/Message

func _ready() -> void:
	hide()
	EventHandler.connect("dialogue_started", self, "start")
	EventHandler.connect("dialogue_ended", self, "end")
	
func _input(event: InputEvent) -> void:
	if _on_dialogue and event.is_action_pressed("ui_accept"):
		next_line()

func start(npc_name, npc_dialogues) -> void:
	_dialogues = npc_dialogues
	_on_dialogue = true
	_index = 0
	
	dialogue_name.text = "NPC" if npc_name == "" else npc_name
	show_dialogue()
	show()
	
func end() -> void:
	_on_dialogue = false
	_dialogues = []
	hide()

func next_line() -> void:
	_index += 1
	show_dialogue()
	
func show_dialogue() -> void:
	if _index >= len(_dialogues):
		end()
	else:
		dialogue_message.text = _dialogues[_index]
