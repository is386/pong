class_name Ball
extends CharacterBody2D

signal scored(is_player_one: bool)

const MAX_SPEED_MULTIPLIER = 2

@export var speed: float = 100

@onready var visible_notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

var _speed_multiplier: float = 1
var _last_player_collided: Player = null


func _ready() -> void:
	velocity = Vector2(speed, 0)
	visible_notifier.screen_exited.connect(_on_screen_exited)


func _physics_process(delta: float) -> void:
	var collision := move_and_collide(velocity * delta)
	if collision == null:
		return

	velocity = velocity.bounce(collision.get_normal())

	if collision.get_collider() is Player:
		var player := collision.get_collider() as Player
		_last_player_collided = player
		var velocity_bounce := velocity

		velocity = global_position - player.global_position
		velocity = velocity.normalized() * speed
		velocity = (0.75 * velocity) + (0.25 * velocity_bounce)

		_speed_multiplier = min(MAX_SPEED_MULTIPLIER, _speed_multiplier + 0.1)
		velocity.x *= _speed_multiplier


func _on_screen_exited() -> void:
	scored.emit(_last_player_collided.is_player_one)
	queue_free()
