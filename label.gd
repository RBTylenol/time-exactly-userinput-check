extends Label

@onready var correct_control = $"../../../CorrectControl"

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("key_dot"):
		if correct_control.is_ranging:
			text = "Perfect! ^^"
		else:
			text = "Bad ><"
			
		await get_tree().create_timer(1.0).timeout
		text = ""
