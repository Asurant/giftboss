extends State

@onready var spawn_points = owner.get_parent().find_child("SpawnPoints").get_children()
@export var minion_shoot: PackedScene
@export var minion_slash: PackedScene

func enter():
	super.enter()
	second_phase()

func spawn_minions_shoot(index):
	var minion_shoot_instance = minion_shoot.instantiate()
	minion_shoot_instance.position = global_position
	
	get_tree().current_scene.add_child(minion_shoot_instance)
	
	minion_shoot_instance.scatter(spawn_points[index].position)

func spawn_minions_slash(index):
	var minion_slash_instance = minion_slash.instantiate()
	minion_slash_instance.position = global_position
	
	get_tree().current_scene.add_child(minion_slash_instance)
	
	minion_slash_instance.scatter(spawn_points[index].position)

func second_phase():
	animation_player.play("phase_2")
	spawn_points.shuffle()
	
	spawn_minions_shoot(0)
	spawn_minions_shoot(1)
	spawn_minions_slash(2)
	spawn_minions_slash(3)
	
	
