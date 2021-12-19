extends CanvasLayer

const PlayerVN: = preload("res://src/characters/Player/PlayerVN.tscn")

export var text_speed: = 0.05

var _current_index: = 0
var _dialogues: = []
var _finished: = false

var _player_vn
var _enemy_vn

onready var _panel: = $DialogBox
onready var _dialogue_name: = $DialogBox/NameBox/Name
onready var _dialogue_message: = $DialogBox/Message
onready var _timer: = $DialogBox/Timer

onready var _audio: = $AudioStreamPlayer
onready var _portrait: = $Portrait
onready var _game_controller: = $"../GameController"

func _ready() -> void:
	_player_vn = PlayerVN.instance()
	_portrait.add_child(_player_vn)
	_player_vn.hide()
	
	_enemy_vn = null
	_timer.wait_time = text_speed
	_panel.hide()
	_portrait.hide()

func play(dialogue_list) -> void:
	if _game_controller.enemy!= null and _game_controller.enemy.vn != null:
		_enemy_vn = _game_controller.enemy.vn.instance()
		_portrait.add_child(_enemy_vn)
		_enemy_vn.hide()
	
	_dialogues = dialogue_list
	_finished = false
	
	_portrait.show()
	_panel.show()
	show_dialogue()

func stop() -> void:
	_audio.stop()
	_panel.hide()
	_portrait.hide()
	_player_vn.hide()
	
	if _enemy_vn != null:
		_enemy_vn.queue_free()
		_enemy_vn = null
	
	_current_index = 0
	_dialogues = []

func next_line() -> void:
	if _finished:
		_audio.stop()
		_current_index += 1
		show_dialogue()
	else:
		_dialogue_message.visible_characters = len(_dialogue_message.text)

func show_dialogue() -> void:
	if _current_index >= len(_dialogues):
		_game_controller.end_dialogue()
	else:
		_finished = false
		
		_dialogue_name.text = _dialogues[_current_index]["name"]
		_dialogue_message.text = _dialogues[_current_index]["text"]
		
		if _dialogue_name.text == "Enari":
			_player_vn.show()
			if _enemy_vn != null:
				_enemy_vn.hide()
		else:
			_player_vn.hide()
			if _enemy_vn != null:
				_enemy_vn.show()
		
		_dialogue_message.visible_characters = 0
		while _dialogue_message.visible_characters < len(_dialogue_message.text):
			if _dialogue_name.text == "Enari":
				play_audio(_game_controller.player.get_voice())
			elif _game_controller.enemy != null:
				play_audio(_game_controller.enemy.get_voice())
				
			_dialogue_message.visible_characters += 1
			_timer.start()
			yield(_timer, "timeout")
		
		_finished = true

func play_audio(stream) -> void:
	if stream != null and !_audio.is_playing():
		_audio.stream = stream
		_audio.play()
