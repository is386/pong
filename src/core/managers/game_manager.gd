class_name GameManager
extends Node

signal score_updated
signal game_over(player_one_wins: bool)

@export var ball_scene: PackedScene
@export var entity_root: Node
@export var start_delay_seconds: float = 3
@export var max_score: int = 3

var player_one_points: int
var player_two_points: int
var ball: Ball
var _delay_timer: Timer


func _ready() -> void:
	_delay_timer = Timer.new()
	_delay_timer.wait_time = start_delay_seconds
	_delay_timer.one_shot = true
	_delay_timer.timeout.connect(_on_delay_timer_timeout)
	add_child(_delay_timer)


func reset() -> void:
	player_one_points = 0
	player_two_points = 0
	score_updated.emit()


func spawn_ball() -> void:
	_delay_timer.start()


func _spawn_ball() -> void:
	ball = ball_scene.instantiate() as Ball
	var s := 1 if randi() % 2 else -1
	ball.global_position = Vector2(0, -150)
	ball.velocity = Vector2(s * ball.speed, ball.speed / 3)
	ball.scored.connect(_on_scored)
	entity_root.add_child(ball)


func _on_scored(is_player_one: bool) -> void:
	if is_player_one:
		player_one_points += 1
	else:
		player_two_points += 1

	score_updated.emit()

	if player_one_points == max_score:
		game_over.emit(true)
		return
	elif player_two_points == max_score:
		game_over.emit(false)
		return

	spawn_ball()


func _on_delay_timer_timeout() -> void:
	_spawn_ball()
