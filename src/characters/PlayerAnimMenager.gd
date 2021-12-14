extends AnimationTree

#var playback : AnimationNodeBlendSpace1D
var playback : AnimationNodeStateMachinePlayback

onready var player: = get_parent()

func _ready() -> void:
	playback = get("parameters/StateMachine/playback")
	playback.start("idleR")

func _process(delta):
	if player.can_move() and Input.is_action_just_pressed("ui_left"):
		playback.travel("idle")
	if player.can_move() and Input.is_action_just_pressed("ui_right"):
		playback.travel("idleR")
