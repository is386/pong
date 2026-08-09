extends Control

@export var game_manager: GameManager

@onready var player_one_score: Label = %PlayerOneScore
@onready var player_two_score: Label = %PlayerTwoScore


func _ready() -> void:
	game_manager.score_updated.connect(_on_score_updated)


func _on_score_updated() -> void:
	player_one_score.text = str(game_manager.player_one_points)
	player_two_score.text = str(game_manager.player_two_points)
