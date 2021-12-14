extends Control

var _player_turn: = false
var _enemy: Enemy = null

onready var player: = $"../../Player"
onready var camera: = $"../../Camera2D"
onready var attack_1_btn: = $HBoxContainer/Attack1Button
onready var attack_2_btn: = $HBoxContainer/Attack2Button
onready var attack_3_btn: = $HBoxContainer/Attack3Button

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
		yield(_enemy.play(), "completed")
		next_turn()
	
func set_disable_buttons(value: bool) -> void:
	attack_1_btn.disabled = value
	attack_2_btn.disabled = value
	attack_3_btn.disabled = value

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
