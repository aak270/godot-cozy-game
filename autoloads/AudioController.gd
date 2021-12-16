extends Node

var amb_bubbly = load("res://src/audio/ambience/godot_cozy_game_ambience_bubbly.wav")
var amb_danger = load("res://src/audio/ambience/godot_cozy_game_ambience_danger.wav")
var amb_flow = load("res://src/audio/ambience/godot_cozy_game_ambience_flow.wav")
var amb_noise = load("res://src/audio/ambience/godot_cozy_game_ambience_noise.wav")
var amb_trippy = load("res://src/audio/ambience/godot_cozy_game_ambience_trippy.wav")

func _ready():
	pass

func init_ambience():
	$AmbienceBubbly.stream = amb_bubbly
	$AmbienceDanger.stream = amb_danger
	$AmbienceFlow.stream = amb_flow
	$AmbienceNoise.stream = amb_noise
	$AmbienceTrippy.stream = amb_trippy

func ambience_level_from_main_menu():
	$AmbienceBubbly.play()
	$AmbienceFlow.play()
	$AmbienceNoise.play()

func ambience_level():
	$AmbienceDanger.stop()
	
	$AmbienceBubbly.play()
	$AmbienceFlow.play()

func ambience_battle():
	$AmbienceBubbly.stop()
	$AmbienceFlow.stop()
	
	$AmbienceDanger.play()

func ui_confirm():
	$UIConfirm.play()

func ui_back():
	$UIBack.play()

func ui_error():
	$UIError.play()

func ui_hover():
	$UIHover.play()
