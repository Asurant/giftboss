extends CharacterBody2D

@onready var player = get_parent().find_child("player")
@onready var sprite = $Sprite2D

var direction : Vector2

func _process(_delta):
	direction = player.position - position
	if direction.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false

func _physics_process(delta):
	velocity = direction.normalized() * 40
	move_and_collide(velocity * delta)

func scatter(pos):
	var tween_position = get_tree().create_tween()
	tween_position.tween_property(self, "global_position", pos, 0.7)
	await tween_position.finished
	$Timer.start()
