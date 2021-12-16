extends CanvasLayer

const KeyToPress: = preload("res://src/ui/KeyToPress.tscn")

export var time_limit: = 2.0

var _keys_to_press: = []
var _keys_list: = ["ui_up", "ui_down", "ui_left", "ui_right"]
var _prompt_started: = false
var _key_released: = true
var _key_left: = 0

onready var _player: = $"../Player"
onready var _camera: = $"../Camera2D"
onready var _button_container: = $ButtonContainer
onready var _button_1: = $ButtonContainer/Button1
onready var _button_2: = $ButtonContainer/Button2
onready var _button_3: = $ButtonContainer/Button3
onready var _keys: = $Keys
onready var _progress_bar: = $ProgressBar
onready var _game_controller: = $"../GameController"
onready var _tween: = $Tween

func _ready() -> void:
	_button_container.hide()
	_progress_bar.hide()
	
func _input(event: InputEvent) -> void:
	if _prompt_started and event is InputEventKey and event.pressed:
		if Input.is_action_just_pressed(_keys_to_press[0]):
			_key_released = false
			_keys.get_child(0).queue_free()
			
			_key_left -= 1
			if _key_left == 0:
				calculate_damage()
		elif _key_released:
			stop_prompt()
	
	if _keys_to_press.size() > 0 and Input.is_action_just_released(_keys_to_press[0]):
		_key_released = true
		_keys_to_press.pop_front()

func start() -> void:
	_tween.interpolate_property(
		_camera, 
		"zoom", 
		Vector2(1, 1), 
		Vector2(0.8, 0.8), 
		0.5, 
		Tween.TRANS_LINEAR, 
		Tween.EASE_OUT
	)
	
	_tween.start()
	
	_game_controller.enemy.start_combat()
	
	yield(_tween, "tween_completed")
	_button_container.show()
	_button_1.grab_focus()

func set_disable_buttons(value: bool) -> void:
	_button_1.disabled = value
	_button_2.disabled = value
	_button_3.disabled = value
	
	if value:
		_button_1.release_focus()
		_button_2.release_focus()
		_button_3.release_focus()
	else:
		_button_1.grab_focus()
		
func enemy_turn() -> void:
	yield(_game_controller.enemy.attack(), "completed")
	
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
	
func player_turn() -> void:
	_progress_bar.hide()
	_prompt_started = false
	yield(_game_controller.enemy.back(), "completed")
	set_disable_buttons(false)
	
func calculate_damage() -> void:
	var damage = _game_controller.enemy.damage * _key_left / 4
	_game_controller.player.get_damage(int(damage))
	player_turn()
	
func stop_prompt() -> void:
	for child in _keys.get_children():
		child.queue_free()
	
	_keys_to_press.clear()
	calculate_damage()

func _on_Button1_pressed() -> void:
	set_disable_buttons(true)
	yield(_player.attack(), "completed")
	enemy_turn()

func _on_Button2_pressed() -> void:
	set_disable_buttons(true)
	yield(_player.attack(), "completed")
	enemy_turn()

func _on_Button3_pressed() -> void:
	set_disable_buttons(true)
	yield(_player.attack(), "completed")
	enemy_turn()

func _on_tween_completed(object: Object, _key: NodePath) -> void:
	if _prompt_started and object is ProgressBar:
		stop_prompt()
