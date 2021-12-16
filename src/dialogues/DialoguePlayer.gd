extends CanvasLayer

export var playerInteract: NodePath
 
var _player_interact: PlayerInteract = null
var _on_dialogue = false
var _current_index: = -1
var _dialogues: = []
var _combat_dialogue: = false

onready var _panel: = $ColorRect
onready var _dialogue_name: = $ColorRect/Name
onready var _dialogue_message: = $ColorRect/Message
onready var _combat_system: = $"../CombatSystem"

func _ready() -> void:
	_panel.hide()
	_player_interact = get_node(playerInteract)
	
func _input(event: InputEvent) -> void:
	if _on_dialogue and event.is_action_pressed("ui_accept"):
		next_line()

func play(json, is_enemy = false) -> void:
	_player_interact.set_interact(false)
	
	_on_dialogue = true
	_dialogues = json
	_panel.show()
	
	if is_enemy:
		_combat_dialogue = true;
		next_line()

func stop() -> void:
	_panel.hide()
	_player_interact.set_interact(true)
	
	_on_dialogue = false
	_current_index = -1
	_dialogues = []
	
	if _combat_dialogue:
		_combat_dialogue = false
		_combat_system.start()

func next_line() -> void:
	_current_index += 1
	show_dialogue()

func show_dialogue() -> void:
	if _current_index >= len(_dialogues):
		stop()
	else:
		_dialogue_name.text = _dialogues[_current_index]["name"]
		_dialogue_message.text = _dialogues[_current_index]["text"]
