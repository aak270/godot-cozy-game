extends KinematicBody2D

export var speed: = 200
export var accel: = 500
export var friction: = 800
export var max_effort: = 100

var _direction: = Vector2.ZERO
var _velocity: = Vector2.ZERO

var _can_interact: = false
var _interaction_target: Node = null

onready var effort: = max_effort setget set_effort
onready var _interaction_ui: = $InteractionUI

func set_effort(value: int) -> void:
	effort = value
	if effort <= 0:
		effort = 0
	
	var size: = (float(effort) / max_effort) * 200
	EventHandler.emit_signal("effort_changed", size)
	
func _ready() -> void:
	_interaction_ui.hide()
	
func _process(delta: float) -> void:
	_direction = Vector2.ZERO
	_direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	_direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	_direction = _direction.normalized()
	
	if _interaction_target != null and Input.is_action_just_pressed("ui_accept"):
		_interaction_target.interact()

func _physics_process(delta: float) -> void:	
	if _direction != Vector2.ZERO:
		_velocity = _velocity.move_toward(_direction * speed, accel * delta)
	else:
		_velocity = _velocity.move_toward(Vector2.ZERO, friction * delta)
	
	_velocity = move_and_slide(_velocity)

func update_interactable(object: Node) -> void:
	if object != null:
		_can_interact = true
		_interaction_target = object
		_interaction_ui.show()
	else:
		_can_interact = false
		_interaction_target = null
		_interaction_ui.hide()
