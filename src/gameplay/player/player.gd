class_name Player
extends CharacterBody2D

@export var speed: float = 100

var is_player_one: bool = true
var is_ai: bool = false
var _controller: Controller


func _ready() -> void:
	if not is_player_one and is_ai:
		speed = 112
		_controller = AiController.new()
	elif is_player_one:
		_controller = PlayerController.new("move_up_p1", "move_down_p1")
	else:
		_controller = PlayerController.new("move_up_p2", "move_down_p2")

	add_child(_controller)


func _physics_process(delta: float) -> void:
	_controller.move(self, delta)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		SignalBus.game_pause_requested.emit()
	get_viewport().set_input_as_handled()
