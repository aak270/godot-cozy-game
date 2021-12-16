extends CanvasLayer

const KeyToPress: = preload("res://src/ui/KeyToPress.tscn")

var _enemy: Enemy = null
var _keys_to_press: = []
var _keys_list: = ["ui_up", "ui_down", "ui_left", "ui_right"]
var _start_defend: = false

onready var _player: = $"../Player"
onready var _camera: = $"../Camera2D"
onready var _button_container: = $ButtonContainer
onready var _button_1: = $ButtonContainer/Button1
onready var _button_2: = $ButtonContainer/Button2
onready var _button_3: = $ButtonContainer/Button3
onready var _keys: = $Keys

func _ready() -> void:
	_button_container.hide()
	
func _input(event: InputEvent) -> void:
	if _start_defend:
		if _keys_to_press.size() == 0:
			player_turn()
				
		if Input.is_action_pressed(_keys_to_press[0]):
			_keys_to_press.pop_front()
			_keys.get_child(0).queue_free()
			
			if _keys_to_press.size() == 0:
				player_turn()

func start() -> void:
	var tween: = Tween.new()
	tween.interpolate_property(
		_camera, 
		"zoom", 
		Vector2(1, 1), 
		Vector2(0.8, 0.8), 
		0.5, 
		Tween.TRANS_LINEAR, 
		Tween.EASE_OUT
	)
	
	add_child(tween)
	tween.start()
	
	_enemy.start_combat()
	
	yield(tween, "tween_completed")
	_button_container.show()
	_button_1.grab_focus()

func set_enemy(enemy: Enemy) -> void:
	_enemy = enemy

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
	yield(_enemy.attack(), "completed")
	
	_keys_to_press.resize(4)
	for i in range(4):
		_keys_to_press[i] = _keys_list[int(rand_range(0, 4))]
	
	_start_defend = true
	var start = -135
	for key in _keys_to_press:
		var key_ui: = KeyToPress.instance()
		_keys.add_child(key_ui)
		key_ui.rect_position.x = start
		key_ui.get_child(0).text = key
		start += 70
	
func player_turn() -> void:
	_start_defend = false
	yield(_enemy.back(), "completed")
	set_disable_buttons(false)

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
