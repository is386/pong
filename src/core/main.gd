class_name MainGame
extends Node

const PLAYER_SCENE_UID: String = "uid://bk2cu2ameptuy"

var players: Array[Player] = []

# Managers
@onready var level_manager: LevelManager = %LevelManager

# Game World root nodes
@onready var entity_root: Node2D = %EntityRoot
@onready var effect_root: Node2D = %EffectRoot

# UI Root Nodes
@onready var hud_root: Control = %HudRoot
@onready var menu_layer: CanvasLayer = %MenuLayer
@onready var transition_root: Control = %TransitionRoot


func _ready() -> void:
	SignalBus.game_started.connect(_on_game_started)
	SignalBus.game_exit_to_title_requested.connect(_on_game_exit_to_title_requested)
	SignalBus.game_close_requested.connect(_close_game)
	SignalBus.game_pause_requested.connect(_pause_game)
	SignalBus.game_resume_requested.connect(_resume_game)


func _unhandled_input(event: InputEvent) -> void:
	if OS.is_debug_build() and event.is_action_pressed("debug_quit"):
		_close_game()


func _pause_game() -> void:
	if get_tree().paused or level_manager.current_level == null:
		return

	get_tree().paused = true
	SignalBus.game_paused.emit()


func _resume_game() -> void:
	if not get_tree().paused:
		return

	get_tree().paused = false
	SignalBus.game_resumed.emit()


func _on_game_started(level_uid: String) -> void:
	if level_uid.is_empty():
		push_error("Cannot start the game without a level")
		return

	_hide_menus()
	_init_players()
	load_level(level_uid)


func _on_game_exit_to_title_requested() -> void:
	get_tree().paused = false

	_hide_menus()
	_clear_world()

	await get_tree().process_frame

	SignalBus.game_exited_to_menu.emit()


func _clear_world() -> void:
	for root: Node2D in [entity_root, effect_root]:
		for child: Node in root.get_children():
			child.queue_free()

	players = []


func _hide_menus() -> void:
	for root: Node in menu_layer.get_children():
		for menu: Node in root.get_children():
			if menu is CanvasItem:
				(menu as CanvasItem).hide()


func load_level(level_scene: String) -> BaseLevel:
	var level: BaseLevel = await level_manager.load_level(level_scene)
	if level == null:
		return null

	_place_players_at_level_spawn()

	SignalBus.level_loaded.emit(level)
	return level


func _init_players() -> void:
	if not players.is_empty():
		return

	var player_scene: PackedScene = ResourceLoader.load(PLAYER_SCENE_UID) as PackedScene
	if player_scene == null:
		push_error("Could not load player scene: " + PLAYER_SCENE_UID)
		return

	var player1 := player_scene.instantiate() as Player
	var player2 := player_scene.instantiate() as Player
	if player1 == null or player2 == null:
		push_error("Loaded player scene does not extend player or DNE: " + PLAYER_SCENE_UID)
		return

	player2.is_player_one = false
	players.append(player1)
	players.append(player2)

	entity_root.add_child(player1)
	entity_root.add_child(player2)


func _place_players_at_level_spawn() -> void:
	if players.is_empty():
		return
	if level_manager.current_level == null:
		push_error("Cannot place players into level because level is null")
		return

	players[0].global_position = level_manager.current_level.get_spawn_point(&"SpawnP1")
	players[1].global_position = level_manager.current_level.get_spawn_point(&"SpawnP2")


func _close_game() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()
