extends State

@export var bullet_node : PackedScene
@onready var timer = $Timer

func enter():
	super.enter()
	timer.start()
	
func exit():
	super.exit()
	timer.stop()

func shoot():
	var bullet = bullet_node.instantiate()
	
	bullet.position = global_position
	bullet.direction = (player.global_position - global_position).normalized()
	
	get_tree().current_scene.call_deferred("add_child", bullet)


func _on_timer_timeout():
	shoot()

func transition():
	if progress_bar.value <= 40:
		get_parent().change_state("Hoard")
