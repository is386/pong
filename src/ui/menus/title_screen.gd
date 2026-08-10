extends Control

@export var level_uid: String = ""

@onready var single_player_button: Button = %SinglePlayerButton
@onready var multiplayer_button: Button = %MultiplayerButton
@onready var settings_button: Button = %SettingsButton
@onready var close_button: Button = %CloseButton


func _ready() -> void:
	single_player_button.pressed.connect(_on_single_player_button_pressed)
	multiplayer_button.pressed.connect(_on_multiplayer_button_pressed)
	settings_button.pressed.connect(_on_settings_button_pressed)
	close_button.pressed.connect(_on_close_button_pressed)
	SignalBus.game_exited_to_menu.connect(_on_game_exited_to_menu)

	visibility_changed.connect(_on_visibility_changed)
	_on_visibility_changed()


func _on_visibility_changed() -> void:
	if visible and is_inside_tree():
		single_player_button.grab_focus.call_deferred()


func _on_game_exited_to_menu() -> void:
	show()


func _on_single_player_button_pressed() -> void:
	SignalBus.game_started.emit(level_uid, true)


func _on_multiplayer_button_pressed() -> void:
	SignalBus.game_started.emit(level_uid, false)


func _on_settings_button_pressed() -> void:
	SignalBus.settings_requested.emit(self)


func _on_close_button_pressed() -> void:
	SignalBus.game_close_requested.emit()
