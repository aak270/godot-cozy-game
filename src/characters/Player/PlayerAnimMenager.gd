extends AnimationTree

#var playback : AnimationNodeBlendSpace1D
var playback : AnimationNodeStateMachinePlayback

onready var player: = get_parent()

func _ready() -> void:
	playback = get("parameters/StateMachine/playback")
	playback.start("idleR")

func _process(_delta):
	var x = player.move_to()
	if x < 0:
		playback.travel("idle")
		player.look_left = true
	if x > 0:
		playback.travel("idleR")
		player.look_left = false

func combat() -> void:
	playback.travel("idleR")
