extends Node

var main_menu_music = load("res://src/audio/music/godot_cozy_game_music_main_menu.wav")
var battle_music = load("res://src/audio/music/godot_cozy_game_music_battle.wav")
var level_music = load("res://src/audio/music/godot_cozy_game_music_level.wav")

func _ready():
	pass

func init_music():
	$MusicMainMenu.stream = main_menu_music
	$MusicLevel.stream = level_music
	$MusicBattle.stream = battle_music
	
	$MusicLevel.volume_db = -80
	$MusicBattle.volume_db = -80
	$MusicMainMenu.volume_db = 0
	
	$MusicMainMenu.play()
	$MusicLevel.play()
	$MusicBattle.play()

func fade_level_music_from_main_menu():
	$MusicLevel.volume_db = 0
	$MusicMainMenu.volume_db = -80
	$MusicBattle.volume_db = -80
	$MusicMainMenu.stop()

func fade_level_music():
	$MusicLevel.volume_db = 0
	$MusicBattle.volume_db = -80

func fade_battle_music():
	$MusicBattle.volume_db = 0
	$MusicLevel.volume_db = -80
