extends CanvasLayer

const KeyToPress: = preload("res://src/ui/KeyToPress.tscn")

export var time_limit: = 2.0

var player_damage: = 0

var _keys_to_press: = []
var _keys_list: = ["ui_up", "ui_down", "ui_left", "ui_right"]

var _player_turn: = true

var _prompt_started: = false
var _key_released: = true
var _key_left: = 0
var _last_key: = ""

onready var game_controller: = $"../GameController"

onready var _button_container: = $ButtonContainer

onready var _keys: = $Keys
onready var _progress_bar: = $ProgressBar
onready var _tween: = $Tween

onready var _player: = $"../Player"
onready var _camera: = $"../Camera2D"

func _ready() -> void:
	_button_container.hide()
	_progress_bar.hide()
	
func _input(event: InputEvent) -> void:
	if _prompt_started and event is InputEventKey and event.pressed:
		if Input.is_action_just_pressed(_keys_to_press[0]):
			_key_released = false
			_keys.get_child(0).queue_free()
			_last_key = _keys_to_press.pop_front()
			
			_key_left -= 1
			if _key_left == 0:
				stop_prompt()
		elif _key_released:
			stop_prompt()
	
	if not _key_released and Input.is_action_just_released(_last_key):
		_key_released = true

func set_disable_buttons(is_disable: bool) -> void:
	for button in _button_container.get_children():
		button.disabled = is_disable
		button.release_focus()
	
	if not is_disable:
		_button_container.get_child(0).grab_focus()

func start() -> void:
	_prompt_started = false
	_tween.interpolate_property(_camera, "zoom", Vector2(1, 1), Vector2(0.8, 0.8), 
		0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT
	)
	
	_tween.start()
	yield(_tween, "tween_completed")
	
	_button_container.show()
	player_turn()

func end() -> void:
	set_disable_buttons(true)
	
	_tween.interpolate_property(_camera, "zoom", Vector2(0.8, 0.8), Vector2(1, 1), 
		0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT
	)
	
	_tween.start()
	_button_container.hide()
	_progress_bar.hide()

func player_turn() -> void:
	set_disable_buttons(false)
	_player_turn = true

func enemy_turn() -> void:
	_player_turn = false

	yield(game_controller.enemy.attack(), "completed")
	start_prompt()
	
func start_prompt() -> void:
	_keys_to_press.resize(4)
	for i in range(4):
		_keys_to_press[i] = _keys_list[int(rand_range(0, 4))]
	
	_prompt_started = true
	_key_released = true
	_key_left = 4
	
	var start = -60 * 2
	for key in _keys_to_press:
		var key_ui: = KeyToPress.instance()
		_keys.add_child(key_ui)
		
		key_ui.rect_position.x = start
		key_ui.get_child(0).text = key
		start += 70
	
	_progress_bar.show()
	_tween.interpolate_property(_progress_bar, "value", 100, 0, time_limit,
		Tween.TRANS_LINEAR, Tween.EASE_OUT
	)
	
	_tween.start()

func stop_prompt() -> void:
	_prompt_started = false
	
	for child in _keys.get_children():
		child.queue_free()
	
	_keys_to_press.clear()
	_progress_bar.hide()
	_tween.stop_all()
	
	calculate_damage()
	
func calculate_damage() -> void:
	var damage: = 0
	
	if _player_turn:
		damage = player_damage * float(4 - _key_left) / 4
		game_controller.enemy.reduce_health(int(damage))
		yield(game_controller.player.attack_end(), "completed")
		
		if game_controller.enemy.is_dead():
			game_controller.end_combat()
		else:
			enemy_turn()
	else:
		damage = game_controller.enemy.damage * _key_left / 4
		game_controller.player.reduce_effort(int(damage))
		
		yield(game_controller.enemy.attack_end(), "completed")
		player_turn()

func _on_tween_completed(object: Object, _key: NodePath) -> void:
	if _prompt_started and object is ProgressBar:
		stop_prompt()
