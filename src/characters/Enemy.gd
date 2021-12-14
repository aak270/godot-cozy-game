extends Area2D

class_name Enemy

export var combat_position_path: NodePath

var _combat_position: Node

func _ready() -> void:
	_combat_position = get_node(combat_position_path)
	
func play() -> void:
	print("Enemy attack")
	var t = Timer.new()
	t.set_wait_time(1)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")

func _on_body_entered(_body: Node) -> void:
	EventHandler.emit_signal("combat_started", self)
	global_position = _combat_position.global_position