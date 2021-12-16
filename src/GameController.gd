extends Node

enum GameState{
	MOVE,
	DIALOGUE,
	COMBAT
}

var state = GameState.MOVE
var enemy = null

var _dialogue_has_combat = false

onready var player: = $"../Player"

onready var _combat_system: = $"../CombatSystem"
onready var _dialogueplayer:  = $"../DialoguePlayer"

func _ready() -> void:
	randomize()
	
	MusicController.fade_level_music()
	AudioController.ambience_level()
	
func _process(delta: float) -> void:
	if state == GameState.MOVE:
		player.move()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and state == GameState.DIALOGUE:
		_dialogueplayer.next_line()
	
func start_dialogue(dialogues, is_enemy = null) -> void:
	player.stop_movement()
	player.interact.set_interact(false)
	
	state = GameState.DIALOGUE
	enemy = is_enemy
	
	_dialogue_has_combat = false if is_enemy == null else true
	_dialogueplayer.play(dialogues)
	
func end_dialogue() -> void:
	state = GameState.MOVE
	_dialogueplayer.stop()
	
	if _dialogue_has_combat:
		start_combat()

func start_combat() -> void:
	MusicController.fade_battle_music()
	AudioController.ambience_battle()
	
	state = GameState.COMBAT
	_combat_system.start()
	player.start_combat()