extends Node2D
# .tscn (씬)으로 불러온 경우, 반드시 "로컬로 만들기" 해야 음악과 음악 설정을 따로 접근할 수 있음.

@onready var correct_control = $"../CorrectControl"
@export var music_node_name: String  # 타입: AudioStreamPlayer2D, 인스펙터에서 노드의 이름 입력.

var music_node: AudioStreamPlayer2D

@export var bpm: float  # bpm, 인스펙터에서 값 입력
var beat_quarter_interval : float
var next_beat_quarter_time : float = 0.0
var beat_quarter : int = 0

var beat_16th_interval : float
var next_beat_16th_time : float = 0.0
var beat_16th : int = 0

var is_ready = false  # _ready 함수가 다 돌기 위한 판정
var is_music_started = false  # 음악이 시작되었는지 여부
var music_start_time : float

var music_system_quarter_output : int = -1  #-1 = 음악 재생 중 아님 및 준비 안 됨, 0 = not 박자 타이밍, 1 = 박자 타이밍
var music_system_16th_output : int = -1

func _ready() -> void:
	set_music_node()
	is_ready = true  # 초기화 완료
	print("_Ready 완료")

func _process(_delta: float) -> void:
	if music_node == null:
		return
	
	if not is_ready:
		return  # _ready가 끝나지 않으면 _process 실행 안 함

	#이게 이렇게 세트임. 아래 조건 등은 변경할 것.
	if Input.is_action_just_pressed("ui_accept") and not is_music_started:
		start_music()
		correct_control.reset_correct_timing()
		
	elif Input.is_action_just_pressed("ui_accept") and music_node.playing:
		stop_music()
	# 음악이 시작되었을 때만 박자 계산.
	if is_music_started:
		check_beat()

func set_music_node() -> void:  # music_node 변수에 music_node_name 이름을 가진 노드 연결, 박자 처리
	music_node = get_node(music_node_name) as AudioStreamPlayer2D

	if music_node:
		print(str(music_node_name) + "이라는 MusicSystem의 하위 노드 발견")
	else:
		print(str(music_node_name) + "이라는 MusicSystem의 하위 노드 없음")

	beat_quarter_interval = 60.0 / bpm  # 박자 간격 (초 단위)
	beat_16th_interval = beat_quarter_interval / 4.0
	
	#print("beat_interval: ", beat_interval)
	music_system_quarter_output = -1
	music_system_16th_output = -1

func start_music() -> void:  #음악 재생, 음악을 재생하는 조건 미포함
	music_node.play()  # 음악 재생
	is_music_started = true  # 음악이 시작됨
	music_start_time = Time.get_ticks_msec() / 1000.0  # 현재 시간으로 박자 초기화
	
	#print("music_start_time: ", music_start_time)
	music_system_quarter_output = 0
	music_system_16th_output = 0
	beat_quarter = 0
	beat_16th = 0
	next_beat_quarter_time = 0.0
	next_beat_16th_time = 0.0

func stop_music() -> void:  #음악 종료, 음악을 종료하는 조건 미포함
	music_node.stop()
	is_music_started=false
	music_system_quarter_output = -1
	music_system_16th_output = 0
	print("음악 재생 종료")


var current_music_time
func check_beat() -> void:  #박자 계산 함수
	if not music_node.playing:
		return  # 음악이 재생 중이 아니면 박자 계산 중단

	current_music_time = music_node.get_playback_position()
	music_system_quarter_output = 0
	music_system_16th_output = 0
	
	if current_music_time >= next_beat_quarter_time: #4분음표 판정
		music_system_16th_output = 1  #16분음표 판정은 4분음표 판정에 귀속되도록 함.
		next_beat_16th_time = next_beat_quarter_time + beat_16th_interval
		beat_16th += 1
		
		music_system_quarter_output = 1
		next_beat_quarter_time += beat_quarter_interval
		beat_quarter += 1
		
	elif current_music_time >= next_beat_16th_time: #16분음표 판정
		music_system_16th_output = 1
		next_beat_16th_time += beat_16th_interval
		beat_16th += 1

func _on_music_finished() -> void:
	print("음악이 끝났습니다!")
	stop_music()
