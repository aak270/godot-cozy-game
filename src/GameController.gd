extends Node

enum GameState{
	MOVE,
	DIALOGUE,
	COMBAT
}

signal effort_changed(value)

var state = GameState.MOVE
var enemy = null

var _dialogue_has_combat = false

onready var player: = $"../Player"

onready var _timer: = $Timer

onready var _combat_system: = $"../CombatSystem"
onready var _dialogue_player:  = $"../DialoguePlayer"

func _ready() -> void:
	randomize()
	
	MusicController.fade_level_music()
	AudioController.ambience_level()
	
func _process(_delta: float) -> void:
	if state == GameState.MOVE:
		player.move()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and state == GameState.DIALOGUE:
		_dialogue_player.next_line()
	
func start_dialogue(dialogues, is_enemy = null) -> void:
	player.stop_movement()
	player.interact.set_interact(false)
	
	state = GameState.DIALOGUE
	enemy = is_enemy
	
	_dialogue_has_combat = false if is_enemy == null else true
	_dialogue_player.play(dialogues)
	
	print("start dialogue")
	
func end_dialogue() -> void:
	state = GameState.MOVE
	_dialogue_player.stop()
	
	if _dialogue_has_combat:
		_dialogue_has_combat = false
		start_combat()
	
	print("end dialogue")

func start_combat() -> void:
	MusicController.fade_battle_music()
	AudioController.ambience_battle()
	
	state = GameState.COMBAT
	_combat_system.start()
	player.start_combat()
	enemy.start_combat()
	
	print("start combat")
	
func end_combat() -> void:
	MusicController.fade_level_music()
	AudioController.ambience_level()
	
	enemy.queue_free()
	enemy = null
	
	_timer.wait_time = 0.3
	_timer.start()
	yield(_timer, "timeout")
	
	_combat_system.end()
	player.end_combat()
	state = GameState.MOVE
	
	print("end combat")
	
func update_effort(value: int) -> void:
	emit_signal("effort_changed", value)
