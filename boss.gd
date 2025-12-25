extends CharacterBody2D

@onready var progress_bar = $UI/ProgressBar

var health = 50:
	set(value):
		health = value
		progress_bar.value = value
		if value <= 0:
			progress_bar.visible = false
			$AnimationPlayer.play("Present_Opened")

func take_damage():
	health -= 1
	if health <= 0:
		queue_free()
