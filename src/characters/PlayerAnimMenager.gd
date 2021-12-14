extends AnimationTree

#var playback : AnimationNodeBlendSpace1D
var playback : AnimationNodeStateMachinePlayback

func _ready() -> void:
	playback = get("parameters/StateMachine/playback")
	playback.start("idleR")
	

func _process(delta):
	if Input.is_action_just_pressed("ui_left"):
		playback.travel("idle")
	if Input.is_action_just_pressed("ui_right"):
		playback.travel("idleR")
	
