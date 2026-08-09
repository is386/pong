class_name GameManager
extends Node

@export var ball_scene: PackedScene
@export var entity_root: Node
@export var start_delay_seconds: float = 3

var player_one_points: int
var player_two_points: int
var _delay_timer: Timer


func _ready() -> void:
	_delay_timer = Timer.new()
	_delay_timer.wait_time = start_delay_seconds
	_delay_timer.one_shot = true
	_delay_timer.timeout.connect(_on_delay_timer_timeout)
	add_child(_delay_timer)


func start_game() -> void:
	_delay_timer.start()


func _spawn_ball() -> void:
	var ball := ball_scene.instantiate() as Ball
	var s := 1 if randi() % 2 else -1
	ball.global_position = Vector2(0, -150)
	ball.velocity = Vector2(s * ball.speed, ball.speed / 2)
	ball.scored.connect(_on_scored)
	entity_root.add_child(ball)


func _on_scored(is_player_one: bool) -> void:
	if is_player_one:
		player_one_points += 1
	else:
		player_two_points += 1

	start_game()


func _on_delay_timer_timeout() -> void:
	_spawn_ball()
