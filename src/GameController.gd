extends Node

enum GameState{
	MOVE,
	DIALOGUE,
	COMBAT
}

signal effort_changed(value)
signal enemy_hp_changed(value)

export var combatPositionPlayer: NodePath
export var combatPositionEnemy: NodePath

var state = GameState.MOVE
var enemy = null

var combat_position_player: Position2D
var combat_position_enemy: Position2D

var _dialogue_has_combat = false
var _is_end = false

onready var player: = $"../Player"

onready var _timer: = $Timer

onready var _combat_system: = $"../CombatSystem"
onready var _dialogue_player:  = $"../DialoguePlayer"

func _ready() -> void:
	randomize()
	
	MusicController.fade_level_music()
	AudioController.ambience_level()
	
	combat_position_player = get_node(combatPositionPlayer)
	combat_position_enemy = get_node(combatPositionEnemy)
	
func _process(_delta: float) -> void:
	if state == GameState.MOVE:
		player.move()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and state == GameState.DIALOGUE:
		_dialogue_player.next_line()
	
func start_dialogue(dialogues, is_enemy = null, is_end = false) -> void:
	player.stop_movement()
	player.interact.set_interact(false)
	
	state = GameState.DIALOGUE
	enemy = null
	_dialogue_has_combat = false
	
	if is_enemy != null and not is_end:
		enemy = is_enemy
		_dialogue_has_combat = true
		yield(player.set_location(Vector2(enemy.global_position.x + 50, enemy.global_position.y)), "completed")

	_is_end = is_end
	if _is_end:
		yield(player.set_location(is_enemy.global_position), "completed")

	_dialogue_player.play(dialogues)
	print("start dialogue")
	
func end_dialogue() -> void:
	state = GameState.MOVE
	_dialogue_player.stop()
	
	if _dialogue_has_combat:
		_dialogue_has_combat = false
		start_combat()
	
	if _is_end:
		get_tree().change_scene("res://src/scenes/StartScreen.tscn")
	print("end dialogue")

func start_combat() -> void:
	MusicController.fade_battle_music()
	AudioController.ambience_battle()
	
	state = GameState.COMBAT
	_combat_system.start()
	player.start_combat(combat_position_player.global_position)
	enemy.start_combat(combat_position_enemy.global_position)
	
	print("start combat")
	
func end_combat() -> void:
	MusicController.fade_level_music()
	AudioController.ambience_level()
	
	enemy.queue_free()
	enemy = null
	
	yield(wait(0.3), "completed")
	
	_combat_system.end()
	player.end_combat()
	state = GameState.MOVE
	
	print("end combat")
	
func wait(seconds: float) -> void:
	_timer.wait_time = seconds
	_timer.start()
	yield(_timer, "timeout")
	
func update_effort(value: float) -> void:
	var effort = value / 50 * 100
	emit_signal("effort_changed", int(effort))
	
func update_enemy_hp(value: int) -> void:
	emit_signal("enemy_hp_changed", value)
