class_name Player
extends CharacterBody2D

@export var speed: float = 100

var is_player_one: bool = true
var is_ai: bool = false
var _controller: Controller


func _ready() -> void:
	if not is_player_one and is_ai:
		_controller = AiController.new()
		return

	if is_player_one:
		_controller = PlayerController.new("move_up_p1", "move_down_p1")
	else:
		_controller = PlayerController.new("move_up_p2", "move_down_p2")


func _physics_process(_delta: float) -> void:
	var direction := _controller.get_movement_direction()
	if direction:
		velocity.y = direction * speed
	else:
		velocity.y = direction * move_toward(absf(velocity.y), 0, _delta)

	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		SignalBus.game_pause_requested.emit()
	get_viewport().set_input_as_handled()
