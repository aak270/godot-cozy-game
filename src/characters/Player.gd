extends KinematicBody2D

enum PlayerState{
	MOVE,
	COMBAT
}

export var speed: = 200
export var accel: = 1500
export var friction: = 1800
export var max_effort: = 100

export var combat_position_path: NodePath

var _direction: = Vector2.ZERO
var _velocity: = Vector2.ZERO

var _combat_position: Node
var _state = PlayerState.MOVE

onready var effort: = max_effort setget set_effort
onready var _remote_transform: = $RemoteTransform2D
onready var _anime_manager: = $PlayerAnimMenager

func set_effort(value: int) -> void:
	effort = value
	if effort <= 0:
		effort = 0
	
	var size: = (float(effort) / max_effort) * 200
	EventHandler.emit_signal("effort_changed", size)
	
func _ready() -> void:
	_combat_position = get_node(combat_position_path)
	EventHandler.connect("combat_started", self, "start_combat")
	
func _process(_delta: float) -> void:
	if _state == PlayerState.MOVE:
		_direction = Vector2.ZERO
		_direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		_direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		_direction = _direction.normalized()

func _physics_process(delta: float) -> void:	
	if _direction != Vector2.ZERO:
		_velocity = _velocity.move_toward(_direction * speed, accel * delta)
	else:
		_velocity = _velocity.move_toward(Vector2.ZERO, friction * delta)
	
	_velocity = move_and_slide(_velocity)

func start_combat(enemy) -> void:
	_velocity = Vector2.ZERO
	_direction = Vector2.ZERO
	_state = PlayerState.COMBAT
	_remote_transform.update_position = false
	global_position = _combat_position.global_position
	_anime_manager.combat()
	
func can_move() -> bool:
	return _state == PlayerState.MOVE
