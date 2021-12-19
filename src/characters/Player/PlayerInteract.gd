extends Node2D
class_name PlayerInteract

var _can_interact: = false
var _interactable: Interactable = null

onready var _interact_ui: = $"../InteractionUI"
onready var _player: = get_parent()

func _ready() -> void:
	_interact_ui.hide()

func _input(_event: InputEvent) -> void:
	if _can_interact and Input.is_action_just_pressed("ui_accept"):
		_interactable.interact()
		AudioController.ui_confirm()

func set_interact(value: bool) -> void:
	if value:
		_can_interact = true
		_interact_ui.show()
		AudioController.ui_hover()

	else:
		_can_interact = false
		_interact_ui.hide()

func _on_area_entered(area: Area2D) -> void:
	if area is Enemy:
		_player.prepare_combat()
		area.interact()
	elif area is Interactable:
		_interactable = area
		set_interact(true)

func _on_area_exited(area: Area2D) -> void:
	if area is Interactable:
		area.on_exit()
		_interactable = null
		set_interact(false)
