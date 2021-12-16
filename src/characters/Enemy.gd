extends NPC
class_name Enemy

export var combat_position_path: NodePath

var _combat_position: Node

onready var _combat_system: = $"../CombatSystem"

func _ready() -> void:
	_combat_position = get_node(combat_position_path)
	
func interact() -> void:
	dialogue_player.play(_dialogues, true)
	_combat_system.set_enemy(self)

func start_combat() -> void:
	var tween: = Tween.new()
	tween.interpolate_property(
		self, 
		"position", 
		global_position, 
		_combat_position.global_position, 
		0.5, 
		Tween.TRANS_LINEAR, 
		Tween.EASE_OUT
	)
	
	add_child(tween)
	tween.start()
	
func attack() -> void:
	var tween: = Tween.new()
	tween.interpolate_property(
		self, 
		"position:x", 
		global_position.x, 
		global_position.x, 
		0.3, 
		Tween.TRANS_LINEAR, 
		Tween.EASE_OUT
	)
	
	add_child(tween)
	tween.start()
	yield(tween, "tween_completed")
	
	tween.interpolate_property(
		self, 
		"position:x", 
		global_position.x, 
		global_position.x - 40, 
		0.1, 
		Tween.TRANS_LINEAR, 
		Tween.EASE_OUT
	)
	
	tween.start()
	yield(tween, "tween_completed")
	
func back() -> void:
	var tween: = Tween.new()
	tween.interpolate_property(
		self, 
		"position:x", 
		global_position.x, 
		global_position.x + 40, 
		0.1, 
		Tween.TRANS_LINEAR, 
		Tween.EASE_OUT
	)
	
	add_child(tween)
	tween.start()
	yield(tween, "tween_completed")
	
	tween.interpolate_property(
		self, 
		"position:x", 
		global_position.x, 
		global_position.x, 
		0.2, 
		Tween.TRANS_LINEAR, 
		Tween.EASE_OUT
	)
	
	tween.start()
	yield(tween, "tween_completed")
