class_name Player
extends CharacterBody2D

@export var speed: float = 100

var is_player_one: bool = true
var _move_up: String = "move_up_p1"
var _move_down: String = "move_down_p1"


func _ready() -> void:
	if is_player_one:
		return

	_move_up = "move_up_p2"
	_move_down = "move_down_p2"


func _physics_process(_delta: float) -> void:
	var direction := Input.get_axis(_move_up, _move_down)
	if direction:
		velocity.y = direction * speed
	else:
		velocity.y = direction * move_toward(absf(velocity.y), 0, _delta)

	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		SignalBus.game_pause_requested.emit()
		get_viewport().set_input_as_handled()
