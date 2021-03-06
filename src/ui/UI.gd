extends CanvasLayer

onready var _effort: = $Effort/ProgressBar
onready var _game_controller: = $"../GameController"

func _ready() -> void:
	var err = _game_controller.connect("effort_changed", self, "update_effort")
	if err != OK:
		print(err)
	
func update_effort(value: float) -> void:
	if _effort != null:
		_effort.value = value
