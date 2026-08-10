extends Node

const SFX_BUS: StringName = &"SFX"

const SFX_POOL_SIZE: int = 8

var _sfx_players: Array[AudioStreamPlayer] = []


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	for _i: int in SFX_POOL_SIZE:
		_sfx_players.append(_create_player(SFX_BUS))


func play_sfx(stream: AudioStream) -> void:
	if stream == null:
		return

	for _sfx_player: AudioStreamPlayer in _sfx_players:
		if not _sfx_player.playing:
			_sfx_player.stream = stream
			_sfx_player.play()
			return


func set_sfx_volume(linear_volume: float) -> void:
	_set_bus_volume(SFX_BUS, linear_volume)


func _set_bus_volume(bus_name: StringName, linear_volume: float) -> void:
	var bus_index: int = AudioServer.get_bus_index(bus_name)
	if bus_index < 0:
		push_error("Audio bus '%s' is missing from the bus layout" % bus_name)
		return

	var volume: float = clampf(linear_volume, 0.0, 1.0)
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(volume))

	AudioServer.set_bus_mute(bus_index, is_zero_approx(volume))


func _create_player(bus_name: StringName) -> AudioStreamPlayer:
	var player: AudioStreamPlayer = AudioStreamPlayer.new()
	player.bus = bus_name
	add_child(player)
	return player
