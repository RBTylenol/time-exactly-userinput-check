extends Node2D

@export var judge_range = 0.05
# hello??

@onready var label = $"../CanvasLayer/BoxContainer2/Label"
@onready var music_system = $"../MusicSystem"

var correct_beat : Array[int] = [1, 5, 9, 13, 17, 21, 25, 29, 33, 37, 41]

var forward_correct_time : Array[float] = [0.0]
var backward_correct_time : Array[float] = [0.0]

func reset_correct_timing() -> void:
	for i in range(correct_beat.size()):
		var temp_time = music_system.beat_interval * correct_beat[i]
		forward_correct_time.push_back(temp_time - judge_range)
		backward_correct_time.push_back(temp_time + judge_range)
		
	for i in range(correct_beat.size()):
		print("forward correct time[", i, "]: ",forward_correct_time[i])
		print("backward correct time[", i, "]: ", backward_correct_time[i])
	get_tree().create_timer(1000).timeout

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_up"): ##여기 조건에 실행되는 함수를, 음악이 실행되고 난 후에 실행될 수 있도록 코드 구성.
		reset_correct_timing()
	if event.is_action_pressed("key_dot"):
		print("점 키 눌림")
	
	var key_pressed_time = Time.get_ticks_msec()/1000.0 - music_system.music_start_time
	music_system.next_beat_time
