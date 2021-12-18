extends CanvasLayer

signal change_action(action)

const KeyToPress: = preload("res://src/ui/KeyToPress.tscn")

export var time_limit: = 2.0

var player_damage: = 0

var _keys_to_press: = []
var _keys_list: = ["ui_up", "ui_down", "ui_left", "ui_right"]

var _last_action: CombatAction
var _player_turn: = true

var _prompt_started: = false
var _key_released: = true
var _key_left: = 0
var _last_key: = ""

onready var game_controller: = $"../GameController"

onready var combat_ui: = $CombatUI
onready var _action_controller: = $CombatUI/ActionController

onready var _keys: = $Keys
onready var _progress_bar: = $ProgressBar
onready var _tween: = $Tween

onready var _enemy_health: = $EnemyHealth
onready var _enemy_health_progree: = $EnemyHealth/ProgressBar

onready var _player: = $"../Player"
onready var _camera: = $"../Camera2D"

func _ready() -> void:
	connect("change_action", self, "update_action")
	game_controller.connect("enemy_hp_changed", self, "update_enemy_hp")
	
	combat_ui.hide()
	_progress_bar.hide()
	_enemy_health.hide()
	
	_last_action = $CombatUI/ActionController/VBoxContainer/Action1
	
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
		
func set_active() -> void:
	combat_ui.show()
	_last_action.grab_focus()

func start() -> void:
	_prompt_started = false
	_tween.interpolate_property(_camera, "zoom", Vector2(1, 1), Vector2(0.8, 0.8), 
		0.5, Tween.TRANS_QUAD, Tween.EASE_OUT
	)
	
	_tween.start()
	yield(_tween, "tween_completed")
	_enemy_health.show()
	
	set_active()
	player_turn()

func end() -> void:
	combat_ui.hide()
	_progress_bar.hide()
	_enemy_health.hide()
	
	_tween.interpolate_property(_camera, "zoom", Vector2(0.8, 0.8), Vector2(1, 1), 
		0.5, Tween.TRANS_QUAD, Tween.EASE_IN
	)
	
	_tween.start()

func player_turn() -> void:
	set_active()
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
	combat_ui.hide()
	_progress_bar.hide()
	_tween.stop_all()
	
	calculate_damage()
	
func calculate_damage() -> void:
	var damage: = 0.0
	
	if _player_turn:
		damage = player_damage * float(4 - _key_left) / 4
		game_controller.enemy.reduce_health(damage)
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
		
func update_action(node) -> void:
	_tween.interpolate_property(_action_controller, "scroll_vertical", 
		_action_controller.scroll_vertical, node.rect_position.y, 0.1, 
		Tween.TRANS_QUAD, Tween.EASE_IN
	)
	
	_tween.start()

func update_enemy_hp(value) -> void:
	_enemy_health_progree.value = value

func _on_tween_completed(object: Object, _key: NodePath) -> void:
	if _prompt_started and object is ProgressBar:
		stop_prompt()
