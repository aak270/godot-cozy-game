extends Node2D

var _can_interact: = false
var _interactable: Interactable = null

onready var _interact_ui: = $"../InteractionUI"

func _ready() -> void:
	_interact_ui.hide()

func _input(_event: InputEvent) -> void:
	if _can_interact and Input.is_action_just_pressed("ui_accept"):
		_interactable.interact()

func _on_area_entered(area: Area2D) -> void:
	if area is Interactable:
		_can_interact = true
		_interactable = area
		_interact_ui.show()

func _on_area_exited(area: Area2D) -> void:
	if area is Interactable:
		_can_interact = false
		_interactable = null
		_interact_ui.hide()
