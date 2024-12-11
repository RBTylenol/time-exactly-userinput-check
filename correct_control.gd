extends Node2D
# 지금은 4분음표 기준으로 짜져 있는데, 16분음표 기준으로 변경해야 함.
@export var judge_range = 0.1

@onready var label = $"../CanvasLayer/BoxContainer2/Label"
@onready var music_system = $"../MusicSystem"

@export var correct_beat_quarter : Array[int] = [0, 4, 8, 12, 16, 20, 24, 28, 32, 36]

var forward_correct_time : Array[float] = []
var backward_correct_time : Array[float] = []

var is_ranging = false
var judge_index : int = 0

func reset_correct_timing() -> void:
	for i in range(correct_beat_quarter.size()):
		var temp_time = music_system.beat_quarter_interval * correct_beat_quarter[i]
		forward_correct_time.push_back(temp_time - judge_range)
		backward_correct_time.push_back(temp_time + judge_range)

func _process(_delta: float) -> void:
	judge()

func judge() -> void:
	if music_system.music_system_quarter_output == -1:
		return
		
	if forward_correct_time[judge_index] <= music_system.current_music_time and music_system.current_music_time <= backward_correct_time[judge_index]:
		is_ranging = true
	
	if backward_correct_time[judge_index] < music_system.current_music_time and is_ranging == true:
		if not forward_correct_time.size()-1 == judge_index:
			judge_index += 1
		is_ranging = false
