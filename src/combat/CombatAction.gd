extends TextureButton
class_name CombatAction

export var action_name: = "Punch"
export(String, MULTILINE) var description: = "It is just a normal punch"

export var effort_needed: = 1
export var damage: = 5
export var enemy_damage_modifier: = 1.0
export var no_prompt: = false
export var effort_gained: = 0

export var animation: PackedScene = null

var _first_pressed: = true

onready var _combat_system: = get_tree().get_root().get_node("Game/CombatSystem")
onready var _info_box: = $InfoBox

func _ready() -> void:
	var err
	err = connect("pressed", self, "_on_pressed")
	if err != OK:
		print(err)
		
	err = connect("focus_entered", self, "_on_focus_entered")
	if err != OK:
		print(err)
		
	err = connect("focus_exited", self, "_on_focus_exited")
	if err != OK:
		print(err)
	
	$InfoBox/ActionName.text = action_name
	$InfoBox/Effort.text = "%s effort" % effort_needed
	$InfoBox/Description.text = description
	
	_info_box.hide()
	
func hide_info_box() -> void:
	_info_box.hide()
	_first_pressed = true
	rect_position.x = 0

func _on_pressed() -> void:
	if _first_pressed:
		rect_position.x = 60
		_first_pressed = false
		
		_info_box.show()
	else:
		hide_info_box()
		
		var _player = _combat_system.game_controller.player
		_player.reduce_effort(effort_needed - effort_gained)
		
		_combat_system.combat_ui.hide()
		_combat_system.enemy_damage_modifier = enemy_damage_modifier
		
		if not no_prompt:
			_combat_system.player_damage = damage
		
			if animation != null:
				_combat_system.attackAnimation = animation
				yield(_combat_system.game_controller.wait(0.3), "completed")
			else:
				yield(_player.attack(), "completed")
			
			_combat_system.start_prompt()
		else:
			_combat_system.enemy_turn()

func _on_focus_entered() -> void:
	_combat_system.emit_signal("change_action", self)

func _on_focus_exited() -> void:
	hide_info_box()
