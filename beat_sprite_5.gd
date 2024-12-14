extends Sprite2D

func _on_correct_control__is_ranging(is_it: bool) -> void:
	if is_it:
		modulate = Color(0, 1, 0)
	else:
		modulate = Color(1, 1, 1)
