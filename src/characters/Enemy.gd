tool
extends NPC
class_name Enemy

export var combat_position_path: NodePath
export(Array, String, FILE, "*.wav") var voices_path

var voices: = []

var _combat_position: Node

onready var _combat_system: = $"../CombatSystem"
onready var _overworld: = $Overworld
onready var _batlle: = $Battle
onready var _anim: = $AnimationPlayer
onready var _tween: = $Tween

func _ready() -> void:
	_batlle.visible = false
	_anim.play("Ov_Idle")
	_combat_position = get_node(combat_position_path)
	
	if voices_path.size() > 0:
		var i := 0
		voices.resize(voices_path.size())
		for path in voices_path:
			voices[i] = load(path)
			i += 1
	
func _get_configuration_warning() -> String:
	return "Please assign Combat Position Path" if not combat_position_path else ""
	
func interact() -> void:
	_combat_system.set_enemy(self)
	_game_controller.start_dialogue(_dialogues, self)

func start_combat() -> void:
	_batlle.visible = true
	_overworld.visible = false
	_anim.play("Battle_Idle")
	
	_tween.interpolate_property(
		self, 
		"position", 
		global_position, 
		_combat_position.global_position, 
		0.5, 
		Tween.TRANS_LINEAR, 
		Tween.EASE_OUT
	)
	
	_tween.start()
	
func attack() -> void:
	_tween.interpolate_property(
		self, 
		"position:x", 
		global_position.x, 
		global_position.x, 
		0.3, 
		Tween.TRANS_LINEAR, 
		Tween.EASE_OUT
	)
	
	_tween.start()
	yield(_tween, "tween_completed")
	
	_tween.interpolate_property(
		self, 
		"position:x", 
		global_position.x, 
		global_position.x - 40, 
		0.1, 
		Tween.TRANS_LINEAR, 
		Tween.EASE_OUT
	)
	
	_tween.start()
	yield(_tween, "tween_completed")
	
func back() -> void:
	_tween.interpolate_property(
		self, 
		"position:x", 
		global_position.x, 
		global_position.x + 40, 
		0.1, 
		Tween.TRANS_LINEAR, 
		Tween.EASE_OUT
	)
	
	_tween.start()
	yield(_tween, "tween_completed")
	
	_tween.interpolate_property(
		self, 
		"position:x", 
		global_position.x, 
		global_position.x, 
		0.2, 
		Tween.TRANS_LINEAR, 
		Tween.EASE_OUT
	)
	
	_tween.start()
	yield(_tween, "tween_completed")

func get_voice():
	if voices_path.size() > 0:
		return voices[int(rand_range(0, voices.size()))]
	else:
		return null
		
