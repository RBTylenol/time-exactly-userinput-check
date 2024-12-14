extends Node2D

@export var judge_range: float = 0.1
@onready var music_system = $"../MusicSystem"
@export var correct_beat_quarter: Array[int] = [0, 4, 8, 12, 16, 20, 24, 28, 32, 36]

var forward_correct_time: Array[float] = []
var backward_correct_time: Array[float] = []
var judge_index: int = 0

signal _is_ranging(is_it: bool)

func reset_correct_timing() -> void:
	forward_correct_time.clear()
	backward_correct_time.clear()
	for i in correct_beat_quarter:
		var temp_time = music_system.beat_16th_interval * 4 * i
		forward_correct_time.append(temp_time - judge_range)
		backward_correct_time.append(temp_time + judge_range)

func _process(_delta: float) -> void:
	if music_system.music_node.playing:
		judge()

func judge() -> void:
	var current_position = music_system.music_node.get_playback_position()
	
	if current_position < forward_correct_time[judge_index]:
		emit_signal("_is_ranging", false)
		return

	if current_position <= backward_correct_time[judge_index]:
		emit_signal("_is_ranging", true)
	else:
		if judge_index < forward_correct_time.size() - 1:
			judge_index += 1
		emit_signal("_is_ranging", false)

func _on_music_system__you_can_reset_correct_timing() -> void:
	reset_correct_timing()
