extends CanvasLayer

signal change_action(action)

const KeyToPress: = preload("res://src/ui/KeyToPress.tscn")

export var time_limit: = 2.0

var player_damage: = 0
var enemy_damage_modifier: = 1.0
var attackAnimation: PackedScene = null

var _keys_node: = []
var _keys_to_press: = []
var _keys_list: = ["ui_up", "ui_down", "ui_left", "ui_right"]

var _last_action: CombatAction
var _player_turn: = true
var _attack_anim: AnimatedSprite = null
var _enemy_attack_anim: AnimatedSprite = null

var _prompt_started: = false
var _key_released: = true
var _correct_key: = 0
var _last_key: = ""
var _current_key: = 0

onready var game_controller: = $"../GameController"

onready var combat_ui: = $CombatUI
onready var _action_controller: = $CombatUI/ActionController

onready var _keys: = $Keys
onready var _progress_bar: = $ProgressBar
onready var _tween: = $Tween

onready var _enemy_health: = $EnemyHealth
onready var _enemy_health_progress: = $EnemyHealth/ProgressBar

onready var _player: = $"../Player"
onready var _camera: = $"../Camera2D"

func _ready() -> void:
	var err
	err = connect("change_action", self, "update_action")
	if err != OK:
		print(err)
	
	err = game_controller.connect("enemy_hp_changed", self, "update_enemy_hp")
	if err != OK:
		print(err)
	
	combat_ui.hide()
	_progress_bar.hide()
	_enemy_health.hide()
	
	_last_action = $CombatUI/ActionController/VBoxContainer/.get_child(0)
	
func _input(event: InputEvent) -> void:
	if _prompt_started and event is InputEventKey and event.pressed and event.scancode != KEY_ENTER:
		if Input.is_action_just_pressed(_keys_to_press[_current_key]):
			_correct_key += 1
			_key_released = false
			_keys_node[_current_key].modulate = Color(0, 1, 0)
			
			_keys_node[_current_key].get_child(0).visible = true
			_keys_node[_current_key].get_child(1).visible = false
			
			_last_key = _keys_to_press[_current_key]
			_current_key += 1
			if _current_key >= _keys_node.size():
				stop_prompt()
			else:
				_keys_node[_current_key].get_child(0).visible = false
				_keys_node[_current_key].get_child(1).visible = true
		elif _key_released:
			_keys_node[_current_key].modulate = Color(1, 0, 0)
			
			_keys_node[_current_key].get_child(0).visible = true
			_keys_node[_current_key].get_child(1).visible = false
			
			_last_key = _keys_to_press[_current_key]
			_current_key += 1
			if _current_key >= _keys_node.size():
				stop_prompt()
			else:
				_keys_node[_current_key].get_child(0).visible = false
				_keys_node[_current_key].get_child(1).visible = true
	
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
	_enemy_health_progress.value = 100
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
	if attackAnimation != null:
		_attack_anim = attackAnimation.instance()
		game_controller.combat_position_enemy.add_child(_attack_anim)
		_attack_anim.play("charging")
	
	_keys_to_press.resize(4)
	for i in range(4):
		_keys_to_press[i] = _keys_list[int(rand_range(0, 4))]
	
	_prompt_started = true
	_key_released = true
	_correct_key = 0
	_current_key = 0
	
	var start = -35 * 2
	for key in _keys_to_press:
		var key_ui: = KeyToPress.instance()
		match key:
			"ui_up":
				key_ui.rect_rotation = 0
			"ui_right":
				key_ui.rect_rotation = 90
			"ui_down":
				key_ui.rect_rotation = 180
			"ui_left":
				key_ui.rect_rotation = 270
		
		_keys.add_child(key_ui)
		_keys_node.append(key_ui)
		
		key_ui.rect_position.x = start
		start += 60
	
	_keys.get_child(_current_key).get_child(0).visible = false
	_keys.get_child(_current_key).get_child(1).visible = true
	
	_progress_bar.show()
	_progress_bar.value = 100
	_tween.interpolate_property(_progress_bar, "value", 100, 0, time_limit,
		Tween.TRANS_LINEAR, Tween.EASE_OUT
	)
	
	_tween.start()

func stop_prompt() -> void:
	_prompt_started = false
	_tween.remove(_progress_bar, "value")
	
	yield(game_controller.wait(0.5), "completed")
	for child in _keys.get_children():
		child.queue_free()
	
	_keys_node.clear()
	_keys_to_press.clear()
	combat_ui.hide()
	_progress_bar.hide()
	
	calculate_damage()
	
func calculate_damage() -> void:
	var damage: = 0.0
	
	if _player_turn:
		if attackAnimation != null:
			_attack_anim.play("attack")
			
			yield(_attack_anim, "animation_finished")
			_attack_anim.queue_free()
			
			attackAnimation = null
			_attack_anim = null
		else:
			yield(game_controller.player.attack_end(), "completed")
		
		damage = player_damage * _correct_key / 4.0
		game_controller.enemy.reduce_health(int(damage))
		
		if game_controller.enemy.is_dead():
			game_controller.end_combat()
		else:
			enemy_turn()
	else:
		if game_controller.enemy.attack_anim != null:
			_enemy_attack_anim = game_controller.enemy.attack_anim.instance()
			game_controller.combat_position_player.add_child(_enemy_attack_anim)
			_enemy_attack_anim.frame = 1
			_enemy_attack_anim.play("attack")
			
			yield(_enemy_attack_anim, "animation_finished")
			_enemy_attack_anim.queue_free()
			
			_enemy_attack_anim = null
		
		damage = game_controller.enemy.damage * (4 - _correct_key) / 4
		game_controller.player.reduce_effort(int(damage * enemy_damage_modifier))
		enemy_damage_modifier = 1
		
		yield(game_controller.enemy.attack_end(), "completed")
		player_turn()
		
func update_action(node) -> void:
	_tween.interpolate_property(_action_controller, "scroll_vertical", 
		_action_controller.scroll_vertical, node.rect_position.y, 0.1, 
		Tween.TRANS_QUAD, Tween.EASE_IN
	)
	
	_tween.start()

func update_enemy_hp(value) -> void:
	_enemy_health_progress.value = value

func _on_tween_completed(object: Object, _key: NodePath) -> void:
	if _prompt_started and object is ProgressBar:
		stop_prompt()
