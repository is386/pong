extends Control

@export var game_manager: GameManager

@onready var winner_label: Label = %WinnerLabel
@onready var restart_button: Button = %RestartButton
@onready var exit_to_menu_button: Button = %ExitToMenuButton


func _ready() -> void:
	restart_button.pressed.connect(_on_restart_button_pressed)
	exit_to_menu_button.pressed.connect(_on_exit_to_menu_button_pressed)
	visibility_changed.connect(_on_visibility_changed)
	game_manager.game_over.connect(_on_game_over)


func _on_visibility_changed() -> void:
	if visible and is_inside_tree():
		restart_button.grab_focus.call_deferred()


func _on_restart_button_pressed() -> void:
	SignalBus.game_restart_requested.emit()


func _on_exit_to_menu_button_pressed() -> void:
	SignalBus.game_exit_to_title_requested.emit()


func _on_game_over(player_one_wins: bool) -> void:
	show()
	if player_one_wins:
		winner_label.text = "Player 1 Wins!"
	else:
		winner_label.text = "Player 2 Wins!"
