extends KinematicBody2D

export var speed: = 200
export var accel: = 500
export var friction: = 800

var _direction: = Vector2.ZERO
var _velocity: = Vector2.ZERO

func _physics_process(delta: float) -> void:
	_direction = Vector2.ZERO
	_direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	_direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	_direction = _direction.normalized()
	
	if _direction != Vector2.ZERO:
		_velocity = _velocity.move_toward(_direction * speed, accel * delta)
	else:
		_velocity = _velocity.move_toward(Vector2.ZERO, friction * delta)
	
	_velocity = move_and_slide(_velocity)
