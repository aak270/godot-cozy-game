extends KinematicBody2D

export var speed: = 200
export var accel: = 1500
export var friction: = 1800

export var max_effort: = 100

export(Array, String, FILE, "*.wav") var voices_path

var voices: = []

var _direction: = Vector2.ZERO
var _velocity: = Vector2.ZERO

onready var _effort: = max_effort
onready var interact: = $Interact
onready var _remote_transform: = $RemoteTransform2D
onready var _anime_manager: = $PlayerAnimMenager
onready var _torso: = $Torso
onready var _battle: = $Battle
onready var _anim: = $AnimationPlayer
onready var _tween: = $Tween
onready var _game_controller: = $"../GameController"
	
func _ready() -> void:
	_battle.visible = false
	
	if voices_path.size() > 0:
		var i := 0
		voices.resize(voices_path.size())
		for path in voices_path:
			voices[i] = load(path)
			i += 1
	
	_game_controller.update_effort(max_effort)

func _physics_process(delta: float) -> void:	
	if _direction != Vector2.ZERO:
		_velocity = _velocity.move_toward(_direction * speed, accel * delta)
	else:
		_velocity = _velocity.move_toward(Vector2.ZERO, friction * delta)
	
	_velocity = move_and_slide(_velocity)

func move() -> void:
	_direction = Vector2.ZERO
	_direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	_direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	_direction = _direction.normalized()

func start_combat(combat_position) -> void:
	_battle.visible = true
	_torso.visible = false
	_anim.play("Battle_Idle")
	
	_tween.interpolate_property(self, "position", global_position, combat_position, 
		0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT
	)
	
	_tween.start()
	_anime_manager.combat()
	
func move_to() -> float:
	return _direction.x
	
func stop_movement() -> void:
	_velocity = Vector2.ZERO
	_direction = Vector2.ZERO

func prepare_combat() -> void:
	stop_movement()
	_remote_transform.update_position = false

func attack() -> void:
	_tween.interpolate_property(self, "position:x", global_position.x, global_position.x + 40, 
		0.1, Tween.TRANS_LINEAR, Tween.EASE_OUT
	)
	
	_tween.start()
	yield(_tween, "tween_completed")
	
	_tween.interpolate_property(self, "position:x", global_position.x, global_position.x, 
		0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT
	)
	
	_tween.start()
	yield(_tween, "tween_completed")

func attack_end() -> void:
	_tween.interpolate_property(self, "position:x", global_position.x, global_position.x - 40, 
		0.1, Tween.TRANS_LINEAR, Tween.EASE_OUT
	)
	
	_tween.start()
	yield(_tween, "tween_completed")

func get_voice():
	if voices_path.size() > 0:
		return voices[int(rand_range(0, voices.size()))]
	else:
		return null
		
func reduce_effort(value: int) -> void:
	_effort -= value
	if _effort <= 0:
		_effort = 0
	
	_game_controller.update_effort(_effort)
	
func end_combat() -> void:
	_remote_transform.update_position = true
	_battle.visible = false
	_torso.visible = true
	_anim.stop()
