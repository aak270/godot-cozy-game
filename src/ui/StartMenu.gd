extends VBoxContainer

onready var new_game_btn: = $NewGameButton

func _ready() -> void:
	new_game_btn.grab_focus()

func _on_NewGameButton_pressed() -> void:
	get_tree().change_scene("res://src/scenes/Game.tscn")

func _on_QuitButton_button_up() -> void:
	get_tree().quit()
