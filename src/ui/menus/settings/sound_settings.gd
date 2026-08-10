extends VBoxContainer

@onready var sfx_slider: HSlider = %SfxSlider


func _ready() -> void:
	sfx_slider.value_changed.connect(AudioBus.set_sfx_volume)
