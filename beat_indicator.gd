extends Node2D

@onready var sprites = [ $BeatSprite1, $BeatSprite2, $BeatSprite3, $BeatSprite4 ]
@onready var sprites2 = [$BeatSprite5, $BeatSprite6, $BeatSprite7, $BeatSprite8]

func _on_music_system__beat_quarter(beat: int) -> void:
	
	if beat % 4 == 0:
		
		sprites[0].modulate = Color(1, 0, 0)
		var tween = get_tree().create_tween()
		tween.tween_property(sprites[0], "modulate", Color(1, 1, 1), 0.1)
		
	else:
		sprites[beat % 4].modulate = Color(0, 0, 1)
		var tween = get_tree().create_tween()
		tween.tween_property(sprites[beat % 4], "modulate", Color(1, 1, 1), 0.1)
		
func _on_music_system__beat_16_th(beat: int) -> void:
	if beat % 4 == 0:
		sprites2[0].modulate = Color(1, 0, 0)
		var tween = get_tree().create_tween()
		tween.tween_property(sprites2[0], "modulate", Color(1, 1, 1), 0.2)
		
	else:
		sprites2[beat % 4].modulate = Color(0, 0, 1)
		var tween = get_tree().create_tween()
		tween.tween_property(sprites2[beat % 4], "modulate", Color(1, 1, 1), 0.2)
