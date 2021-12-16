extends Button

export var effort_needed: = 1
export var damage: = 5

onready var _combat_system: = get_parent().get_parent()

func _on_pressed() -> void:
	var _player = _combat_system.game_controller.player
	
	_combat_system.set_disable_buttons(true)
	_combat_system.player_damage = damage
	
	_player.reduce_effort(effort_needed)
	yield(_player.attack(), "completed")
	
	_combat_system.start_prompt()
