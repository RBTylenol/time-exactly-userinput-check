extends Label

func _on_correct_control__is_ranging(is_it: bool) -> void:
	if Input.is_action_just_pressed("key_dot"):
		if is_it:
			text = "Perfect"
		else:
			text = "bad"
		
		await get_tree().create_timer(1.0).timeout
		text=""
