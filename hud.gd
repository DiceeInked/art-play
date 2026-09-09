extends CanvasLayer

@onready var player = $"../Player"
@onready var status: Label = $Margin/Panel/Status

func _process(_delta: float) -> void:
	if player.edit_mode:
		status.text = "EDIT MODE  •  Draw terrain with left click  •  Right click erases"
	else:
		status.text = "PLAY MODE  •  Walk with A / D  •  Press Space to edit the world"
