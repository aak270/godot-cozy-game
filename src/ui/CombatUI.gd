extends Control

const KeyToPress: = preload("res://src/ui/KeyToPress.tscn")

var _player_turn: = false
var _enemy: Enemy = null
var _keys: = ["ui_up", "ui_down", "ui_left", "ui_right"]
var _keys_to_press: = []
var _start_defend: = false

onready var player: = $"../../Player"
onready var camera: = $"../../Camera2D"
onready var attack_1_btn: = $HBoxContainer/Attack1Button
onready var attack_2_btn: = $HBoxContainer/Attack2Button
onready var attack_3_btn: = $HBoxContainer/Attack3Button
onready var keys: = $Keys

func _ready() -> void:
	hide()
	EventHandler.connect("combat_started", self, "start")
	
func start(enemy) -> void:
	show()
	attack_1_btn.grab_focus()
	
	camera.zoom.x = .8
	camera.zoom.y = .8
	_player_turn = true
	_enemy = enemy
	
func next_turn() -> void:
	_player_turn = not _player_turn
	if _player_turn:
		set_disable_buttons(false)
	else:
		set_disable_buttons(true)
		_enemy.play()
		
		_keys_to_press.resize(4)
		for i in range(4):
			_keys_to_press[i] = _keys[int(rand_range(0, 4))]
		start_defend()
	
func set_disable_buttons(value: bool) -> void:
	attack_1_btn.disabled = value
	attack_2_btn.disabled = value
	attack_3_btn.disabled = value
	
	if value:
		attack_1_btn.release_focus()
		attack_2_btn.release_focus()
		attack_3_btn.release_focus()
	else:
		attack_1_btn.grab_focus()
		
func start_defend() -> void:
	_start_defend = true
	
	var start = -135
	for key in _keys_to_press:
		var key_ui: = KeyToPress.instance()
		keys.add_child(key_ui)
		key_ui.rect_position.x = start
		key_ui.get_child(0).text = key
		start += 70
	
func _input(event: InputEvent) -> void:
	if _start_defend:
		if _keys_to_press.size() == 0:
			_start_defend = false
			next_turn()
				
		if Input.is_action_pressed(_keys_to_press[0]):
			_keys_to_press.pop_front()
			keys.get_child(0).queue_free()
			
			if _keys_to_press.size() == 0:
				_start_defend = false
				next_turn()

func _on_Attack1Button_pressed() -> void:
	if _player_turn:
		print("Attack 1")
	
	next_turn()

func _on_Attack2Button_pressed() -> void:
	if _player_turn:
		print("Attack 2")

	next_turn()

func _on_Attack3Button_pressed() -> void:
	if _player_turn:
		print("Attack 3")

	next_turn()
