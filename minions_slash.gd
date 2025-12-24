extends CharacterBody2D

@onready var player = get_parent().find_child("player")
@onready var sprite = $Sprite2D
@onready var collision = $"../../PlayerDetection/CollisionShape2D"

var direction : Vector2
var is_dashing = false
var dash_speed = 250

func _process(_delta):
	direction = player.position - position
	if direction.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	

func _physics_process(delta):
	if is_dashing:
		return
	velocity = direction.normalized() * 40
	move_and_collide(velocity * delta)

func scatter(pos):
	var tween_position = get_tree().create_tween()
	tween_position.tween_property(self, "global_position", pos, 0.7)
	await tween_position.finished
	$Timer.start()

func take_damage():
	health -= 1
	if health <= 0:
		queue_free()

var health = 25:
	set(value):
		health = value

func _on_player_detection_body_entered(body):
	if body != player or is_dashing:
		return
	is_dashing = true
	
	var dash_dir = (player.global_position - global_position).normalized()
	var tween = create_tween()
	tween.tween_property(self, "global_position", global_position + dash_dir * dash_speed, 0.8)
	await tween.finished
	
	is_dashing = false
