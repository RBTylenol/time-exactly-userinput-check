extends Node2D

@export var music_node_name: String  # AudioStreamPlayer2D 노드 이름
@export var bgm_stream: AudioStream
@export var bpm: float  # BPM 값

var music_node: AudioStreamPlayer2D
var beat_16th_interval: float
var next_beat_16th_time: float = 0.0
var beat_16th: int = 0

var beat_triplet_interval: float
var next_beat_triplet_time: float = 0.0
var beat_triplet: int = 0

signal _beat_quarter(beat: int)
signal _beat_16th(beat: int)
signal _beat_triplet(beat: int)
signal _you_can_reset_correct_timing

func _ready() -> void:
	music_node = get_node(music_node_name) as AudioStreamPlayer2D
	if bgm_stream:
		music_node.stream = bgm_stream
	beat_16th_interval = 60.0 / bpm / 4.0
	beat_triplet_interval = 60.0 / bpm / 3.0

func _process(_delta: float) -> void:
	if not music_node:
		return

	if Input.is_action_just_pressed("ui_accept"):
		if music_node.playing:
			stop_music()
		else:
			start_music()

	if music_node.playing:
		var current_position = music_node.get_playback_position()
		var expected_position = next_beat_16th_time
		var error = current_position - expected_position
		
		if current_position >= next_beat_16th_time:
			emit_signal("_beat_16th", beat_16th)
			if beat_16th % 4 == 0:
				emit_signal("_beat_quarter", beat_16th / 4)
				
			beat_16th += 1
			# 다음 비트 시간 업데이트 및 보정 적용
			next_beat_16th_time += beat_16th_interval
			
			# 오차가 너무 크지 않도록 제한 (예: ±50ms)
			const ERROR_LIMIT = 0.05  # 초 단위 (50ms)
			if abs(error) > ERROR_LIMIT:
				next_beat_16th_time += error * 0.5  # 오차의 절반만큼 보정
				
		if current_position >= next_beat_triplet_time:
			emit_signal("_beat_triplet", beat_triplet)
			beat_triplet += 1
			
			if beat_triplet % 3 == 0 and beat_16th % 4 == 0:
				next_beat_triplet_time = next_beat_16th_time - beat_16th_interval
				
			next_beat_triplet_time += beat_triplet_interval

func start_music() -> void:
	music_node.play()
	emit_signal("_you_can_reset_correct_timing")
	reset_beat_timing()

func stop_music() -> void:
	music_node.stop()
	print("음악 재생 종료")

func reset_beat_timing() -> void:
	next_beat_16th_time = 0.0
	beat_16th = 0
	next_beat_triplet_time = 0.0
	beat_triplet = 0
	emit_signal("_beat_quarter", beat_16th / 4)

func _on_music_finished() -> void:
	print("음악이 끝났습니다!")
	stop_music()
