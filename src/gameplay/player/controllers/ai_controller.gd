class_name AiController
extends Controller

var _game_manager: GameManager


func _ready() -> void:
	_game_manager = get_tree().get_first_node_in_group("game_manager") as GameManager


func move(player: Player, delta: float) -> void:
	if _game_manager.ball == null or not is_instance_valid(_game_manager.ball):
		return

	var direction := 0
	if player.global_position.y + 24 < _game_manager.ball.global_position.y + 8:
		direction = 1
	elif player.global_position.y - 24 > _game_manager.ball.global_position.y - 8:
		direction = -1

	if direction:
		player.velocity.y = direction * player.speed
	else:
		player.velocity.y = direction * move_toward(absf(player.velocity.y), 0, delta)

	player.move_and_slide()
