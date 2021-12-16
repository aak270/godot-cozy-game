tool
extends NPC
class_name Enemy

export var combat_position_path: NodePath

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
	
func _get_configuration_warning() -> String:
	return "Please assign Combat Position Path" if not combat_position_path else ""
	
func interact() -> void:
	_combat_system.set_enemy(self)
	dialogue_player.play(_dialogues, true)

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
