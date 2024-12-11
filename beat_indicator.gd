extends Node2D

@onready var music_system = $"../../../MusicSystem"
@onready var sprites = [ $BeatSprite1, $BeatSprite2, $BeatSprite3, $BeatSprite4 ]

var beat : int = 0
var compare_beat_because_print : int = 0

func _process(_delta: float) -> void:
	compare_beat_because_print = beat
	beat = music_system.beat_qurter

	if beat == compare_beat_because_print:
		return

	var current_index = (beat - 1) % 4
	print("beat: ", current_index + 1)

	for i in range(sprites.size()):
		if i == current_index:
			if i % 4 == 0:
				sprites[i].modulate = Color(1, 0, 0)
			else:
				sprites[i].modulate = Color(0, 0, 1)
			var tween = get_tree().create_tween()
			tween.tween_property(sprites[i], "modulate", Color(1, 1, 1), 0.5)
