extends NPC
class_name Enemy

export(Array, String, FILE, "*.wav") var voices_path

export var max_health: = 5
export var damage: = 10
export var vn: PackedScene

var voices: = []

var _health: = 1

onready var _overworld: = $Overworld
onready var _batlle: = $Battle
onready var _anim: = $AnimationPlayer
onready var _tween: = $Tween

func _ready() -> void:
	_health = max_health
	_batlle.visible = false
	_anim.play("Ov_Idle")
	
	if voices_path.size() > 0:
		var i := 0
		voices.resize(voices_path.size())
		for path in voices_path:
			voices[i] = load(path)
			i += 1
	
func interact() -> void:
	_game_controller.start_dialogue(_dialogues, self)

func start_combat(combat_position) -> void:
	_batlle.visible = true
	_overworld.visible = false
	
	_anim.play("Battle_Idle")
	_tween.interpolate_property(self, "position", global_position, 
		combat_position, 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT
	)
	
	_tween.start()
	
func attack() -> void:
	_tween.interpolate_property(self, "position:x", global_position.x, global_position.x - 40, 
		0.1, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.3
	)
	
	_tween.start()
	yield(_tween, "tween_completed")
	
func attack_end() -> void:
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

func get_voice():
	if voices_path.size() > 0:
		return voices[int(rand_range(0, voices.size()))]
	else:
		return null
		
func reduce_health(value: int) -> void:
	_health -= value
	_game_controller.update_enemy_hp(_health * 100 / max_health)

func is_dead() -> bool:
	return _health <= 0
