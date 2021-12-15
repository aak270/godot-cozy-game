extends Control

onready var anim_player: = $AnimationPlayer
onready var background: = $Background
onready var fight_button: = $Background/Panel/FightButton
onready var player: = $"../../Player"

func _ready() -> void:
	visible = false
	background.visible = false
	EventHandler.connect("battle_started", self, "init")
	
func init() -> void:
	visible = true
	anim_player.play("fade_in")
	get_tree().paused = true

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "fade_in":
		anim_player.play("fade_out")
		background.visible = true
		fight_button.grab_focus()

func _on_RunButton_pressed() -> void:
	get_tree().paused = false
	visible = false
	background.visible = false

func _on_FightButton_pressed() -> void:
	player.effort -= 10
