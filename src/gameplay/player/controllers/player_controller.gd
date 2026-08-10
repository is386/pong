class_name PlayerController
extends Controller

var _move_up: String
var _move_down: String


func _init(move_up: String, move_down: String) -> void:
	_move_up = move_up
	_move_down = move_down


func move(player: Player, delta: float) -> void:
	var direction := Input.get_axis(_move_up, _move_down)
	if direction:
		player.velocity.y = direction * player.speed
	else:
		player.velocity.y = direction * move_toward(absf(player.velocity.y), 0, delta)

	player.move_and_slide()
