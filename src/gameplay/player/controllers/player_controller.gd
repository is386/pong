class_name PlayerController
extends Controller

var _move_up: String
var _move_down: String


func _init(move_up: String, move_down: String) -> void:
	_move_up = move_up
	_move_down = move_down


func get_movement_direction() -> float:
	return Input.get_axis(_move_up, _move_down)
