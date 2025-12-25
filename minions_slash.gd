extends CharacterBody2D

@onready var player = get_parent().find_child("player")
@onready var sprite = $Sprite2D
@onready var dash_hitbox = $DashHitbox


var direction : Vector2
var is_dashing = false
var dash_speed = 250
var can_dash = false

var dash_duration = 0.25
var dash_time_left = 0.0
var hit_player = false

var player_in_range = false
var dash_direction : Vector2

func _process(_delta):
	direction = player.position - position
	

func _physics_process(delta):
	if is_dashing:
		dash_time_left -= delta
		var collision_info = move_and_collide((player.global_position-global_position).normalized() * dash_speed * delta)
		if collision_info and !hit_player:
			var body = collision_info.get_collider()
			if body.has_method("take_damage"):
				body.take_damage()
				hit_player = true
		if dash_time_left <= 0:
			is_dashing = false
			hit_player = false
			$Timer.start()
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
	if body == player:
		player_in_range = true
		if can_dash and !is_dashing:
			dash()

func _on_player_detection_body_exited(body):
	if body == player:
		player_in_range = false

func _on_timer_timeout():
	can_dash = true
	if player_in_range and !is_dashing:
		dash()

func _ready():
	$Timer.start()
	dash_hitbox.monitoring = true
	dash_hitbox.connect("body_entered", Callable(self, "_on_dash_hitbox_body_entered"))

func dash():
	is_dashing = true
	can_dash = false
	dash_time_left = dash_duration
	hit_player = false
	dash_direction = (player.global_position-global_position).normalized()
	dash_hitbox.monitoring = false

func _on_dash_hitbox_body_entered(body):
	if body == player and !hit_player:
		body.take_damage()
		hit_player = true
