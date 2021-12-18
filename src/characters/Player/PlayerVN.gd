extends Sprite

onready var _bothered: = $Bothered
onready var _bothered_ant_l: = $Bothered_Ant_L
onready var _bothered_ant_r: = $Bothered_Ant_R

func flip(value: bool) -> void:
	_bothered.flip_h = value
	
	if value:
		_bothered_ant_l.show()
		_bothered_ant_r.hide()
	else:
		_bothered_ant_l.hide()
		_bothered_ant_r.show()
