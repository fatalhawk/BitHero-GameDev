extends MarginContainer

@onready var timer = $LetterDisplayTimer
@onready var label = $MarginContainer/Label

const MAX_WIDTH = 160

var text = ""
var letter_index = 0

var letter_time = 0.03
var space_time = 0.06
var punctuation_time = 0.2

signal finished_displaying

func display_text(text_to_display : String):
	text = text_to_display
	label.text = text_to_display
	
	await resized
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	
	if size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized  #wait for x
		await resized  #wait for y
		custom_minimum_size.y = size.y
		
	global_position.x -= size.x / 2
	global_position.y -= size.y + 24    # little above speaker
	
	label.text = ""
	
	display_letter()
	
	
func display_letter():
	if letter_index >= text.length():
		finished_displaying.emit()
		return
		
	label.text += text[letter_index]
	
	match text[letter_index]:
		",", ".", "!", "?":
			timer.start(punctuation_time)
		" ":
			timer.start(space_time)
		_:
			timer.start(letter_time)

	letter_index += 1
	
func _on_letter_display_timer_timeout() -> void:
	display_letter()
