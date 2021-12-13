extends Control

onready var effort: = $EffortFull

func _ready() -> void:
	EventHandler.connect("effort_changed", self, "update_ui")
	
func update_ui(value: float) -> void:
	if effort != null:
		effort.rect_size.x = value
