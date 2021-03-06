extends Control

onready var _new_game_btn: = $NewGameButton
onready var _quit_btn: = $QuitButton

func _ready() -> void:
	_new_game_btn.grab_focus()
	MusicController.init_music()
	AudioController.init_ambience()
	
func disable_buttons() -> void:
	_new_game_btn.disabled = true
	_quit_btn.disabled = true

func _on_NewGameButton_pressed() -> void:
	_new_game_btn.modulate = Color(0.33, 0.59, 0.53)
	disable_buttons()
	
	yield(AudioController.ui_confirm(), "completed")
	MusicController.fade_level_music_from_main_menu()
	AudioController.ambience_level_from_main_menu()
	
	get_tree().change_scene("res://src/scenes/Level1.tscn")

func _on_QuitButton_pressed() -> void:
	_quit_btn.modulate = Color(0.33, 0.59, 0.53)
	disable_buttons()
	yield(AudioController.ui_confirm(), "completed")
	get_tree().quit()

func _on_NewGameButton_focus_entered() -> void:
	_new_game_btn.modulate = Color(0.69, 1, 0.93)
	AudioController.ui_hover()

func _on_QuitButton_focus_entered() -> void:
	_quit_btn.modulate = Color(0.69, 1, 0.93)
	AudioController.ui_hover()

func _on_NewGameButton_focus_exited() -> void:
	_new_game_btn.modulate = Color(1, 1, 1)
	AudioController.ui_hover()

func _on_QuitButton_focus_exited() -> void:
	_quit_btn.modulate = Color(1, 1, 1)
	AudioController.ui_hover()
