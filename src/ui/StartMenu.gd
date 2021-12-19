extends VBoxContainer

onready var new_game_btn: = $NewGameButton

func _ready() -> void:
	new_game_btn.grab_focus()
	MusicController.init_music()
	AudioController.init_ambience()

func _on_NewGameButton_pressed() -> void:
	get_tree().change_scene("res://src/scenes/Game.tscn")
	AudioController.ui_confirm()
	MusicController.fade_level_music_from_main_menu()
	AudioController.ambience_level_from_main_menu()

func _on_QuitButton_button_up() -> void:
	AudioController.ui_confirm()
	get_tree().quit()
