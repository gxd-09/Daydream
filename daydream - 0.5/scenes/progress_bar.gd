extends ProgressBar
@onready var player: CharacterBody2D = $".."

func _process(_delta):
	position = Vector2()
	value = player.healthbar
	#value = 90
